```diff
diff --git a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/Context.sol b/src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/Context.sol
index dc82ed7..cfce1bf 100644
--- a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/Context.sol
+++ b/src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/Context.sol
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
diff --git a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20.sol b/src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20.sol
index 3096454..3d69bff 100644
--- a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20.sol
+++ b/src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20.sol
@@ -58,7 +58,11 @@ interface IERC20 {
    *
    * Emits a {Transfer} event.
    */
-  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
+  function transferFrom(
+    address sender,
+    address recipient,
+    uint256 amount
+  ) external returns (bool);
 
   /**
    * @dev Emitted when `value` tokens are moved from one account (`from`) to
diff --git a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/SafeMath.sol b/src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/SafeMath.sol
index 5c68ca1..80f7d67 100644
--- a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/SafeMath.sol
+++ b/src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/SafeMath.sol
@@ -53,7 +53,11 @@ library SafeMath {
    * Requirements:
    * - Subtraction cannot overflow.
    */
-  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
+  function sub(
+    uint256 a,
+    uint256 b,
+    string memory errorMessage
+  ) internal pure returns (uint256) {
     require(b <= a, errorMessage);
     uint256 c = a - b;
 
@@ -109,7 +113,11 @@ library SafeMath {
    * Requirements:
    * - The divisor cannot be zero.
    */
-  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
+  function div(
+    uint256 a,
+    uint256 b,
+    string memory errorMessage
+  ) internal pure returns (uint256) {
     // Solidity only automatically asserts when dividing by 0
     require(b > 0, errorMessage);
     uint256 c = a / b;
@@ -144,7 +152,11 @@ library SafeMath {
    * Requirements:
    * - The divisor cannot be zero.
    */
-  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
+  function mod(
+    uint256 a,
+    uint256 b,
+    string memory errorMessage
+  ) internal pure returns (uint256) {
     require(b != 0, errorMessage);
     return a % b;
   }
diff --git a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/IAaveIncentivesController.sol b/src/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/IAaveIncentivesController.sol
index c4bfb7d..c049bd7 100644
--- a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/IAaveIncentivesController.sol
+++ b/src/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/IAaveIncentivesController.sol
@@ -3,5 +3,9 @@ pragma solidity 0.6.12;
 pragma experimental ABIEncoderV2;
 
 interface IAaveIncentivesController {
-  function handleAction(address user, uint256 userBalance, uint256 totalSupply) external;
+  function handleAction(
+    address user,
+    uint256 userBalance,
+    uint256 totalSupply
+  ) external;
 }
diff --git a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/ILendingPool.sol b/src/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/ILendingPool.sol
index 172d7c9..64f726c 100644
--- a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/ILendingPool.sol
+++ b/src/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/ILendingPool.sol
@@ -178,7 +178,12 @@ interface ILendingPool {
    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
    **/
-  function deposit(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
+  function deposit(
+    address asset,
+    uint256 amount,
+    address onBehalfOf,
+    uint16 referralCode
+  ) external;
 
   /**
    * @dev Withdraws an `amount` of underlying asset from the reserve, burning the equivalent aTokens owned
@@ -191,7 +196,11 @@ interface ILendingPool {
    *   different wallet
    * @return The final amount withdrawn
    **/
-  function withdraw(address asset, uint256 amount, address to) external returns (uint256);
+  function withdraw(
+    address asset,
+    uint256 amount,
+    address to
+  ) external returns (uint256);
 
   /**
    * @dev Allows users to borrow a specific `amount` of the reserve underlying asset, provided that the borrower
@@ -316,9 +325,7 @@ interface ILendingPool {
    * @return ltv the loan to value of the user
    * @return healthFactor the current health factor of the user
    **/
-  function getUserAccountData(
-    address user
-  )
+  function getUserAccountData(address user)
     external
     view
     returns (
@@ -338,10 +345,8 @@ interface ILendingPool {
     address interestRateStrategyAddress
   ) external;
 
-  function setReserveInterestRateStrategyAddress(
-    address reserve,
-    address rateStrategyAddress
-  ) external;
+  function setReserveInterestRateStrategyAddress(address reserve, address rateStrategyAddress)
+    external;
 
   function setConfiguration(address reserve, uint256 configuration) external;
 
@@ -350,18 +355,20 @@ interface ILendingPool {
    * @param asset The address of the underlying asset of the reserve
    * @return The configuration of the reserve
    **/
-  function getConfiguration(
-    address asset
-  ) external view returns (DataTypes.ReserveConfigurationMap memory);
+  function getConfiguration(address asset)
+    external
+    view
+    returns (DataTypes.ReserveConfigurationMap memory);
 
   /**
    * @dev Returns the configuration of the user across all the reserves
    * @param user The user address
    * @return The configuration of the user
    **/
-  function getUserConfiguration(
-    address user
-  ) external view returns (DataTypes.UserConfigurationMap memory);
+  function getUserConfiguration(address user)
+    external
+    view
+    returns (DataTypes.UserConfigurationMap memory);
 
   /**
    * @dev Returns the normalized income normalized income of the reserve
diff --git a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/IStableDebtToken.sol b/src/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/IStableDebtToken.sol
index b68cddf..c24750b 100644
--- a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/IStableDebtToken.sol
+++ b/src/v2EthStableDebtToken/StableDebtToken/contracts/interfaces/IStableDebtToken.sol
@@ -96,7 +96,15 @@ interface IStableDebtToken {
   /**
    * @dev Returns the principal, the total supply and the average stable rate
    **/
-  function getSupplyData() external view returns (uint256, uint256, uint256, uint40);
+  function getSupplyData()
+    external
+    view
+    returns (
+      uint256,
+      uint256,
+      uint256,
+      uint40
+    );
 
   /**
    * @dev Returns the timestamp of the last update of the total supply
diff --git a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol b/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
index b8e356a..f2b73b8 100644
--- a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
+++ b/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
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
diff --git a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/helpers/Errors.sol b/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/helpers/Errors.sol
index 8756d79..adc7bee 100644
--- a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/helpers/Errors.sol
+++ b/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/helpers/Errors.sol
@@ -101,7 +101,6 @@ library Errors {
   string public constant LP_INCONSISTENT_PARAMS_LENGTH = '74';
   string public constant UL_INVALID_INDEX = '77';
   string public constant LP_NOT_CONTRACT = '78';
-  string public constant SDT_STABLE_DEBT_OVERFLOW = '79';
   string public constant SDT_BURN_EXCEEDS_BALANCE = '80';
 
   enum CollateralManagerErrors {
diff --git a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/math/MathUtils.sol b/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/math/MathUtils.sol
index 18d42a5..7078a82 100644
--- a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/math/MathUtils.sol
+++ b/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/math/MathUtils.sol
@@ -18,10 +18,11 @@ library MathUtils {
    * @return The interest rate linearly accumulated during the timeDelta, in ray
    **/
 
-  function calculateLinearInterest(
-    uint256 rate,
-    uint40 lastUpdateTimestamp
-  ) internal view returns (uint256) {
+  function calculateLinearInterest(uint256 rate, uint40 lastUpdateTimestamp)
+    internal
+    view
+    returns (uint256)
+  {
     //solium-disable-next-line
     uint256 timeDifference = block.timestamp.sub(uint256(lastUpdateTimestamp));
 
@@ -73,10 +74,11 @@ library MathUtils {
    * @param rate The interest rate (in ray)
    * @param lastUpdateTimestamp The timestamp from which the interest accumulation needs to be calculated
    **/
-  function calculateCompoundedInterest(
-    uint256 rate,
-    uint40 lastUpdateTimestamp
-  ) internal view returns (uint256) {
+  function calculateCompoundedInterest(uint256 rate, uint40 lastUpdateTimestamp)
+    internal
+    view
+    returns (uint256)
+  {
     return calculateCompoundedInterest(rate, lastUpdateTimestamp, block.timestamp);
   }
 }
diff --git a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/types/DataTypes.sol b/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/types/DataTypes.sol
index 25ef764..a19e5ef 100644
--- a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/types/DataTypes.sol
+++ b/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/types/DataTypes.sol
@@ -45,9 +45,5 @@ library DataTypes {
     uint256 data;
   }
 
-  enum InterestRateMode {
-    NONE,
-    STABLE,
-    VARIABLE
-  }
+  enum InterestRateMode {NONE, STABLE, VARIABLE}
 }
diff --git a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/IncentivizedERC20.sol b/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/IncentivizedERC20.sol
index edebb9d..101eaf9 100644
--- a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/IncentivizedERC20.sol
+++ b/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/IncentivizedERC20.sol
@@ -90,10 +90,13 @@ contract IncentivizedERC20 is Context, IERC20, IERC20Detailed {
    * @param spender The user allowed to spend the owner's tokens
    * @return The amount of owner's tokens spender is allowed to spend
    **/
-  function allowance(
-    address owner,
-    address spender
-  ) public view virtual override returns (uint256) {
+  function allowance(address owner, address spender)
+    public
+    view
+    virtual
+    override
+    returns (uint256)
+  {
     return _allowances[owner][spender];
   }
 
@@ -146,10 +149,11 @@ contract IncentivizedERC20 is Context, IERC20, IERC20Detailed {
    * @param subtractedValue The amount being subtracted to the allowance
    * @return `true`
    **/
-  function decreaseAllowance(
-    address spender,
-    uint256 subtractedValue
-  ) public virtual returns (bool) {
+  function decreaseAllowance(address spender, uint256 subtractedValue)
+    public
+    virtual
+    returns (bool)
+  {
     _approve(
       _msgSender(),
       spender,
@@ -161,7 +165,11 @@ contract IncentivizedERC20 is Context, IERC20, IERC20Detailed {
     return true;
   }
 
-  function _transfer(address sender, address recipient, uint256 amount) internal virtual {
+  function _transfer(
+    address sender,
+    address recipient,
+    uint256 amount
+  ) internal virtual {
     require(sender != address(0), 'ERC20: transfer from the zero address');
     require(recipient != address(0), 'ERC20: transfer to the zero address');
 
@@ -213,7 +221,11 @@ contract IncentivizedERC20 is Context, IERC20, IERC20Detailed {
     }
   }
 
-  function _approve(address owner, address spender, uint256 amount) internal virtual {
+  function _approve(
+    address owner,
+    address spender,
+    uint256 amount
+  ) internal virtual {
     require(owner != address(0), 'ERC20: approve from the zero address');
     require(spender != address(0), 'ERC20: approve to the zero address');
 
@@ -233,5 +245,9 @@ contract IncentivizedERC20 is Context, IERC20, IERC20Detailed {
     _decimals = newDecimals;
   }
 
-  function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
+  function _beforeTokenTransfer(
+    address from,
+    address to,
+    uint256 amount
+  ) internal virtual {}
 }
diff --git a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol b/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol
index f05f6d5..3283510 100644
--- a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol
+++ b/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol
@@ -16,7 +16,7 @@ import {Errors} from '../libraries/helpers/Errors.sol';
 contract StableDebtToken is IStableDebtToken, DebtTokenBase {
   using WadRayMath for uint256;
 
-  uint256 public constant DEBT_TOKEN_REVISION = 0x1;
+  uint256 public constant DEBT_TOKEN_REVISION = 0x2;
 
   uint256 internal _avgStableRate;
   mapping(address => uint40) internal _timestamps;
@@ -74,86 +74,23 @@ contract StableDebtToken is IStableDebtToken, DebtTokenBase {
     if (accountBalance == 0) {
       return 0;
     }
-    uint256 cumulatedInterest = MathUtils.calculateCompoundedInterest(
-      stableRate,
-      _timestamps[account]
-    );
+    uint256 cumulatedInterest =
+      MathUtils.calculateCompoundedInterest(stableRate, _timestamps[account]);
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
@@ -228,9 +165,15 @@ contract StableDebtToken is IStableDebtToken, DebtTokenBase {
    * @param user The address of the user for which the interest is being accumulated
    * @return The previous principal balance, the new principal balance and the balance increase
    **/
-  function _calculateBalanceIncrease(
-    address user
-  ) internal view returns (uint256, uint256, uint256) {
+  function _calculateBalanceIncrease(address user)
+    internal
+    view
+    returns (
+      uint256,
+      uint256,
+      uint256
+    )
+  {
     uint256 previousPrincipalBalance = super.balanceOf(user);
 
     if (previousPrincipalBalance == 0) {
@@ -250,7 +193,17 @@ contract StableDebtToken is IStableDebtToken, DebtTokenBase {
   /**
    * @dev Returns the principal and total supply, the average borrow rate and the last supply update timestamp
    **/
-  function getSupplyData() public view override returns (uint256, uint256, uint256, uint40) {
+  function getSupplyData()
+    public
+    view
+    override
+    returns (
+      uint256,
+      uint256,
+      uint256,
+      uint40
+    )
+  {
     uint256 avgRate = _avgStableRate;
     return (super.totalSupply(), _calcTotalSupply(avgRate), avgRate, _totalSupplyTimestamp);
   }
@@ -298,10 +251,8 @@ contract StableDebtToken is IStableDebtToken, DebtTokenBase {
       return 0;
     }
 
-    uint256 cumulatedInterest = MathUtils.calculateCompoundedInterest(
-      avgRate,
-      _totalSupplyTimestamp
-    );
+    uint256 cumulatedInterest =
+      MathUtils.calculateCompoundedInterest(avgRate, _totalSupplyTimestamp);
 
     return principalSupply.rayMul(cumulatedInterest);
   }
@@ -312,7 +263,11 @@ contract StableDebtToken is IStableDebtToken, DebtTokenBase {
    * @param amount The amount being minted
    * @param oldTotalSupply the total supply before the minting event
    **/
-  function _mint(address account, uint256 amount, uint256 oldTotalSupply) internal {
+  function _mint(
+    address account,
+    uint256 amount,
+    uint256 oldTotalSupply
+  ) internal {
     uint256 oldAccountBalance = _balances[account];
     _balances[account] = oldAccountBalance.add(amount);
 
@@ -327,7 +282,11 @@ contract StableDebtToken is IStableDebtToken, DebtTokenBase {
    * @param amount The amount being burned
    * @param oldTotalSupply The total supply before the burning event
    **/
-  function _burn(address account, uint256 amount, uint256 oldTotalSupply) internal {
+  function _burn(
+    address account,
+    uint256 amount,
+    uint256 oldTotalSupply
+  ) internal {
     uint256 oldAccountBalance = _balances[account];
     _balances[account] = oldAccountBalance.sub(amount, Errors.SDT_BURN_EXCEEDS_BALANCE);
 
diff --git a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/base/DebtTokenBase.sol b/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/base/DebtTokenBase.sol
index 0a28849..07bdef2 100644
--- a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/base/DebtTokenBase.sol
+++ b/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/base/DebtTokenBase.sol
@@ -3,7 +3,9 @@ pragma solidity 0.6.12;
 
 import {ILendingPool} from '../../../interfaces/ILendingPool.sol';
 import {ICreditDelegationToken} from '../../../interfaces/ICreditDelegationToken.sol';
-import {VersionedInitializable} from '../../libraries/aave-upgradeability/VersionedInitializable.sol';
+import {
+  VersionedInitializable
+} from '../../libraries/aave-upgradeability/VersionedInitializable.sol';
 import {IncentivizedERC20} from '../IncentivizedERC20.sol';
 import {Errors} from '../../libraries/helpers/Errors.sol';
 
@@ -26,7 +28,7 @@ abstract contract DebtTokenBase is
   /**
    * @dev Only lending pool can call functions marked by this modifier
    **/
-  modifier onlyLendingPool() {
+  modifier onlyLendingPool {
     require(_msgSender() == address(POOL), Errors.CT_CALLER_MUST_BE_LENDING_POOL);
     _;
   }
@@ -52,7 +54,11 @@ abstract contract DebtTokenBase is
    * @param symbol The symbol of the token
    * @param decimals The decimals of the token
    */
-  function initialize(uint8 decimals, string memory name, string memory symbol) public initializer {
+  function initialize(
+    uint8 decimals,
+    string memory name,
+    string memory symbol
+  ) public initializer {
     _setName(name);
     _setSymbol(symbol);
     _setDecimals(decimals);
@@ -76,10 +82,12 @@ abstract contract DebtTokenBase is
    * @param toUser The user to give allowance to
    * @return the current allowance of toUser
    **/
-  function borrowAllowance(
-    address fromUser,
-    address toUser
-  ) external view override returns (uint256) {
+  function borrowAllowance(address fromUser, address toUser)
+    external
+    view
+    override
+    returns (uint256)
+  {
     return _borrowAllowances[fromUser][toUser];
   }
 
@@ -93,10 +101,13 @@ abstract contract DebtTokenBase is
     revert('TRANSFER_NOT_SUPPORTED');
   }
 
-  function allowance(
-    address owner,
-    address spender
-  ) public view virtual override returns (uint256) {
+  function allowance(address owner, address spender)
+    public
+    view
+    virtual
+    override
+    returns (uint256)
+  {
     owner;
     spender;
     revert('ALLOWANCE_NOT_SUPPORTED');
@@ -119,29 +130,35 @@ abstract contract DebtTokenBase is
     revert('TRANSFER_NOT_SUPPORTED');
   }
 
-  function increaseAllowance(
-    address spender,
-    uint256 addedValue
-  ) public virtual override returns (bool) {
+  function increaseAllowance(address spender, uint256 addedValue)
+    public
+    virtual
+    override
+    returns (bool)
+  {
     spender;
     addedValue;
     revert('ALLOWANCE_NOT_SUPPORTED');
   }
 
-  function decreaseAllowance(
-    address spender,
-    uint256 subtractedValue
-  ) public virtual override returns (bool) {
+  function decreaseAllowance(address spender, uint256 subtractedValue)
+    public
+    virtual
+    override
+    returns (bool)
+  {
     spender;
     subtractedValue;
     revert('ALLOWANCE_NOT_SUPPORTED');
   }
 
-  function _decreaseBorrowAllowance(address delegator, address delegatee, uint256 amount) internal {
-    uint256 newAllowance = _borrowAllowances[delegator][delegatee].sub(
-      amount,
-      Errors.BORROW_ALLOWANCE_NOT_ENOUGH
-    );
+  function _decreaseBorrowAllowance(
+    address delegator,
+    address delegatee,
+    uint256 amount
+  ) internal {
+    uint256 newAllowance =
+      _borrowAllowances[delegator][delegatee].sub(amount, Errors.BORROW_ALLOWANCE_NOT_ENOUGH);
 
     _borrowAllowances[delegator][delegatee] = newAllowance;
 
```
