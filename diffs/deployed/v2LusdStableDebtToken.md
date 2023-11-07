```diff
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/interfaces/IDebtTokenBase.sol b/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/interfaces/IDebtTokenBase.sol
deleted file mode 100644
index e5e4ed9..0000000
--- a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/interfaces/IDebtTokenBase.sol
+++ /dev/null
@@ -1,24 +0,0 @@
-// SPDX-License-Identifier: agpl-3.0
-pragma solidity 0.6.12;
-
-interface IDebtTokenBase {
-  /**
-   * @dev Emitted when a debt token is initialized
-   * @param underlyingAsset The address of the underlying asset
-   * @param pool The address of the associated lending pool
-   * @param incentivesController The address of the incentives controller for this aToken
-   * @param debtTokenDecimals the decimals of the debt token
-   * @param debtTokenName the name of the debt token
-   * @param debtTokenSymbol the symbol of the debt token
-   * @param params A set of encoded parameters for additional initialization
-   **/
-  event Initialized(
-    address indexed underlyingAsset,
-    address indexed pool,
-    address incentivesController,
-    uint8 debtTokenDecimals,
-    string debtTokenName,
-    string debtTokenSymbol,
-    bytes params
-  );
-}
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/dependencies/openzeppelin/contracts/Context.sol b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/Context.sol
similarity index 85%
rename from etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/dependencies/openzeppelin/contracts/Context.sol
rename to etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/Context.sol
index dc82ed7..cfce1bf 100644
--- a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/dependencies/openzeppelin/contracts/Context.sol
+++ b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/Context.sol
@@ -12,11 +12,11 @@ pragma solidity 0.6.12;
  * This contract is only required for intermediate, library-like contracts.
  */
 abstract contract Context {
-  function _msgSender() internal view virtual returns (address payable) {
+  function _msgSender() internal virtual view returns (address payable) {
     return msg.sender;
   }
 
-  function _msgData() internal view virtual returns (bytes memory) {
+  function _msgData() internal virtual view returns (bytes memory) {
     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
     return msg.data;
   }
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20.sol b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20.sol
similarity index 100%
rename from etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20.sol
rename to etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20.sol
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
similarity index 100%
rename from etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
rename to etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/dependencies/openzeppelin/contracts/SafeMath.sol b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/SafeMath.sol
similarity index 100%
rename from etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/dependencies/openzeppelin/contracts/SafeMath.sol
rename to etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/SafeMath.sol
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/interfaces/IAaveIncentivesController.sol b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/IAaveIncentivesController.sol
similarity index 100%
rename from etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/interfaces/IAaveIncentivesController.sol
rename to etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/IAaveIncentivesController.sol
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/interfaces/ICreditDelegationToken.sol b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/ICreditDelegationToken.sol
similarity index 100%
rename from etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/interfaces/ICreditDelegationToken.sol
rename to etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/ICreditDelegationToken.sol
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/interfaces/ILendingPool.sol b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/ILendingPool.sol
similarity index 100%
rename from etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/interfaces/ILendingPool.sol
rename to etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/ILendingPool.sol
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/interfaces/ILendingPoolAddressesProvider.sol b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/ILendingPoolAddressesProvider.sol
similarity index 100%
rename from etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/interfaces/ILendingPoolAddressesProvider.sol
rename to etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/ILendingPoolAddressesProvider.sol
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/interfaces/IStableDebtToken.sol b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/IStableDebtToken.sol
similarity index 100%
rename from etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/interfaces/IStableDebtToken.sol
rename to etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/IStableDebtToken.sol
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
similarity index 91%
rename from etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
rename to etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
index b8e356a..f2b73b8 100644
--- a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
+++ b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
@@ -50,14 +50,14 @@ abstract contract VersionedInitializable {
   }
 
   /**
-   * @dev returns the revision number of the contract
-   * Needs to be defined in the inherited class as a constant.
-   **/
+  * @dev returns the revision number of the contract
+  * Needs to be defined in the inherited class as a constant.
+  **/ 
   function getRevision() internal pure virtual returns (uint256);
 
   /**
-   * @dev Returns true if and only if the function is running in the constructor
-   **/
+  * @dev Returns true if and only if the function is running in the constructor
+  **/ 
   function isConstructor() private view returns (bool) {
     // extcodesize checks the size of the code stored in an address, and
     // address returns the current address. Since the code is still not
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/libraries/helpers/Errors.sol b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/helpers/Errors.sol
similarity index 99%
rename from etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/libraries/helpers/Errors.sol
rename to etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/helpers/Errors.sol
index 8756d79..adc7bee 100644
--- a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/libraries/helpers/Errors.sol
+++ b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/helpers/Errors.sol
@@ -101,7 +101,6 @@ library Errors {
   string public constant LP_INCONSISTENT_PARAMS_LENGTH = '74';
   string public constant UL_INVALID_INDEX = '77';
   string public constant LP_NOT_CONTRACT = '78';
-  string public constant SDT_STABLE_DEBT_OVERFLOW = '79';
   string public constant SDT_BURN_EXCEEDS_BALANCE = '80';
 
   enum CollateralManagerErrors {
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/libraries/math/MathUtils.sol b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/math/MathUtils.sol
similarity index 100%
rename from etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/libraries/math/MathUtils.sol
rename to etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/math/MathUtils.sol
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/libraries/math/WadRayMath.sol b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/math/WadRayMath.sol
similarity index 100%
rename from etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/libraries/math/WadRayMath.sol
rename to etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/math/WadRayMath.sol
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/libraries/types/DataTypes.sol b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/types/DataTypes.sol
similarity index 100%
rename from etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/libraries/types/DataTypes.sol
rename to etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/types/DataTypes.sol
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/tokenization/IncentivizedERC20.sol b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/IncentivizedERC20.sol
similarity index 100%
rename from etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/tokenization/IncentivizedERC20.sol
rename to etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/IncentivizedERC20.sol
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol
similarity index 79%
rename from etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol
rename to etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol
index 7840140..3283510 100644
--- a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol
+++ b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol
@@ -16,7 +16,7 @@ import {Errors} from '../libraries/helpers/Errors.sol';
 contract StableDebtToken is IStableDebtToken, DebtTokenBase {
   using WadRayMath for uint256;
 
-  uint256 public constant DEBT_TOKEN_REVISION = 0x1;
+  uint256 public constant DEBT_TOKEN_REVISION = 0x2;
 
   uint256 internal _avgStableRate;
   mapping(address => uint40) internal _timestamps;
@@ -79,79 +79,18 @@ contract StableDebtToken is IStableDebtToken, DebtTokenBase {
     return accountBalance.rayMul(cumulatedInterest);
   }
 
-  struct MintLocalVars {
-    uint256 previousSupply;
-    uint256 nextSupply;
-    uint256 amountInRay;
-    uint256 newStableRate;
-    uint256 currentAvgStableRate;
-  }
 
   /**
-   * @dev Mints debt token to the `onBehalfOf` address.
+   * @dev DEPRECATED: Was used for minting debt token on borrow and rebalanceStableBorrowRate actions.
    * -  Only callable by the LendingPool
-   * - The resulting rate is the weighted average between the rate of the new debt
-   * and the rate of the previous debt
-   * @param user The address receiving the borrowed underlying, being the delegatee in case
-   * of credit delegate, or same as `onBehalfOf` otherwise
-   * @param onBehalfOf The address receiving the debt tokens
-   * @param amount The amount of debt tokens to mint
-   * @param rate The rate of the debt being minted
    **/
   function mint(
-    address user,
-    address onBehalfOf,
-    uint256 amount,
-    uint256 rate
+    address,
+    address,
+    uint256,
+    uint256
   ) external override onlyLendingPool returns (bool) {
-    MintLocalVars memory vars;
-
-    if (user != onBehalfOf) {
-      _decreaseBorrowAllowance(onBehalfOf, user, amount);
-    }
-
-    (, uint256 currentBalance, uint256 balanceIncrease) = _calculateBalanceIncrease(onBehalfOf);
-
-    vars.previousSupply = totalSupply();
-    vars.currentAvgStableRate = _avgStableRate;
-    vars.nextSupply = _totalSupply = vars.previousSupply.add(amount);
-
-    vars.amountInRay = amount.wadToRay();
-
-    vars.newStableRate = _usersStableRate[onBehalfOf]
-      .rayMul(currentBalance.wadToRay())
-      .add(vars.amountInRay.rayMul(rate))
-      .rayDiv(currentBalance.add(amount).wadToRay());
-
-    require(vars.newStableRate <= type(uint128).max, Errors.SDT_STABLE_DEBT_OVERFLOW);
-    _usersStableRate[onBehalfOf] = vars.newStableRate;
-
-    //solium-disable-next-line
-    _totalSupplyTimestamp = _timestamps[onBehalfOf] = uint40(block.timestamp);
-
-    // Calculates the updated average stable rate
-    vars.currentAvgStableRate = _avgStableRate = vars
-      .currentAvgStableRate
-      .rayMul(vars.previousSupply.wadToRay())
-      .add(rate.rayMul(vars.amountInRay))
-      .rayDiv(vars.nextSupply.wadToRay());
-
-    _mint(onBehalfOf, amount.add(balanceIncrease), vars.previousSupply);
-
-    emit Transfer(address(0), onBehalfOf, amount);
-
-    emit Mint(
-      user,
-      onBehalfOf,
-      amount,
-      currentBalance,
-      balanceIncrease,
-      vars.newStableRate,
-      vars.currentAvgStableRate,
-      vars.nextSupply
-    );
-
-    return currentBalance == 0;
+    revert('STABLE_BORROWING_DEPRECATED');
   }
 
   /**
diff --git a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/tokenization/base/DebtTokenBase.sol b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/base/DebtTokenBase.sol
similarity index 94%
rename from etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/tokenization/base/DebtTokenBase.sol
rename to etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/base/DebtTokenBase.sol
index 59b6dd8..07bdef2 100644
--- a/etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f/StableDebtToken/contracts/protocol/tokenization/base/DebtTokenBase.sol
+++ b/etherscan/deployed/v2LusdStableDebtToken/StableDebtToken/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/base/DebtTokenBase.sol
@@ -3,7 +3,6 @@ pragma solidity 0.6.12;
 
 import {ILendingPool} from '../../../interfaces/ILendingPool.sol';
 import {ICreditDelegationToken} from '../../../interfaces/ICreditDelegationToken.sol';
-import {IDebtTokenBase} from '../../../interfaces/IDebtTokenBase.sol';
 import {
   VersionedInitializable
 } from '../../libraries/aave-upgradeability/VersionedInitializable.sol';
@@ -19,8 +18,7 @@ import {Errors} from '../../libraries/helpers/Errors.sol';
 abstract contract DebtTokenBase is
   IncentivizedERC20,
   VersionedInitializable,
-  ICreditDelegationToken,
-  IDebtTokenBase
+  ICreditDelegationToken
 {
   address public immutable UNDERLYING_ASSET_ADDRESS;
   ILendingPool public immutable POOL;
@@ -64,16 +62,6 @@ abstract contract DebtTokenBase is
     _setName(name);
     _setSymbol(symbol);
     _setDecimals(decimals);
-
-    emit Initialized(
-      UNDERLYING_ASSET_ADDRESS,
-      address(POOL),
-      address(_incentivesController),
-      decimals,
-      name,
-      symbol,
-      ''
-    );
   }
 
   /**
```
