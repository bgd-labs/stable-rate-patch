```diff
diff --git a/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/adapters/BaseParaSwapAdapter.sol b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/adapters/BaseParaSwapAdapter.sol
new file mode 100644
index 0000000..9b84dd9
--- /dev/null
+++ b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/adapters/BaseParaSwapAdapter.sol
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: agpl-3.0
+pragma solidity 0.6.12;
+pragma experimental ABIEncoderV2;
+
+import {SafeMath} from '../dependencies/openzeppelin/contracts/SafeMath.sol';
+import {IERC20} from '../dependencies/openzeppelin/contracts/IERC20.sol';
+import {IERC20Detailed} from '../dependencies/openzeppelin/contracts/IERC20Detailed.sol';
+import {SafeERC20} from '../dependencies/openzeppelin/contracts/SafeERC20.sol';
+import {Ownable} from '../dependencies/openzeppelin/contracts/Ownable.sol';
+import {ILendingPoolAddressesProvider} from '../interfaces/ILendingPoolAddressesProvider.sol';
+import {DataTypes} from '../protocol/libraries/types/DataTypes.sol';
+import {IPriceOracleGetter} from '../interfaces/IPriceOracleGetter.sol';
+import {IERC20WithPermit} from '../interfaces/IERC20WithPermit.sol';
+import {FlashLoanReceiverBase} from '../flashloan/base/FlashLoanReceiverBase.sol';
+
+/**
+ * @title BaseParaSwapAdapter
+ * @notice Utility functions for adapters using ParaSwap
+ * @author Jason Raymond Bell
+ */
+abstract contract BaseParaSwapAdapter is FlashLoanReceiverBase, Ownable {
+  using SafeMath for uint256;
+  using SafeERC20 for IERC20;
+  using SafeERC20 for IERC20Detailed;
+  using SafeERC20 for IERC20WithPermit;
+
+  struct PermitSignature {
+    uint256 amount;
+    uint256 deadline;
+    uint8 v;
+    bytes32 r;
+    bytes32 s;
+  }
+
+  // Max slippage percent allowed
+  uint256 public constant MAX_SLIPPAGE_PERCENT = 3000; // 30%
+
+  IPriceOracleGetter public immutable ORACLE;
+
+  event Swapped(address indexed fromAsset, address indexed toAsset, uint256 fromAmount, uint256 receivedAmount);
+
+  constructor(
+    ILendingPoolAddressesProvider addressesProvider
+  ) public FlashLoanReceiverBase(addressesProvider) {
+    ORACLE = IPriceOracleGetter(addressesProvider.getPriceOracle());
+  }
+
+  /**
+   * @dev Get the price of the asset from the oracle denominated in eth
+   * @param asset address
+   * @return eth price for the asset
+   */
+  function _getPrice(address asset) internal view returns (uint256) {
+    return ORACLE.getAssetPrice(asset);
+  }
+
+  /**
+   * @dev Get the decimals of an asset
+   * @return number of decimals of the asset
+   */
+  function _getDecimals(IERC20Detailed asset) internal view returns (uint8) {
+    uint8 decimals = asset.decimals();
+    // Ensure 10**decimals won't overflow a uint256
+    require(decimals <= 77, 'TOO_MANY_DECIMALS_ON_TOKEN');
+    return decimals;
+  }
+
+  /**
+   * @dev Get the aToken associated to the asset
+   * @return address of the aToken
+   */
+  function _getReserveData(address asset) internal view returns (DataTypes.ReserveData memory) {
+    return LENDING_POOL.getReserveData(asset);
+  }
+
+  /**
+   * @dev Pull the ATokens from the user
+   * @param reserve address of the asset
+   * @param reserveAToken address of the aToken of the reserve
+   * @param user address
+   * @param amount of tokens to be transferred to the contract
+   * @param permitSignature struct containing the permit signature
+   */
+  function _pullATokenAndWithdraw(
+    address reserve,
+    IERC20WithPermit reserveAToken,
+    address user,
+    uint256 amount,
+    PermitSignature memory permitSignature
+  ) internal {
+    // If deadline is set to zero, assume there is no signature for permit
+    if (permitSignature.deadline != 0) {
+      reserveAToken.permit(
+        user,
+        address(this),
+        permitSignature.amount,
+        permitSignature.deadline,
+        permitSignature.v,
+        permitSignature.r,
+        permitSignature.s
+      );
+    }
+
+    // transfer from user to adapter
+    reserveAToken.safeTransferFrom(user, address(this), amount);
+
+    // withdraw reserve
+    require(
+      LENDING_POOL.withdraw(reserve, amount, address(this)) == amount,
+      'UNEXPECTED_AMOUNT_WITHDRAWN'
+    );
+  }
+
+  /**
+   * @dev Emergency rescue for token stucked on this contract, as failsafe mechanism
+   * - Funds should never remain in this contract more time than during transactions
+   * - Only callable by the owner
+   */
+  function rescueTokens(IERC20 token) external onlyOwner {
+    token.safeTransfer(owner(), token.balanceOf(address(this)));
+  }
+}
diff --git a/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/adapters/BaseParaSwapSellAdapter.sol b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/adapters/BaseParaSwapSellAdapter.sol
new file mode 100644
index 0000000..93d3cc5
--- /dev/null
+++ b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/adapters/BaseParaSwapSellAdapter.sol
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: agpl-3.0
+pragma solidity 0.6.12;
+pragma experimental ABIEncoderV2;
+
+import {BaseParaSwapAdapter} from './BaseParaSwapAdapter.sol';
+import {PercentageMath} from '../protocol/libraries/math/PercentageMath.sol';
+import {IParaSwapAugustus} from '../interfaces/IParaSwapAugustus.sol';
+import {IParaSwapAugustusRegistry} from '../interfaces/IParaSwapAugustusRegistry.sol';
+import {ILendingPoolAddressesProvider} from '../interfaces/ILendingPoolAddressesProvider.sol';
+import {IERC20Detailed} from '../dependencies/openzeppelin/contracts/IERC20Detailed.sol';
+
+/**
+ * @title BaseParaSwapSellAdapter
+ * @notice Implements the logic for selling tokens on ParaSwap
+ * @author Jason Raymond Bell
+ */
+abstract contract BaseParaSwapSellAdapter is BaseParaSwapAdapter {
+  using PercentageMath for uint256;
+
+  IParaSwapAugustusRegistry public immutable AUGUSTUS_REGISTRY;
+
+  constructor(
+    ILendingPoolAddressesProvider addressesProvider,
+    IParaSwapAugustusRegistry augustusRegistry
+  ) public BaseParaSwapAdapter(addressesProvider) {
+    // Do something on Augustus registry to check the right contract was passed
+    require(!augustusRegistry.isValidAugustus(address(0)));
+    AUGUSTUS_REGISTRY = augustusRegistry;
+  }
+
+  /**
+   * @dev Swaps a token for another using ParaSwap
+   * @param fromAmountOffset Offset of fromAmount in Augustus calldata if it should be overwritten, otherwise 0
+   * @param swapCalldata Calldata for ParaSwap's AugustusSwapper contract
+   * @param augustus Address of ParaSwap's AugustusSwapper contract
+   * @param assetToSwapFrom Address of the asset to be swapped from
+   * @param assetToSwapTo Address of the asset to be swapped to
+   * @param amountToSwap Amount to be swapped
+   * @param minAmountToReceive Minimum amount to be received from the swap
+   * @return amountReceived The amount received from the swap
+   */
+  function _sellOnParaSwap(
+    uint256 fromAmountOffset,
+    bytes memory swapCalldata,
+    IParaSwapAugustus augustus,
+    IERC20Detailed assetToSwapFrom,
+    IERC20Detailed assetToSwapTo,
+    uint256 amountToSwap,
+    uint256 minAmountToReceive
+  ) internal returns (uint256 amountReceived) {
+    require(AUGUSTUS_REGISTRY.isValidAugustus(address(augustus)), 'INVALID_AUGUSTUS');
+
+    {
+      uint256 fromAssetDecimals = _getDecimals(assetToSwapFrom);
+      uint256 toAssetDecimals = _getDecimals(assetToSwapTo);
+
+      uint256 fromAssetPrice = _getPrice(address(assetToSwapFrom));
+      uint256 toAssetPrice = _getPrice(address(assetToSwapTo));
+
+      uint256 expectedMinAmountOut =
+        amountToSwap
+          .mul(fromAssetPrice.mul(10**toAssetDecimals))
+          .div(toAssetPrice.mul(10**fromAssetDecimals))
+          .percentMul(PercentageMath.PERCENTAGE_FACTOR - MAX_SLIPPAGE_PERCENT);
+
+      require(expectedMinAmountOut <= minAmountToReceive, 'MIN_AMOUNT_EXCEEDS_MAX_SLIPPAGE');
+    }
+
+    uint256 balanceBeforeAssetFrom = assetToSwapFrom.balanceOf(address(this));
+    require(balanceBeforeAssetFrom >= amountToSwap, 'INSUFFICIENT_BALANCE_BEFORE_SWAP');
+    uint256 balanceBeforeAssetTo = assetToSwapTo.balanceOf(address(this));
+
+    address tokenTransferProxy = augustus.getTokenTransferProxy();
+    assetToSwapFrom.safeApprove(tokenTransferProxy, 0);
+    assetToSwapFrom.safeApprove(tokenTransferProxy, amountToSwap);
+
+    if (fromAmountOffset != 0) {
+      // Ensure 256 bit (32 bytes) fromAmount value is within bounds of the
+      // calldata, not overlapping with the first 4 bytes (function selector).
+      require(fromAmountOffset >= 4 &&
+        fromAmountOffset <= swapCalldata.length.sub(32),
+        'FROM_AMOUNT_OFFSET_OUT_OF_RANGE');
+      // Overwrite the fromAmount with the correct amount for the swap.
+      // In memory, swapCalldata consists of a 256 bit length field, followed by
+      // the actual bytes data, that is why 32 is added to the byte offset.
+      assembly {
+        mstore(add(swapCalldata, add(fromAmountOffset, 32)), amountToSwap)
+      }
+    }
+    (bool success,) = address(augustus).call(swapCalldata);
+    if (!success) {
+      // Copy revert reason from call
+      assembly {
+        returndatacopy(0, 0, returndatasize())
+        revert(0, returndatasize())
+      }
+    }
+    require(assetToSwapFrom.balanceOf(address(this)) == balanceBeforeAssetFrom - amountToSwap, 'WRONG_BALANCE_AFTER_SWAP');
+    amountReceived = assetToSwapTo.balanceOf(address(this)).sub(balanceBeforeAssetTo);
+    require(amountReceived >= minAmountToReceive, 'INSUFFICIENT_AMOUNT_RECEIVED');
+
+    emit Swapped(
+      address(assetToSwapFrom),
+      address(assetToSwapTo),
+      amountToSwap,
+      amountReceived
+    );
+  }
+}
diff --git a/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/adapters/ParaSwapLiquiditySwapAdapter.sol b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/adapters/ParaSwapLiquiditySwapAdapter.sol
new file mode 100644
index 0000000..7cc1105
--- /dev/null
+++ b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/adapters/ParaSwapLiquiditySwapAdapter.sol
@@ -0,0 +1,210 @@
+// SPDX-License-Identifier: agpl-3.0
+pragma solidity 0.6.12;
+pragma experimental ABIEncoderV2;
+
+import {BaseParaSwapSellAdapter} from './BaseParaSwapSellAdapter.sol';
+import {ILendingPoolAddressesProvider} from '../interfaces/ILendingPoolAddressesProvider.sol';
+import {IParaSwapAugustusRegistry} from '../interfaces/IParaSwapAugustusRegistry.sol';
+import {IERC20Detailed} from '../dependencies/openzeppelin/contracts/IERC20Detailed.sol';
+import {IERC20WithPermit} from '../interfaces/IERC20WithPermit.sol';
+import {IParaSwapAugustus} from '../interfaces/IParaSwapAugustus.sol';
+import {ReentrancyGuard} from '../dependencies/openzeppelin/contracts/ReentrancyGuard.sol';
+
+/**
+ * @title ParaSwapLiquiditySwapAdapter
+ * @notice Adapter to swap liquidity using ParaSwap.
+ * @author Jason Raymond Bell
+ */
+contract ParaSwapLiquiditySwapAdapter is BaseParaSwapSellAdapter, ReentrancyGuard {
+  constructor(
+    ILendingPoolAddressesProvider addressesProvider,
+    IParaSwapAugustusRegistry augustusRegistry
+  ) public BaseParaSwapSellAdapter(addressesProvider, augustusRegistry) {
+    // This is only required to initialize BaseParaSwapSellAdapter
+  }
+
+  /**
+   * @dev Swaps the received reserve amount from the flash loan into the asset specified in the params.
+   * The received funds from the swap are then deposited into the protocol on behalf of the user.
+   * The user should give this contract allowance to pull the ATokens in order to withdraw the underlying asset and repay the flash loan.
+   * @param assets Address of the underlying asset to be swapped from
+   * @param amounts Amount of the flash loan i.e. maximum amount to swap
+   * @param premiums Fee of the flash loan
+   * @param initiator Account that initiated the flash loan
+   * @param params Additional variadic field to include extra params. Expected parameters:
+   *   address assetToSwapTo Address of the underlying asset to be swapped to and deposited
+   *   uint256 minAmountToReceive Min amount to be received from the swap
+   *   uint256 swapAllBalanceOffset Set to offset of fromAmount in Augustus calldata if wanting to swap all balance, otherwise 0
+   *   bytes swapCalldata Calldata for ParaSwap's AugustusSwapper contract
+   *   address augustus Address of ParaSwap's AugustusSwapper contract
+   *   PermitSignature permitParams Struct containing the permit signatures, set to all zeroes if not used
+   */
+  function executeOperation(
+    address[] calldata assets,
+    uint256[] calldata amounts,
+    uint256[] calldata premiums,
+    address initiator,
+    bytes calldata params
+  ) external override nonReentrant returns (bool) {
+    require(msg.sender == address(LENDING_POOL), 'CALLER_MUST_BE_LENDING_POOL');
+    require(
+      assets.length == 1 && amounts.length == 1 && premiums.length == 1,
+      'FLASHLOAN_MULTIPLE_ASSETS_NOT_SUPPORTED'
+    );
+
+    uint256 flashLoanAmount = amounts[0];
+    uint256 premium = premiums[0];
+    address initiatorLocal = initiator;
+    IERC20Detailed assetToSwapFrom = IERC20Detailed(assets[0]);
+    (
+      IERC20Detailed assetToSwapTo,
+      uint256 minAmountToReceive,
+      uint256 swapAllBalanceOffset,
+      bytes memory swapCalldata,
+      IParaSwapAugustus augustus,
+      PermitSignature memory permitParams
+    ) = abi.decode(params, (
+      IERC20Detailed,
+      uint256,
+      uint256,
+      bytes,
+      IParaSwapAugustus,
+      PermitSignature
+    ));
+
+    _swapLiquidity(
+      swapAllBalanceOffset,
+      swapCalldata,
+      augustus,
+      permitParams,
+      flashLoanAmount,
+      premium,
+      initiatorLocal,
+      assetToSwapFrom,
+      assetToSwapTo,
+      minAmountToReceive
+    );
+
+    return true;
+  }
+
+  /**
+   * @dev Swaps an amount of an asset to another and deposits the new asset amount on behalf of the user without using a flash loan.
+   * This method can be used when the temporary transfer of the collateral asset to this contract does not affect the user position.
+   * The user should give this contract allowance to pull the ATokens in order to withdraw the underlying asset and perform the swap.
+   * @param assetToSwapFrom Address of the underlying asset to be swapped from
+   * @param assetToSwapTo Address of the underlying asset to be swapped to and deposited
+   * @param amountToSwap Amount to be swapped, or maximum amount when swapping all balance
+   * @param minAmountToReceive Minimum amount to be received from the swap
+   * @param swapAllBalanceOffset Set to offset of fromAmount in Augustus calldata if wanting to swap all balance, otherwise 0
+   * @param swapCalldata Calldata for ParaSwap's AugustusSwapper contract
+   * @param augustus Address of ParaSwap's AugustusSwapper contract
+   * @param permitParams Struct containing the permit signatures, set to all zeroes if not used
+   */
+  function swapAndDeposit(
+    IERC20Detailed assetToSwapFrom,
+    IERC20Detailed assetToSwapTo,
+    uint256 amountToSwap,
+    uint256 minAmountToReceive,
+    uint256 swapAllBalanceOffset,
+    bytes calldata swapCalldata,
+    IParaSwapAugustus augustus,
+    PermitSignature calldata permitParams
+  ) external nonReentrant {
+    IERC20WithPermit aToken =
+      IERC20WithPermit(_getReserveData(address(assetToSwapFrom)).aTokenAddress);
+
+    if (swapAllBalanceOffset != 0) {
+      uint256 balance = aToken.balanceOf(msg.sender);
+      require(balance <= amountToSwap, 'INSUFFICIENT_AMOUNT_TO_SWAP');
+      amountToSwap = balance;
+    }
+
+    _pullATokenAndWithdraw(
+      address(assetToSwapFrom),
+      aToken,
+      msg.sender,
+      amountToSwap,
+      permitParams
+    );
+
+    uint256 amountReceived = _sellOnParaSwap(
+      swapAllBalanceOffset,
+      swapCalldata,
+      augustus,
+      assetToSwapFrom,
+      assetToSwapTo,
+      amountToSwap,
+      minAmountToReceive
+    );
+
+    assetToSwapTo.safeApprove(address(LENDING_POOL), 0);
+    assetToSwapTo.safeApprove(address(LENDING_POOL), amountReceived);
+    LENDING_POOL.deposit(address(assetToSwapTo), amountReceived, msg.sender, 0);
+  }
+
+  /**
+   * @dev Swaps an amount of an asset to another and deposits the funds on behalf of the initiator.
+   * @param swapAllBalanceOffset Set to offset of fromAmount in Augustus calldata if wanting to swap all balance, otherwise 0
+   * @param swapCalldata Calldata for ParaSwap's AugustusSwapper contract
+   * @param augustus Address of ParaSwap's AugustusSwapper contract
+   * @param permitParams Struct containing the permit signatures, set to all zeroes if not used
+   * @param flashLoanAmount Amount of the flash loan i.e. maximum amount to swap
+   * @param premium Fee of the flash loan
+   * @param initiator Account that initiated the flash loan
+   * @param assetToSwapFrom Address of the underyling asset to be swapped from
+   * @param assetToSwapTo Address of the underlying asset to be swapped to and deposited
+   * @param minAmountToReceive Min amount to be received from the swap
+   */
+  function _swapLiquidity (
+    uint256 swapAllBalanceOffset,
+    bytes memory swapCalldata,
+    IParaSwapAugustus augustus,
+    PermitSignature memory permitParams,
+    uint256 flashLoanAmount,
+    uint256 premium,
+    address initiator,
+    IERC20Detailed assetToSwapFrom,
+    IERC20Detailed assetToSwapTo,
+    uint256 minAmountToReceive
+  ) internal {
+    IERC20WithPermit aToken =
+      IERC20WithPermit(_getReserveData(address(assetToSwapFrom)).aTokenAddress);
+    uint256 amountToSwap = flashLoanAmount;
+
+    uint256 balance = aToken.balanceOf(initiator);
+    if (swapAllBalanceOffset != 0) {
+      uint256 balanceToSwap = balance.sub(premium);
+      require(balanceToSwap <= amountToSwap, 'INSUFFICIENT_AMOUNT_TO_SWAP');
+      amountToSwap = balanceToSwap;
+    } else {
+      require(balance >= amountToSwap.add(premium), 'INSUFFICIENT_ATOKEN_BALANCE');
+    }
+
+    uint256 amountReceived = _sellOnParaSwap(
+      swapAllBalanceOffset,
+      swapCalldata,
+      augustus,
+      assetToSwapFrom,
+      assetToSwapTo,
+      amountToSwap,
+      minAmountToReceive
+    );
+
+    assetToSwapTo.safeApprove(address(LENDING_POOL), 0);
+    assetToSwapTo.safeApprove(address(LENDING_POOL), amountReceived);
+    LENDING_POOL.deposit(address(assetToSwapTo), amountReceived, initiator, 0);
+
+    _pullATokenAndWithdraw(
+      address(assetToSwapFrom),
+      aToken,
+      initiator,
+      amountToSwap.add(premium),
+      permitParams
+    );
+
+    // Repay flash loan
+    assetToSwapFrom.safeApprove(address(LENDING_POOL), 0);
+    assetToSwapFrom.safeApprove(address(LENDING_POOL), flashLoanAmount.add(premium));
+  }
+}
diff --git a/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/dependencies/openzeppelin/contracts/ReentrancyGuard.sol b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/dependencies/openzeppelin/contracts/ReentrancyGuard.sol
new file mode 100644
index 0000000..24c90c3
--- /dev/null
+++ b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/dependencies/openzeppelin/contracts/ReentrancyGuard.sol
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: MIT
+
+pragma solidity >=0.6.0 <0.8.0;
+
+/**
+ * @dev Contract module that helps prevent reentrant calls to a function.
+ *
+ * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
+ * available, which can be applied to functions to make sure there are no nested
+ * (reentrant) calls to them.
+ *
+ * Note that because there is a single `nonReentrant` guard, functions marked as
+ * `nonReentrant` may not call one another. This can be worked around by making
+ * those functions `private`, and then adding `external` `nonReentrant` entry
+ * points to them.
+ *
+ * TIP: If you would like to learn more about reentrancy and alternative ways
+ * to protect against it, check out our blog post
+ * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
+ */
+abstract contract ReentrancyGuard {
+    // Booleans are more expensive than uint256 or any type that takes up a full
+    // word because each write operation emits an extra SLOAD to first read the
+    // slot's contents, replace the bits taken up by the boolean, and then write
+    // back. This is the compiler's defense against contract upgrades and
+    // pointer aliasing, and it cannot be disabled.
+
+    // The values being non-zero value makes deployment a bit more expensive,
+    // but in exchange the refund on every call to nonReentrant will be lower in
+    // amount. Since refunds are capped to a percentage of the total
+    // transaction's gas, it is best to keep them low in cases like this one, to
+    // increase the likelihood of the full refund coming into effect.
+    uint256 private constant _NOT_ENTERED = 1;
+    uint256 private constant _ENTERED = 2;
+
+    uint256 private _status;
+
+    constructor () internal {
+        _status = _NOT_ENTERED;
+    }
+
+    /**
+     * @dev Prevents a contract from calling itself, directly or indirectly.
+     * Calling a `nonReentrant` function from another `nonReentrant`
+     * function is not supported. It is possible to prevent this from happening
+     * by making the `nonReentrant` function external, and make it call a
+     * `private` function that does the actual work.
+     */
+    modifier nonReentrant() {
+        // On the first call to nonReentrant, _notEntered will be true
+        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
+
+        // Any calls to nonReentrant after this point will fail
+        _status = _ENTERED;
+
+        _;
+
+        // By storing the original value once again, a refund is triggered (see
+        // https://eips.ethereum.org/EIPS/eip-2200)
+        _status = _NOT_ENTERED;
+    }
+}
diff --git a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/deployments/ATokensAndRatesHelper.sol b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/deployments/ATokensAndRatesHelper.sol
index 400f7ca..2cac535 100644
--- a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/deployments/ATokensAndRatesHelper.sol
+++ b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/deployments/ATokensAndRatesHelper.sol
@@ -32,6 +32,7 @@ contract ATokensAndRatesHelper is Ownable {
     uint256 liquidationBonus;
     uint256 reserveFactor;
     bool stableBorrowingEnabled;
+    bool borrowingEnabled;
   }
 
   constructor(
@@ -73,10 +74,12 @@ contract ATokensAndRatesHelper is Ownable {
         inputParams[i].liquidationBonus
       );
 
-      configurator.enableBorrowingOnReserve(
-        inputParams[i].asset,
-        inputParams[i].stableBorrowingEnabled
-      );
+      if (inputParams[i].borrowingEnabled) {
+        configurator.enableBorrowingOnReserve(
+          inputParams[i].asset,
+          inputParams[i].stableBorrowingEnabled
+        );
+      }
       configurator.setReserveFactor(inputParams[i].asset, inputParams[i].reserveFactor);
     }
   }
diff --git a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/interfaces/IAToken.sol b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/interfaces/IAToken.sol
index 3a6ac66..cf0ea26 100644
--- a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/interfaces/IAToken.sol
+++ b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/interfaces/IAToken.sol
@@ -99,4 +99,9 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * @dev Returns the address of the incentives controller contract
    **/
   function getIncentivesController() external view returns (IAaveIncentivesController);
+
+  /**
+   * @dev Returns the address of the underlying asset of this aToken (E.g. WETH for aWETH)
+   **/
+  function UNDERLYING_ASSET_ADDRESS() external view returns (address);
 }
diff --git a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/interfaces/IAaveIncentivesController.sol b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/interfaces/IAaveIncentivesController.sol
index c049bd7..0006e31 100644
--- a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/interfaces/IAaveIncentivesController.sol
+++ b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/interfaces/IAaveIncentivesController.sol
@@ -3,9 +3,146 @@ pragma solidity 0.6.12;
 pragma experimental ABIEncoderV2;
 
 interface IAaveIncentivesController {
+  event RewardsAccrued(address indexed user, uint256 amount);
+
+  event RewardsClaimed(address indexed user, address indexed to, uint256 amount);
+
+  event RewardsClaimed(
+    address indexed user,
+    address indexed to,
+    address indexed claimer,
+    uint256 amount
+  );
+
+  event ClaimerSet(address indexed user, address indexed claimer);
+
+  /*
+   * @dev Returns the configuration of the distribution for a certain asset
+   * @param asset The address of the reference asset of the distribution
+   * @return The asset index, the emission per second and the last updated timestamp
+   **/
+  function getAssetData(address asset)
+    external
+    view
+    returns (
+      uint256,
+      uint256,
+      uint256
+    );
+
+  /*
+   * LEGACY **************************
+   * @dev Returns the configuration of the distribution for a certain asset
+   * @param asset The address of the reference asset of the distribution
+   * @return The asset index, the emission per second and the last updated timestamp
+   **/
+  function assets(address asset)
+    external
+    view
+    returns (
+      uint128,
+      uint128,
+      uint256
+    );
+
+  /**
+   * @dev Whitelists an address to claim the rewards on behalf of another address
+   * @param user The address of the user
+   * @param claimer The address of the claimer
+   */
+  function setClaimer(address user, address claimer) external;
+
+  /**
+   * @dev Returns the whitelisted claimer for a certain address (0x0 if not set)
+   * @param user The address of the user
+   * @return The claimer address
+   */
+  function getClaimer(address user) external view returns (address);
+
+  /**
+   * @dev Configure assets for a certain rewards emission
+   * @param assets The assets to incentivize
+   * @param emissionsPerSecond The emission for each asset
+   */
+  function configureAssets(address[] calldata assets, uint256[] calldata emissionsPerSecond)
+    external;
+
+  /**
+   * @dev Called by the corresponding asset on any update that affects the rewards distribution
+   * @param asset The address of the user
+   * @param userBalance The balance of the user of the asset in the lending pool
+   * @param totalSupply The total supply of the asset in the lending pool
+   **/
   function handleAction(
-    address user,
+    address asset,
     uint256 userBalance,
     uint256 totalSupply
   ) external;
+
+  /**
+   * @dev Returns the total of rewards of an user, already accrued + not yet accrued
+   * @param user The address of the user
+   * @return The rewards
+   **/
+  function getRewardsBalance(address[] calldata assets, address user)
+    external
+    view
+    returns (uint256);
+
+  /**
+   * @dev Claims reward for an user, on all the assets of the lending pool, accumulating the pending rewards
+   * @param amount Amount of rewards to claim
+   * @param to Address that will be receiving the rewards
+   * @return Rewards claimed
+   **/
+  function claimRewards(
+    address[] calldata assets,
+    uint256 amount,
+    address to
+  ) external returns (uint256);
+
+  /**
+   * @dev Claims reward for an user on behalf, on all the assets of the lending pool, accumulating the pending rewards. The caller must
+   * be whitelisted via "allowClaimOnBehalf" function by the RewardsAdmin role manager
+   * @param amount Amount of rewards to claim
+   * @param user Address to check and claim rewards
+   * @param to Address that will be receiving the rewards
+   * @return Rewards claimed
+   **/
+  function claimRewardsOnBehalf(
+    address[] calldata assets,
+    uint256 amount,
+    address user,
+    address to
+  ) external returns (uint256);
+
+  /**
+   * @dev returns the unclaimed rewards of the user
+   * @param user the address of the user
+   * @return the unclaimed user rewards
+   */
+  function getUserUnclaimedRewards(address user) external view returns (uint256);
+
+  /**
+   * @dev returns the unclaimed rewards of the user
+   * @param user the address of the user
+   * @param asset The asset to incentivize
+   * @return the user index for the asset
+   */
+  function getUserAssetData(address user, address asset) external view returns (uint256);
+
+  /**
+   * @dev for backward compatibility with previous implementation of the Incentives controller
+   */
+  function REWARD_TOKEN() external view returns (address);
+
+  /**
+   * @dev for backward compatibility with previous implementation of the Incentives controller
+   */
+  function PRECISION() external view returns (uint8);
+
+  /**
+   * @dev Gets the distribution end timestamp of the emissions
+   */
+  function DISTRIBUTION_END() external view returns (uint256);
 }
diff --git a/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/interfaces/IParaSwapAugustus.sol b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/interfaces/IParaSwapAugustus.sol
new file mode 100644
index 0000000..bd0714d
--- /dev/null
+++ b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/interfaces/IParaSwapAugustus.sol
@@ -0,0 +1,7 @@
+// SPDX-License-Identifier: agpl-3.0
+pragma solidity 0.6.12;
+pragma experimental ABIEncoderV2;
+
+interface IParaSwapAugustus {
+  function getTokenTransferProxy() external view returns (address);
+}
diff --git a/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/interfaces/IParaSwapAugustusRegistry.sol b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/interfaces/IParaSwapAugustusRegistry.sol
new file mode 100644
index 0000000..f10e13d
--- /dev/null
+++ b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/interfaces/IParaSwapAugustusRegistry.sol
@@ -0,0 +1,7 @@
+// SPDX-License-Identifier: agpl-3.0
+pragma solidity 0.6.12;
+pragma experimental ABIEncoderV2;
+
+interface IParaSwapAugustusRegistry {
+  function isValidAugustus(address augustus) external view returns (bool);
+}
diff --git a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/misc/AaveOracle.sol b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/misc/AaveOracle.sol
index 0cb8e18..bc92146 100644
--- a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/misc/AaveOracle.sol
+++ b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/misc/AaveOracle.sol
@@ -18,29 +18,34 @@ import {SafeERC20} from '../dependencies/openzeppelin/contracts/SafeERC20.sol';
 contract AaveOracle is IPriceOracleGetter, Ownable {
   using SafeERC20 for IERC20;
 
-  event WethSet(address indexed weth);
+  event BaseCurrencySet(address indexed baseCurrency, uint256 baseCurrencyUnit);
   event AssetSourceUpdated(address indexed asset, address indexed source);
   event FallbackOracleUpdated(address indexed fallbackOracle);
 
   mapping(address => IChainlinkAggregator) private assetsSources;
   IPriceOracleGetter private _fallbackOracle;
-  address public immutable WETH;
+  address public immutable BASE_CURRENCY;
+  uint256 public immutable BASE_CURRENCY_UNIT;
 
   /// @notice Constructor
   /// @param assets The addresses of the assets
   /// @param sources The address of the source of each asset
   /// @param fallbackOracle The address of the fallback oracle to use if the data of an
   ///        aggregator is not consistent
+  /// @param baseCurrency the base currency used for the price quotes. If USD is used, base currency is 0x0
+  /// @param baseCurrencyUnit the unit of the base currency
   constructor(
     address[] memory assets,
     address[] memory sources,
     address fallbackOracle,
-    address weth
+    address baseCurrency,
+    uint256 baseCurrencyUnit
   ) public {
     _setFallbackOracle(fallbackOracle);
     _setAssetsSources(assets, sources);
-    WETH = weth;
-    emit WethSet(weth);
+    BASE_CURRENCY = baseCurrency;
+    BASE_CURRENCY_UNIT = baseCurrencyUnit;
+    emit BaseCurrencySet(baseCurrency, baseCurrencyUnit);
   }
 
   /// @notice External function called by the Aave governance to set or replace sources of assets
@@ -83,8 +88,8 @@ contract AaveOracle is IPriceOracleGetter, Ownable {
   function getAssetPrice(address asset) public view override returns (uint256) {
     IChainlinkAggregator source = assetsSources[asset];
 
-    if (asset == WETH) {
-      return 1 ether;
+    if (asset == BASE_CURRENCY) {
+      return BASE_CURRENCY_UNIT;
     } else if (address(source) == address(0)) {
       return _fallbackOracle.getAssetPrice(asset);
     } else {
diff --git a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/misc/UiPoolDataProvider.sol b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/misc/UiPoolDataProvider.sol
index 65fdc4d..e9f40fe 100644
--- a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/misc/UiPoolDataProvider.sol
+++ b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/misc/UiPoolDataProvider.sol
@@ -4,6 +4,7 @@ pragma experimental ABIEncoderV2;
 
 import {IERC20Detailed} from '../dependencies/openzeppelin/contracts/IERC20Detailed.sol';
 import {ILendingPoolAddressesProvider} from '../interfaces/ILendingPoolAddressesProvider.sol';
+import {IAaveIncentivesController} from '../interfaces/IAaveIncentivesController.sol';
 import {IUiPoolDataProvider} from './interfaces/IUiPoolDataProvider.sol';
 import {ILendingPool} from '../interfaces/ILendingPool.sol';
 import {IPriceOracleGetter} from '../interfaces/IPriceOracleGetter.sol';
@@ -24,6 +25,13 @@ contract UiPoolDataProvider is IUiPoolDataProvider {
   using UserConfiguration for DataTypes.UserConfigurationMap;
 
   address public constant MOCK_USD_ADDRESS = 0x10F7Fc1F91Ba351f9C629c5947AD69bD03C05b96;
+  IAaveIncentivesController public immutable override incentivesController;
+  IPriceOracleGetter public immutable oracle;
+
+  constructor(IAaveIncentivesController _incentivesController, IPriceOracleGetter _oracle) public {
+    incentivesController = _incentivesController;
+    oracle = _oracle;
+  }
 
   function getInterestRateStrategySlopes(DefaultReserveInterestRateStrategy interestRateStrategy)
     internal
@@ -43,6 +51,188 @@ contract UiPoolDataProvider is IUiPoolDataProvider {
     );
   }
 
+  function getReservesList(ILendingPoolAddressesProvider provider)
+    public
+    view
+    override
+    returns (address[] memory)
+  {
+    ILendingPool lendingPool = ILendingPool(provider.getLendingPool());
+    return lendingPool.getReservesList();
+  }
+
+  function getSimpleReservesData(ILendingPoolAddressesProvider provider)
+    public
+    view
+    override
+    returns (
+      AggregatedReserveData[] memory,
+      uint256,
+      uint256
+    )
+  {
+    ILendingPool lendingPool = ILendingPool(provider.getLendingPool());
+    address[] memory reserves = lendingPool.getReservesList();
+    AggregatedReserveData[] memory reservesData = new AggregatedReserveData[](reserves.length);
+
+    for (uint256 i = 0; i < reserves.length; i++) {
+      AggregatedReserveData memory reserveData = reservesData[i];
+      reserveData.underlyingAsset = reserves[i];
+
+      // reserve current state
+      DataTypes.ReserveData memory baseData =
+        lendingPool.getReserveData(reserveData.underlyingAsset);
+      reserveData.liquidityIndex = baseData.liquidityIndex;
+      reserveData.variableBorrowIndex = baseData.variableBorrowIndex;
+      reserveData.liquidityRate = baseData.currentLiquidityRate;
+      reserveData.variableBorrowRate = baseData.currentVariableBorrowRate;
+      reserveData.stableBorrowRate = baseData.currentStableBorrowRate;
+      reserveData.lastUpdateTimestamp = baseData.lastUpdateTimestamp;
+      reserveData.aTokenAddress = baseData.aTokenAddress;
+      reserveData.stableDebtTokenAddress = baseData.stableDebtTokenAddress;
+      reserveData.variableDebtTokenAddress = baseData.variableDebtTokenAddress;
+      reserveData.interestRateStrategyAddress = baseData.interestRateStrategyAddress;
+      reserveData.priceInEth = oracle.getAssetPrice(reserveData.underlyingAsset);
+
+      reserveData.availableLiquidity = IERC20Detailed(reserveData.underlyingAsset).balanceOf(
+        reserveData.aTokenAddress
+      );
+      (
+        reserveData.totalPrincipalStableDebt,
+        ,
+        reserveData.averageStableRate,
+        reserveData.stableDebtLastUpdateTimestamp
+      ) = IStableDebtToken(reserveData.stableDebtTokenAddress).getSupplyData();
+      reserveData.totalScaledVariableDebt = IVariableDebtToken(reserveData.variableDebtTokenAddress)
+        .scaledTotalSupply();
+
+      // reserve configuration
+
+      // we're getting this info from the aToken, because some of assets can be not compliant with ETC20Detailed
+      reserveData.symbol = IERC20Detailed(reserveData.aTokenAddress).symbol();
+      reserveData.name = '';
+
+      (
+        reserveData.baseLTVasCollateral,
+        reserveData.reserveLiquidationThreshold,
+        reserveData.reserveLiquidationBonus,
+        reserveData.decimals,
+        reserveData.reserveFactor
+      ) = baseData.configuration.getParamsMemory();
+      (
+        reserveData.isActive,
+        reserveData.isFrozen,
+        reserveData.borrowingEnabled,
+        reserveData.stableBorrowRateEnabled
+      ) = baseData.configuration.getFlagsMemory();
+      reserveData.usageAsCollateralEnabled = reserveData.baseLTVasCollateral != 0;
+      (
+        reserveData.variableRateSlope1,
+        reserveData.variableRateSlope2,
+        reserveData.stableRateSlope1,
+        reserveData.stableRateSlope2
+      ) = getInterestRateStrategySlopes(
+        DefaultReserveInterestRateStrategy(reserveData.interestRateStrategyAddress)
+      );
+
+      // incentives
+      if (address(0) != address(incentivesController)) {
+        (
+          reserveData.aEmissionPerSecond,
+          reserveData.aIncentivesLastUpdateTimestamp,
+          reserveData.aTokenIncentivesIndex
+          //        ) = incentivesController.getAssetData(reserveData.aTokenAddress);  TODO: temp fix
+        ) = incentivesController.assets(reserveData.aTokenAddress);
+
+        (
+          reserveData.sEmissionPerSecond,
+          reserveData.sIncentivesLastUpdateTimestamp,
+          reserveData.sTokenIncentivesIndex
+          //        ) = incentivesController.getAssetData(reserveData.stableDebtTokenAddress);  TODO: temp fix
+        ) = incentivesController.assets(reserveData.stableDebtTokenAddress);
+
+        (
+          reserveData.vEmissionPerSecond,
+          reserveData.vIncentivesLastUpdateTimestamp,
+          reserveData.vTokenIncentivesIndex
+          //        ) = incentivesController.getAssetData(reserveData.variableDebtTokenAddress);  TODO: temp fix
+        ) = incentivesController.assets(reserveData.variableDebtTokenAddress);
+      }
+    }
+
+    uint256 emissionEndTimestamp;
+    if (address(0) != address(incentivesController)) {
+      emissionEndTimestamp = incentivesController.DISTRIBUTION_END();
+    }
+
+    return (reservesData, oracle.getAssetPrice(MOCK_USD_ADDRESS), emissionEndTimestamp);
+  }
+
+  function getUserReservesData(ILendingPoolAddressesProvider provider, address user)
+    external
+    view
+    override
+    returns (UserReserveData[] memory, uint256)
+  {
+    ILendingPool lendingPool = ILendingPool(provider.getLendingPool());
+    address[] memory reserves = lendingPool.getReservesList();
+    DataTypes.UserConfigurationMap memory userConfig = lendingPool.getUserConfiguration(user);
+
+    UserReserveData[] memory userReservesData =
+      new UserReserveData[](user != address(0) ? reserves.length : 0);
+
+    for (uint256 i = 0; i < reserves.length; i++) {
+      DataTypes.ReserveData memory baseData = lendingPool.getReserveData(reserves[i]);
+      // incentives
+      if (address(0) != address(incentivesController)) {
+        userReservesData[i].aTokenincentivesUserIndex = incentivesController.getUserAssetData(
+          user,
+          baseData.aTokenAddress
+        );
+        userReservesData[i].vTokenincentivesUserIndex = incentivesController.getUserAssetData(
+          user,
+          baseData.variableDebtTokenAddress
+        );
+        userReservesData[i].sTokenincentivesUserIndex = incentivesController.getUserAssetData(
+          user,
+          baseData.stableDebtTokenAddress
+        );
+      }
+      // user reserve data
+      userReservesData[i].underlyingAsset = reserves[i];
+      userReservesData[i].scaledATokenBalance = IAToken(baseData.aTokenAddress).scaledBalanceOf(
+        user
+      );
+      userReservesData[i].usageAsCollateralEnabledOnUser = userConfig.isUsingAsCollateral(i);
+
+      if (userConfig.isBorrowing(i)) {
+        userReservesData[i].scaledVariableDebt = IVariableDebtToken(
+          baseData
+            .variableDebtTokenAddress
+        )
+          .scaledBalanceOf(user);
+        userReservesData[i].principalStableDebt = IStableDebtToken(baseData.stableDebtTokenAddress)
+          .principalBalanceOf(user);
+        if (userReservesData[i].principalStableDebt != 0) {
+          userReservesData[i].stableBorrowRate = IStableDebtToken(baseData.stableDebtTokenAddress)
+            .getUserStableRate(user);
+          userReservesData[i].stableBorrowLastUpdateTimestamp = IStableDebtToken(
+            baseData
+              .stableDebtTokenAddress
+          )
+            .getUserLastUpdated(user);
+        }
+      }
+    }
+
+    uint256 userUnclaimedRewards;
+    if (address(0) != address(incentivesController)) {
+      userUnclaimedRewards = incentivesController.getUserUnclaimedRewards(user);
+    }
+
+    return (userReservesData, userUnclaimedRewards);
+  }
+
   function getReservesData(ILendingPoolAddressesProvider provider, address user)
     external
     view
@@ -50,11 +240,11 @@ contract UiPoolDataProvider is IUiPoolDataProvider {
     returns (
       AggregatedReserveData[] memory,
       UserReserveData[] memory,
-      uint256
+      uint256,
+      IncentivesControllerData memory
     )
   {
     ILendingPool lendingPool = ILendingPool(provider.getLendingPool());
-    IPriceOracleGetter oracle = IPriceOracleGetter(provider.getPriceOracle());
     address[] memory reserves = lendingPool.getReservesList();
     DataTypes.UserConfigurationMap memory userConfig = lendingPool.getUserConfiguration(user);
 
@@ -122,7 +312,46 @@ contract UiPoolDataProvider is IUiPoolDataProvider {
         DefaultReserveInterestRateStrategy(reserveData.interestRateStrategyAddress)
       );
 
+      // incentives
+      if (address(0) != address(incentivesController)) {
+        (
+          reserveData.aTokenIncentivesIndex,
+          reserveData.aEmissionPerSecond,
+          reserveData.aIncentivesLastUpdateTimestamp
+          //        ) = incentivesController.getAssetData(reserveData.aTokenAddress); TODO: temp fix
+        ) = incentivesController.assets(reserveData.aTokenAddress);
+
+        (
+          reserveData.sTokenIncentivesIndex,
+          reserveData.sEmissionPerSecond,
+          reserveData.sIncentivesLastUpdateTimestamp
+          //        ) = incentivesController.getAssetData(reserveData.stableDebtTokenAddress); TODO: temp fix
+        ) = incentivesController.assets(reserveData.stableDebtTokenAddress);
+
+        (
+          reserveData.vTokenIncentivesIndex,
+          reserveData.vEmissionPerSecond,
+          reserveData.vIncentivesLastUpdateTimestamp
+          //        ) = incentivesController.getAssetData(reserveData.variableDebtTokenAddress); TODO: temp fix
+        ) = incentivesController.assets(reserveData.variableDebtTokenAddress);
+      }
+
       if (user != address(0)) {
+        // incentives
+        if (address(0) != address(incentivesController)) {
+          userReservesData[i].aTokenincentivesUserIndex = incentivesController.getUserAssetData(
+            user,
+            reserveData.aTokenAddress
+          );
+          userReservesData[i].vTokenincentivesUserIndex = incentivesController.getUserAssetData(
+            user,
+            reserveData.variableDebtTokenAddress
+          );
+          userReservesData[i].sTokenincentivesUserIndex = incentivesController.getUserAssetData(
+            user,
+            reserveData.stableDebtTokenAddress
+          );
+        }
         // user reserve data
         userReservesData[i].underlyingAsset = reserveData.underlyingAsset;
         userReservesData[i].scaledATokenBalance = IAToken(reserveData.aTokenAddress)
@@ -155,6 +384,22 @@ contract UiPoolDataProvider is IUiPoolDataProvider {
         }
       }
     }
-    return (reservesData, userReservesData, oracle.getAssetPrice(MOCK_USD_ADDRESS));
+
+    IncentivesControllerData memory incentivesControllerData;
+
+    if (address(0) != address(incentivesController)) {
+      if (user != address(0)) {
+        incentivesControllerData.userUnclaimedRewards = incentivesController
+          .getUserUnclaimedRewards(user);
+      }
+      incentivesControllerData.emissionEndTimestamp = incentivesController.DISTRIBUTION_END();
+    }
+
+    return (
+      reservesData,
+      userReservesData,
+      oracle.getAssetPrice(MOCK_USD_ADDRESS),
+      incentivesControllerData
+    );
   }
 }
diff --git a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/misc/interfaces/IUiPoolDataProvider.sol b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/misc/interfaces/IUiPoolDataProvider.sol
index 81a553e..db7f309 100644
--- a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/misc/interfaces/IUiPoolDataProvider.sol
+++ b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/misc/interfaces/IUiPoolDataProvider.sol
@@ -3,6 +3,7 @@ pragma solidity 0.6.12;
 pragma experimental ABIEncoderV2;
 
 import {ILendingPoolAddressesProvider} from '../../interfaces/ILendingPoolAddressesProvider.sol';
+import {IAaveIncentivesController} from '../../interfaces/IAaveIncentivesController.sol';
 
 interface IUiPoolDataProvider {
   struct AggregatedReserveData {
@@ -41,12 +42,17 @@ interface IUiPoolDataProvider {
     uint256 variableRateSlope2;
     uint256 stableRateSlope1;
     uint256 stableRateSlope2;
+    // incentives
+    uint256 aEmissionPerSecond;
+    uint256 vEmissionPerSecond;
+    uint256 sEmissionPerSecond;
+    uint256 aIncentivesLastUpdateTimestamp;
+    uint256 vIncentivesLastUpdateTimestamp;
+    uint256 sIncentivesLastUpdateTimestamp;
+    uint256 aTokenIncentivesIndex;
+    uint256 vTokenIncentivesIndex;
+    uint256 sTokenIncentivesIndex;
   }
-  //
-  //  struct ReserveData {
-  //    uint256 averageStableBorrowRate;
-  //    uint256 totalLiquidity;
-  //  }
 
   struct UserReserveData {
     address underlyingAsset;
@@ -56,38 +62,49 @@ interface IUiPoolDataProvider {
     uint256 scaledVariableDebt;
     uint256 principalStableDebt;
     uint256 stableBorrowLastUpdateTimestamp;
+    // incentives
+    uint256 aTokenincentivesUserIndex;
+    uint256 vTokenincentivesUserIndex;
+    uint256 sTokenincentivesUserIndex;
   }
 
-  //
-  //  struct ATokenSupplyData {
-  //    string name;
-  //    string symbol;
-  //    uint8 decimals;
-  //    uint256 totalSupply;
-  //    address aTokenAddress;
-  //  }
+  struct IncentivesControllerData {
+    uint256 userUnclaimedRewards;
+    uint256 emissionEndTimestamp;
+  }
+
+  function getReservesList(ILendingPoolAddressesProvider provider)
+    external
+    view
+    returns (address[] memory);
+
+  function incentivesController() external view returns (IAaveIncentivesController);
+
+  function getSimpleReservesData(ILendingPoolAddressesProvider provider)
+    external
+    view
+    returns (
+      AggregatedReserveData[] memory,
+      uint256, // usd price eth
+      uint256 // emission end timestamp
+    );
+
+  function getUserReservesData(ILendingPoolAddressesProvider provider, address user)
+    external
+    view
+    returns (
+      UserReserveData[] memory,
+      uint256 // user unclaimed rewards
+    );
 
+  // generic method with full data
   function getReservesData(ILendingPoolAddressesProvider provider, address user)
     external
     view
     returns (
       AggregatedReserveData[] memory,
       UserReserveData[] memory,
-      uint256
+      uint256,
+      IncentivesControllerData memory
     );
-
-  //  function getUserReservesData(ILendingPoolAddressesProvider provider, address user)
-  //    external
-  //    view
-  //    returns (UserReserveData[] memory);
-  //
-  //  function getAllATokenSupply(ILendingPoolAddressesProvider provider)
-  //    external
-  //    view
-  //    returns (ATokenSupplyData[] memory);
-  //
-  //  function getATokenSupply(address[] calldata aTokens)
-  //    external
-  //    view
-  //    returns (ATokenSupplyData[] memory);
 }
diff --git a/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/mocks/swap/MockParaSwapAugustus.sol b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/mocks/swap/MockParaSwapAugustus.sol
new file mode 100644
index 0000000..1cf3217
--- /dev/null
+++ b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/mocks/swap/MockParaSwapAugustus.sol
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: agpl-3.0
+pragma solidity 0.6.12;
+pragma experimental ABIEncoderV2;
+
+import {IParaSwapAugustus} from '../../interfaces/IParaSwapAugustus.sol';
+import {MockParaSwapTokenTransferProxy} from './MockParaSwapTokenTransferProxy.sol';
+import {IERC20} from '../../dependencies/openzeppelin/contracts/IERC20.sol';
+import {MintableERC20} from '../tokens/MintableERC20.sol';
+
+contract MockParaSwapAugustus is IParaSwapAugustus {
+  MockParaSwapTokenTransferProxy immutable TOKEN_TRANSFER_PROXY;
+  bool _expectingSwap;
+  address _expectedFromToken;
+  address _expectedToToken;
+  uint256 _expectedFromAmountMin;
+  uint256 _expectedFromAmountMax;
+  uint256 _receivedAmount;
+
+  constructor() public {
+    TOKEN_TRANSFER_PROXY = new MockParaSwapTokenTransferProxy();
+  }
+
+  function getTokenTransferProxy() external view override returns (address) {
+    return address(TOKEN_TRANSFER_PROXY);
+  }
+
+  function expectSwap(
+    address fromToken,
+    address toToken,
+    uint256 fromAmountMin,
+    uint256 fromAmountMax,
+    uint256 receivedAmount
+  ) external {
+    _expectingSwap = true;
+    _expectedFromToken = fromToken;
+    _expectedToToken = toToken;
+    _expectedFromAmountMin = fromAmountMin;
+    _expectedFromAmountMax = fromAmountMax;
+    _receivedAmount = receivedAmount;
+  }
+
+  function swap(
+    address fromToken,
+    address toToken,
+    uint256 fromAmount,
+    uint256 toAmount
+  ) external returns (uint256) {
+    require(_expectingSwap, 'Not expecting swap');
+    require(fromToken == _expectedFromToken, 'Unexpected from token');
+    require(toToken == _expectedToToken, 'Unexpected to token');
+    require(fromAmount >= _expectedFromAmountMin && fromAmount <= _expectedFromAmountMax, 'From amount out of range');
+    require(_receivedAmount >= toAmount, 'Received amount of tokens are less than expected');
+    TOKEN_TRANSFER_PROXY.transferFrom(fromToken, msg.sender, address(this), fromAmount);
+    MintableERC20(toToken).mint(_receivedAmount);
+    IERC20(toToken).transfer(msg.sender, _receivedAmount);
+    _expectingSwap = false;
+    return _receivedAmount;
+  }
+}
diff --git a/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/mocks/swap/MockParaSwapAugustusRegistry.sol b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/mocks/swap/MockParaSwapAugustusRegistry.sol
new file mode 100644
index 0000000..c8998ec
--- /dev/null
+++ b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/mocks/swap/MockParaSwapAugustusRegistry.sol
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: agpl-3.0
+pragma solidity 0.6.12;
+pragma experimental ABIEncoderV2;
+
+import {IParaSwapAugustusRegistry} from '../../interfaces/IParaSwapAugustusRegistry.sol';
+
+contract MockParaSwapAugustusRegistry is IParaSwapAugustusRegistry {
+  address immutable AUGUSTUS;
+
+  constructor(address augustus) public {
+    AUGUSTUS = augustus;
+  }
+
+  function isValidAugustus(address augustus) external view override returns (bool) {
+    return augustus == AUGUSTUS;
+  }
+}
diff --git a/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/mocks/swap/MockParaSwapTokenTransferProxy.sol b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/mocks/swap/MockParaSwapTokenTransferProxy.sol
new file mode 100644
index 0000000..a405cec
--- /dev/null
+++ b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/mocks/swap/MockParaSwapTokenTransferProxy.sol
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: agpl-3.0
+pragma solidity 0.6.12;
+pragma experimental ABIEncoderV2;
+
+import {Ownable} from '../../dependencies/openzeppelin/contracts/Ownable.sol';
+import {IERC20} from '../../dependencies/openzeppelin/contracts/IERC20.sol';
+
+contract MockParaSwapTokenTransferProxy is Ownable {
+  function transferFrom(
+    address token,
+    address from,
+    address to,
+    uint256 amount
+  ) external onlyOwner {
+    IERC20(token).transferFrom(from, to, amount);
+  }
+}
diff --git a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/DefaultReserveInterestRateStrategy.sol b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/DefaultReserveInterestRateStrategy.sol
index af4db24..7b321d0 100644
--- a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/DefaultReserveInterestRateStrategy.sol
+++ b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/DefaultReserveInterestRateStrategy.sol
@@ -8,7 +8,6 @@ import {PercentageMath} from '../libraries/math/PercentageMath.sol';
 import {ILendingPoolAddressesProvider} from '../../interfaces/ILendingPoolAddressesProvider.sol';
 import {ILendingRateOracle} from '../../interfaces/ILendingRateOracle.sol';
 import {IERC20} from '../../dependencies/openzeppelin/contracts/IERC20.sol';
-import 'hardhat/console.sol';
 
 /**
  * @title DefaultReserveInterestRateStrategy contract
diff --git a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/protocol/tokenization/AToken.sol b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/protocol/tokenization/AToken.sol
index f278473..46aae19 100644
--- a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/protocol/tokenization/AToken.sol
+++ b/etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/protocol/tokenization/AToken.sol
@@ -273,7 +273,7 @@ contract AToken is
   /**
    * @dev Returns the address of the underlying asset of this aToken (E.g. WETH for aWETH)
    **/
-  function UNDERLYING_ASSET_ADDRESS() public view returns (address) {
+  function UNDERLYING_ASSET_ADDRESS() public override view returns (address) {
     return _underlyingAsset;
   }
 
diff --git a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/hardhat/console.sol b/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/hardhat/console.sol
deleted file mode 100644
index d65e3b4..0000000
--- a/etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/hardhat/console.sol
+++ /dev/null
@@ -1,1532 +0,0 @@
-// SPDX-License-Identifier: MIT
-pragma solidity >= 0.4.22 <0.9.0;
-
-library console {
-	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
-
-	function _sendLogPayload(bytes memory payload) private view {
-		uint256 payloadLength = payload.length;
-		address consoleAddress = CONSOLE_ADDRESS;
-		assembly {
-			let payloadStart := add(payload, 32)
-			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
-		}
-	}
-
-	function log() internal view {
-		_sendLogPayload(abi.encodeWithSignature("log()"));
-	}
-
-	function logInt(int p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
-	}
-
-	function logUint(uint p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
-	}
-
-	function logString(string memory p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
-	}
-
-	function logBool(bool p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
-	}
-
-	function logAddress(address p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
-	}
-
-	function logBytes(bytes memory p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
-	}
-
-	function logBytes1(bytes1 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
-	}
-
-	function logBytes2(bytes2 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
-	}
-
-	function logBytes3(bytes3 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
-	}
-
-	function logBytes4(bytes4 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
-	}
-
-	function logBytes5(bytes5 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
-	}
-
-	function logBytes6(bytes6 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
-	}
-
-	function logBytes7(bytes7 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
-	}
-
-	function logBytes8(bytes8 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
-	}
-
-	function logBytes9(bytes9 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
-	}
-
-	function logBytes10(bytes10 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
-	}
-
-	function logBytes11(bytes11 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
-	}
-
-	function logBytes12(bytes12 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
-	}
-
-	function logBytes13(bytes13 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
-	}
-
-	function logBytes14(bytes14 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
-	}
-
-	function logBytes15(bytes15 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
-	}
-
-	function logBytes16(bytes16 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
-	}
-
-	function logBytes17(bytes17 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
-	}
-
-	function logBytes18(bytes18 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
-	}
-
-	function logBytes19(bytes19 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
-	}
-
-	function logBytes20(bytes20 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
-	}
-
-	function logBytes21(bytes21 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
-	}
-
-	function logBytes22(bytes22 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
-	}
-
-	function logBytes23(bytes23 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
-	}
-
-	function logBytes24(bytes24 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
-	}
-
-	function logBytes25(bytes25 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
-	}
-
-	function logBytes26(bytes26 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
-	}
-
-	function logBytes27(bytes27 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
-	}
-
-	function logBytes28(bytes28 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
-	}
-
-	function logBytes29(bytes29 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
-	}
-
-	function logBytes30(bytes30 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
-	}
-
-	function logBytes31(bytes31 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
-	}
-
-	function logBytes32(bytes32 p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
-	}
-
-	function log(uint p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
-	}
-
-	function log(string memory p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
-	}
-
-	function log(bool p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
-	}
-
-	function log(address p0) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
-	}
-
-	function log(uint p0, uint p1) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
-	}
-
-	function log(uint p0, string memory p1) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
-	}
-
-	function log(uint p0, bool p1) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
-	}
-
-	function log(uint p0, address p1) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
-	}
-
-	function log(string memory p0, uint p1) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
-	}
-
-	function log(string memory p0, string memory p1) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
-	}
-
-	function log(string memory p0, bool p1) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
-	}
-
-	function log(string memory p0, address p1) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
-	}
-
-	function log(bool p0, uint p1) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
-	}
-
-	function log(bool p0, string memory p1) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
-	}
-
-	function log(bool p0, bool p1) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
-	}
-
-	function log(bool p0, address p1) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
-	}
-
-	function log(address p0, uint p1) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
-	}
-
-	function log(address p0, string memory p1) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
-	}
-
-	function log(address p0, bool p1) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
-	}
-
-	function log(address p0, address p1) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
-	}
-
-	function log(uint p0, uint p1, uint p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
-	}
-
-	function log(uint p0, uint p1, string memory p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
-	}
-
-	function log(uint p0, uint p1, bool p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
-	}
-
-	function log(uint p0, uint p1, address p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
-	}
-
-	function log(uint p0, string memory p1, uint p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
-	}
-
-	function log(uint p0, string memory p1, string memory p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
-	}
-
-	function log(uint p0, string memory p1, bool p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
-	}
-
-	function log(uint p0, string memory p1, address p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
-	}
-
-	function log(uint p0, bool p1, uint p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
-	}
-
-	function log(uint p0, bool p1, string memory p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
-	}
-
-	function log(uint p0, bool p1, bool p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
-	}
-
-	function log(uint p0, bool p1, address p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
-	}
-
-	function log(uint p0, address p1, uint p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
-	}
-
-	function log(uint p0, address p1, string memory p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
-	}
-
-	function log(uint p0, address p1, bool p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
-	}
-
-	function log(uint p0, address p1, address p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
-	}
-
-	function log(string memory p0, uint p1, uint p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
-	}
-
-	function log(string memory p0, uint p1, string memory p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
-	}
-
-	function log(string memory p0, uint p1, bool p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
-	}
-
-	function log(string memory p0, uint p1, address p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
-	}
-
-	function log(string memory p0, string memory p1, uint p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
-	}
-
-	function log(string memory p0, string memory p1, string memory p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
-	}
-
-	function log(string memory p0, string memory p1, bool p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
-	}
-
-	function log(string memory p0, string memory p1, address p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
-	}
-
-	function log(string memory p0, bool p1, uint p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
-	}
-
-	function log(string memory p0, bool p1, string memory p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
-	}
-
-	function log(string memory p0, bool p1, bool p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
-	}
-
-	function log(string memory p0, bool p1, address p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
-	}
-
-	function log(string memory p0, address p1, uint p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
-	}
-
-	function log(string memory p0, address p1, string memory p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
-	}
-
-	function log(string memory p0, address p1, bool p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
-	}
-
-	function log(string memory p0, address p1, address p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
-	}
-
-	function log(bool p0, uint p1, uint p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
-	}
-
-	function log(bool p0, uint p1, string memory p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
-	}
-
-	function log(bool p0, uint p1, bool p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
-	}
-
-	function log(bool p0, uint p1, address p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
-	}
-
-	function log(bool p0, string memory p1, uint p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
-	}
-
-	function log(bool p0, string memory p1, string memory p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
-	}
-
-	function log(bool p0, string memory p1, bool p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
-	}
-
-	function log(bool p0, string memory p1, address p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
-	}
-
-	function log(bool p0, bool p1, uint p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
-	}
-
-	function log(bool p0, bool p1, string memory p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
-	}
-
-	function log(bool p0, bool p1, bool p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
-	}
-
-	function log(bool p0, bool p1, address p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
-	}
-
-	function log(bool p0, address p1, uint p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
-	}
-
-	function log(bool p0, address p1, string memory p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
-	}
-
-	function log(bool p0, address p1, bool p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
-	}
-
-	function log(bool p0, address p1, address p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
-	}
-
-	function log(address p0, uint p1, uint p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
-	}
-
-	function log(address p0, uint p1, string memory p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
-	}
-
-	function log(address p0, uint p1, bool p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
-	}
-
-	function log(address p0, uint p1, address p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
-	}
-
-	function log(address p0, string memory p1, uint p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
-	}
-
-	function log(address p0, string memory p1, string memory p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
-	}
-
-	function log(address p0, string memory p1, bool p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
-	}
-
-	function log(address p0, string memory p1, address p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
-	}
-
-	function log(address p0, bool p1, uint p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
-	}
-
-	function log(address p0, bool p1, string memory p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
-	}
-
-	function log(address p0, bool p1, bool p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
-	}
-
-	function log(address p0, bool p1, address p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
-	}
-
-	function log(address p0, address p1, uint p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
-	}
-
-	function log(address p0, address p1, string memory p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
-	}
-
-	function log(address p0, address p1, bool p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
-	}
-
-	function log(address p0, address p1, address p2) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
-	}
-
-	function log(uint p0, uint p1, uint p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, uint p1, uint p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, uint p1, uint p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, uint p1, string memory p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, uint p1, bool p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, uint p1, bool p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, uint p1, bool p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, uint p1, address p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, uint p1, address p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, uint p1, address p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, uint p1, address p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, string memory p1, uint p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, string memory p1, bool p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, string memory p1, address p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, string memory p1, address p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, string memory p1, address p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, bool p1, uint p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, bool p1, uint p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, bool p1, uint p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, bool p1, string memory p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, bool p1, bool p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, bool p1, bool p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, bool p1, bool p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, bool p1, address p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, bool p1, address p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, bool p1, address p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, bool p1, address p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, address p1, uint p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, address p1, uint p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, address p1, uint p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, address p1, uint p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, address p1, string memory p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, address p1, string memory p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, address p1, string memory p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, address p1, bool p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, address p1, bool p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, address p1, bool p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, address p1, bool p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, address p1, address p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, address p1, address p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, address p1, address p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
-	}
-
-	function log(uint p0, address p1, address p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, uint p1, uint p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, uint p1, bool p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, uint p1, address p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, uint p1, address p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, uint p1, address p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, string memory p1, address p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, bool p1, uint p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, bool p1, bool p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, bool p1, address p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, bool p1, address p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, bool p1, address p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, address p1, uint p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, address p1, uint p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, address p1, uint p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, address p1, string memory p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, address p1, bool p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, address p1, bool p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, address p1, bool p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, address p1, address p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, address p1, address p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, address p1, address p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
-	}
-
-	function log(string memory p0, address p1, address p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, uint p1, uint p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, uint p1, uint p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, uint p1, uint p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, uint p1, string memory p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, uint p1, bool p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, uint p1, bool p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, uint p1, bool p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, uint p1, address p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, uint p1, address p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, uint p1, address p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, uint p1, address p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, string memory p1, uint p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, string memory p1, bool p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, string memory p1, address p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, string memory p1, address p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, string memory p1, address p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, bool p1, uint p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, bool p1, uint p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, bool p1, uint p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, bool p1, string memory p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, bool p1, bool p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, bool p1, bool p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, bool p1, bool p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, bool p1, address p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, bool p1, address p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, bool p1, address p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, bool p1, address p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, address p1, uint p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, address p1, uint p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, address p1, uint p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, address p1, uint p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, address p1, string memory p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, address p1, string memory p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, address p1, string memory p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, address p1, bool p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, address p1, bool p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, address p1, bool p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, address p1, bool p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, address p1, address p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, address p1, address p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, address p1, address p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
-	}
-
-	function log(bool p0, address p1, address p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, uint p1, uint p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, uint p1, uint p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, uint p1, uint p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, uint p1, uint p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, uint p1, string memory p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, uint p1, string memory p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, uint p1, string memory p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, uint p1, bool p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, uint p1, bool p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, uint p1, bool p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, uint p1, bool p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, uint p1, address p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, uint p1, address p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, uint p1, address p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, uint p1, address p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, string memory p1, uint p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, string memory p1, uint p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, string memory p1, uint p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, string memory p1, string memory p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, string memory p1, bool p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, string memory p1, bool p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, string memory p1, bool p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, string memory p1, address p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, string memory p1, address p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, string memory p1, address p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, string memory p1, address p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, bool p1, uint p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, bool p1, uint p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, bool p1, uint p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, bool p1, uint p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, bool p1, string memory p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, bool p1, string memory p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, bool p1, string memory p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, bool p1, bool p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, bool p1, bool p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, bool p1, bool p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, bool p1, bool p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, bool p1, address p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, bool p1, address p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, bool p1, address p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, bool p1, address p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, address p1, uint p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, address p1, uint p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, address p1, uint p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, address p1, uint p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, address p1, string memory p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, address p1, string memory p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, address p1, string memory p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, address p1, string memory p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, address p1, bool p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, address p1, bool p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, address p1, bool p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, address p1, bool p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, address p1, address p2, uint p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, address p1, address p2, string memory p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, address p1, address p2, bool p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
-	}
-
-	function log(address p0, address p1, address p2, address p3) internal view {
-		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
-	}
-
-}
```
