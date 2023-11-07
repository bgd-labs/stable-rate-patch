```diff
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/IERC20.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/IERC20.sol
index 3096454..3d69bff 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/IERC20.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/IERC20.sol
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
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeERC20.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeERC20.sol
index 48c7e18..0a27559 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeERC20.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeERC20.sol
@@ -19,15 +19,28 @@ library SafeERC20 {
   using SafeMath for uint256;
   using Address for address;
 
-  function safeTransfer(IERC20 token, address to, uint256 value) internal {
+  function safeTransfer(
+    IERC20 token,
+    address to,
+    uint256 value
+  ) internal {
     callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
   }
 
-  function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
+  function safeTransferFrom(
+    IERC20 token,
+    address from,
+    address to,
+    uint256 value
+  ) internal {
     callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
   }
 
-  function safeApprove(IERC20 token, address spender, uint256 value) internal {
+  function safeApprove(
+    IERC20 token,
+    address spender,
+    uint256 value
+  ) internal {
     require(
       (value == 0) || (token.allowance(address(this), spender) == 0),
       'SafeERC20: approve from non-zero to non-zero allowance'
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeMath.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeMath.sol
index 5c68ca1..80f7d67 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeMath.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeMath.sol
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
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAToken.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAToken.sol
index 71e6ef6..cf0ea26 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAToken.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAToken.sol
@@ -22,7 +22,11 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * @param index The new liquidity index of the reserve
    * @return `true` if the the previous balance of the user was 0
    */
-  function mint(address user, uint256 amount, uint256 index) external returns (bool);
+  function mint(
+    address user,
+    uint256 amount,
+    uint256 index
+  ) external returns (bool);
 
   /**
    * @dev Emitted after aTokens are burned
@@ -49,7 +53,12 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * @param amount The amount being burned
    * @param index The new liquidity index of the reserve
    **/
-  function burn(address user, address receiverOfUnderlying, uint256 amount, uint256 index) external;
+  function burn(
+    address user,
+    address receiverOfUnderlying,
+    uint256 amount,
+    uint256 index
+  ) external;
 
   /**
    * @dev Mints aTokens to the reserve treasury
@@ -64,7 +73,11 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * @param to The recipient
    * @param value The amount of tokens getting transferred
    **/
-  function transferOnLiquidation(address from, address to, uint256 value) external;
+  function transferOnLiquidation(
+    address from,
+    address to,
+    uint256 value
+  ) external;
 
   /**
    * @dev Transfers the underlying asset to `target`. Used by the LendingPool to transfer
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAaveIncentivesController.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAaveIncentivesController.sol
index 2b9ca0e..0006e31 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAaveIncentivesController.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAaveIncentivesController.sol
@@ -21,7 +21,14 @@ interface IAaveIncentivesController {
    * @param asset The address of the reference asset of the distribution
    * @return The asset index, the emission per second and the last updated timestamp
    **/
-  function getAssetData(address asset) external view returns (uint256, uint256, uint256);
+  function getAssetData(address asset)
+    external
+    view
+    returns (
+      uint256,
+      uint256,
+      uint256
+    );
 
   /*
    * LEGACY **************************
@@ -29,7 +36,14 @@ interface IAaveIncentivesController {
    * @param asset The address of the reference asset of the distribution
    * @return The asset index, the emission per second and the last updated timestamp
    **/
-  function assets(address asset) external view returns (uint128, uint128, uint256);
+  function assets(address asset)
+    external
+    view
+    returns (
+      uint128,
+      uint128,
+      uint256
+    );
 
   /**
    * @dev Whitelists an address to claim the rewards on behalf of another address
@@ -50,10 +64,8 @@ interface IAaveIncentivesController {
    * @param assets The assets to incentivize
    * @param emissionsPerSecond The emission for each asset
    */
-  function configureAssets(
-    address[] calldata assets,
-    uint256[] calldata emissionsPerSecond
-  ) external;
+  function configureAssets(address[] calldata assets, uint256[] calldata emissionsPerSecond)
+    external;
 
   /**
    * @dev Called by the corresponding asset on any update that affects the rewards distribution
@@ -61,17 +73,21 @@ interface IAaveIncentivesController {
    * @param userBalance The balance of the user of the asset in the lending pool
    * @param totalSupply The total supply of the asset in the lending pool
    **/
-  function handleAction(address asset, uint256 userBalance, uint256 totalSupply) external;
+  function handleAction(
+    address asset,
+    uint256 userBalance,
+    uint256 totalSupply
+  ) external;
 
   /**
    * @dev Returns the total of rewards of an user, already accrued + not yet accrued
    * @param user The address of the user
    * @return The rewards
    **/
-  function getRewardsBalance(
-    address[] calldata assets,
-    address user
-  ) external view returns (uint256);
+  function getRewardsBalance(address[] calldata assets, address user)
+    external
+    view
+    returns (uint256);
 
   /**
    * @dev Claims reward for an user, on all the assets of the lending pool, accumulating the pending rewards
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/ILendingPool.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/ILendingPool.sol
index 172d7c9..64f726c 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/ILendingPool.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/ILendingPool.sol
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
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IReserveInterestRateStrategy.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IReserveInterestRateStrategy.sol
index 242774a..cee593c 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IReserveInterestRateStrategy.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IReserveInterestRateStrategy.sol
@@ -18,7 +18,14 @@ interface IReserveInterestRateStrategy {
     uint256 totalVariableDebt,
     uint256 averageStableBorrowRate,
     uint256 reserveFactor
-  ) external view returns (uint256, uint256, uint256);
+  )
+    external
+    view
+    returns (
+      uint256,
+      uint256,
+      uint256
+    );
 
   function calculateInterestRates(
     address reserve,
@@ -32,5 +39,9 @@ interface IReserveInterestRateStrategy {
   )
     external
     view
-    returns (uint256 liquidityRate, uint256 stableBorrowRate, uint256 variableBorrowRate);
+    returns (
+      uint256 liquidityRate,
+      uint256 stableBorrowRate,
+      uint256 variableBorrowRate
+    );
 }
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IStableDebtToken.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IStableDebtToken.sol
index 7fdf8e4..e39cf8b 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IStableDebtToken.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IStableDebtToken.sol
@@ -99,7 +99,15 @@ interface IStableDebtToken is IInitializableDebtToken {
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
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IVariableDebtToken.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IVariableDebtToken.sol
index 8941a15..d88c25f 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IVariableDebtToken.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IVariableDebtToken.sol
@@ -49,7 +49,11 @@ interface IVariableDebtToken is IScaledBalanceToken, IInitializableDebtToken {
    * @param user The user which debt is burnt
    * @param index The variable debt index of the reserve
    **/
-  function burn(address user, uint256 amount, uint256 index) external;
+  function burn(
+    address user,
+    uint256 amount,
+    uint256 index
+  ) external;
 
   /**
    * @dev Returns the address of the incentives controller contract
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol
index ab08244..8069272 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol
@@ -150,9 +150,8 @@ contract LendingPoolCollateralManager is
     // If the liquidator reclaims the underlying asset, we make sure there is enough available liquidity in the
     // collateral reserve
     if (!receiveAToken) {
-      uint256 currentAvailableCollateral = IERC20(collateralAsset).balanceOf(
-        address(vars.collateralAtoken)
-      );
+      uint256 currentAvailableCollateral =
+        IERC20(collateralAsset).balanceOf(address(vars.collateralAtoken));
       if (currentAvailableCollateral < vars.maxCollateralToLiquidate) {
         return (
           uint256(Errors.CollateralManagerErrors.NOT_ENOUGH_LIQUIDITY),
@@ -297,17 +296,17 @@ contract LendingPoolCollateralManager is
     vars.maxAmountCollateralToLiquidate = vars
       .debtAssetPrice
       .mul(debtToCover)
-      .mul(10 ** vars.collateralDecimals)
+      .mul(10**vars.collateralDecimals)
       .percentMul(vars.liquidationBonus)
-      .div(vars.collateralPrice.mul(10 ** vars.debtAssetDecimals));
+      .div(vars.collateralPrice.mul(10**vars.debtAssetDecimals));
 
     if (vars.maxAmountCollateralToLiquidate > userCollateralBalance) {
       collateralAmount = userCollateralBalance;
       debtAmountNeeded = vars
         .collateralPrice
         .mul(collateralAmount)
-        .mul(10 ** vars.debtAssetDecimals)
-        .div(vars.debtAssetPrice.mul(10 ** vars.collateralDecimals))
+        .mul(10**vars.debtAssetDecimals)
+        .div(vars.debtAssetPrice.mul(10**vars.collateralDecimals))
         .percentDiv(vars.liquidationBonus);
     } else {
       collateralAmount = vars.maxAmountCollateralToLiquidate;
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/ReserveConfiguration.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
index 3e853a9..5649a58 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
@@ -61,10 +61,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param threshold The new liquidation threshold
    **/
-  function setLiquidationThreshold(
-    DataTypes.ReserveConfigurationMap memory self,
-    uint256 threshold
-  ) internal pure {
+  function setLiquidationThreshold(DataTypes.ReserveConfigurationMap memory self, uint256 threshold)
+    internal
+    pure
+  {
     require(threshold <= MAX_VALID_LIQUIDATION_THRESHOLD, Errors.RC_INVALID_LIQ_THRESHOLD);
 
     self.data =
@@ -77,9 +77,11 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The liquidation threshold
    **/
-  function getLiquidationThreshold(
-    DataTypes.ReserveConfigurationMap storage self
-  ) internal view returns (uint256) {
+  function getLiquidationThreshold(DataTypes.ReserveConfigurationMap storage self)
+    internal
+    view
+    returns (uint256)
+  {
     return (self.data & ~LIQUIDATION_THRESHOLD_MASK) >> LIQUIDATION_THRESHOLD_START_BIT_POSITION;
   }
 
@@ -88,10 +90,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param bonus The new liquidation bonus
    **/
-  function setLiquidationBonus(
-    DataTypes.ReserveConfigurationMap memory self,
-    uint256 bonus
-  ) internal pure {
+  function setLiquidationBonus(DataTypes.ReserveConfigurationMap memory self, uint256 bonus)
+    internal
+    pure
+  {
     require(bonus <= MAX_VALID_LIQUIDATION_BONUS, Errors.RC_INVALID_LIQ_BONUS);
 
     self.data =
@@ -104,9 +106,11 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The liquidation bonus
    **/
-  function getLiquidationBonus(
-    DataTypes.ReserveConfigurationMap storage self
-  ) internal view returns (uint256) {
+  function getLiquidationBonus(DataTypes.ReserveConfigurationMap storage self)
+    internal
+    view
+    returns (uint256)
+  {
     return (self.data & ~LIQUIDATION_BONUS_MASK) >> LIQUIDATION_BONUS_START_BIT_POSITION;
   }
 
@@ -115,10 +119,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param decimals The decimals
    **/
-  function setDecimals(
-    DataTypes.ReserveConfigurationMap memory self,
-    uint256 decimals
-  ) internal pure {
+  function setDecimals(DataTypes.ReserveConfigurationMap memory self, uint256 decimals)
+    internal
+    pure
+  {
     require(decimals <= MAX_VALID_DECIMALS, Errors.RC_INVALID_DECIMALS);
 
     self.data = (self.data & DECIMALS_MASK) | (decimals << RESERVE_DECIMALS_START_BIT_POSITION);
@@ -129,9 +133,11 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The decimals of the asset
    **/
-  function getDecimals(
-    DataTypes.ReserveConfigurationMap storage self
-  ) internal view returns (uint256) {
+  function getDecimals(DataTypes.ReserveConfigurationMap storage self)
+    internal
+    view
+    returns (uint256)
+  {
     return (self.data & ~DECIMALS_MASK) >> RESERVE_DECIMALS_START_BIT_POSITION;
   }
 
@@ -180,10 +186,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param enabled True if the borrowing needs to be enabled, false otherwise
    **/
-  function setBorrowingEnabled(
-    DataTypes.ReserveConfigurationMap memory self,
-    bool enabled
-  ) internal pure {
+  function setBorrowingEnabled(DataTypes.ReserveConfigurationMap memory self, bool enabled)
+    internal
+    pure
+  {
     self.data =
       (self.data & BORROWING_MASK) |
       (uint256(enabled ? 1 : 0) << BORROWING_ENABLED_START_BIT_POSITION);
@@ -194,9 +200,11 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The borrowing state
    **/
-  function getBorrowingEnabled(
-    DataTypes.ReserveConfigurationMap storage self
-  ) internal view returns (bool) {
+  function getBorrowingEnabled(DataTypes.ReserveConfigurationMap storage self)
+    internal
+    view
+    returns (bool)
+  {
     return (self.data & ~BORROWING_MASK) != 0;
   }
 
@@ -219,9 +227,11 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The stable rate borrowing state
    **/
-  function getStableRateBorrowingEnabled(
-    DataTypes.ReserveConfigurationMap storage self
-  ) internal view returns (bool) {
+  function getStableRateBorrowingEnabled(DataTypes.ReserveConfigurationMap storage self)
+    internal
+    view
+    returns (bool)
+  {
     return (self.data & ~STABLE_BORROWING_MASK) != 0;
   }
 
@@ -230,10 +240,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param reserveFactor The reserve factor
    **/
-  function setReserveFactor(
-    DataTypes.ReserveConfigurationMap memory self,
-    uint256 reserveFactor
-  ) internal pure {
+  function setReserveFactor(DataTypes.ReserveConfigurationMap memory self, uint256 reserveFactor)
+    internal
+    pure
+  {
     require(reserveFactor <= MAX_VALID_RESERVE_FACTOR, Errors.RC_INVALID_RESERVE_FACTOR);
 
     self.data =
@@ -246,9 +256,11 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The reserve factor
    **/
-  function getReserveFactor(
-    DataTypes.ReserveConfigurationMap storage self
-  ) internal view returns (uint256) {
+  function getReserveFactor(DataTypes.ReserveConfigurationMap storage self)
+    internal
+    view
+    returns (uint256)
+  {
     return (self.data & ~RESERVE_FACTOR_MASK) >> RESERVE_FACTOR_START_BIT_POSITION;
   }
 
@@ -257,9 +269,16 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The state flags representing active, frozen, borrowing enabled, stableRateBorrowing enabled
    **/
-  function getFlags(
-    DataTypes.ReserveConfigurationMap storage self
-  ) internal view returns (bool, bool, bool, bool) {
+  function getFlags(DataTypes.ReserveConfigurationMap storage self)
+    internal
+    view
+    returns (
+      bool,
+      bool,
+      bool,
+      bool
+    )
+  {
     uint256 dataLocal = self.data;
 
     return (
@@ -275,9 +294,17 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The state params representing ltv, liquidation threshold, liquidation bonus, the reserve decimals
    **/
-  function getParams(
-    DataTypes.ReserveConfigurationMap storage self
-  ) internal view returns (uint256, uint256, uint256, uint256, uint256) {
+  function getParams(DataTypes.ReserveConfigurationMap storage self)
+    internal
+    view
+    returns (
+      uint256,
+      uint256,
+      uint256,
+      uint256,
+      uint256
+    )
+  {
     uint256 dataLocal = self.data;
 
     return (
@@ -294,9 +321,17 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The state params representing ltv, liquidation threshold, liquidation bonus, the reserve decimals
    **/
-  function getParamsMemory(
-    DataTypes.ReserveConfigurationMap memory self
-  ) internal pure returns (uint256, uint256, uint256, uint256, uint256) {
+  function getParamsMemory(DataTypes.ReserveConfigurationMap memory self)
+    internal
+    pure
+    returns (
+      uint256,
+      uint256,
+      uint256,
+      uint256,
+      uint256
+    )
+  {
     return (
       self.data & ~LTV_MASK,
       (self.data & ~LIQUIDATION_THRESHOLD_MASK) >> LIQUIDATION_THRESHOLD_START_BIT_POSITION,
@@ -311,9 +346,16 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The state flags representing active, frozen, borrowing enabled, stableRateBorrowing enabled
    **/
-  function getFlagsMemory(
-    DataTypes.ReserveConfigurationMap memory self
-  ) internal pure returns (bool, bool, bool, bool) {
+  function getFlagsMemory(DataTypes.ReserveConfigurationMap memory self)
+    internal
+    pure
+    returns (
+      bool,
+      bool,
+      bool,
+      bool
+    )
+  {
     return (
       (self.data & ~ACTIVE_MASK) != 0,
       (self.data & ~FROZEN_MASK) != 0,
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/UserConfiguration.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/UserConfiguration.sol
index e957402..2994f05 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/UserConfiguration.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/UserConfiguration.sol
@@ -67,10 +67,11 @@ library UserConfiguration {
    * @param reserveIndex The index of the reserve in the bitmap
    * @return True if the user has been using a reserve for borrowing, false otherwise
    **/
-  function isBorrowing(
-    DataTypes.UserConfigurationMap memory self,
-    uint256 reserveIndex
-  ) internal pure returns (bool) {
+  function isBorrowing(DataTypes.UserConfigurationMap memory self, uint256 reserveIndex)
+    internal
+    pure
+    returns (bool)
+  {
     require(reserveIndex < 128, Errors.UL_INVALID_INDEX);
     return (self.data >> (reserveIndex * 2)) & 1 != 0;
   }
@@ -81,10 +82,11 @@ library UserConfiguration {
    * @param reserveIndex The index of the reserve in the bitmap
    * @return True if the user has been using a reserve as collateral, false otherwise
    **/
-  function isUsingAsCollateral(
-    DataTypes.UserConfigurationMap memory self,
-    uint256 reserveIndex
-  ) internal pure returns (bool) {
+  function isUsingAsCollateral(DataTypes.UserConfigurationMap memory self, uint256 reserveIndex)
+    internal
+    pure
+    returns (bool)
+  {
     require(reserveIndex < 128, Errors.UL_INVALID_INDEX);
     return (self.data >> (reserveIndex * 2 + 1)) & 1 != 0;
   }
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Helpers.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Helpers.sol
index 8e92a56..b0117ef 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Helpers.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Helpers.sol
@@ -15,20 +15,22 @@ library Helpers {
    * @param reserve The reserve data object
    * @return The stable and variable debt balance
    **/
-  function getUserCurrentDebt(
-    address user,
-    DataTypes.ReserveData storage reserve
-  ) internal view returns (uint256, uint256) {
+  function getUserCurrentDebt(address user, DataTypes.ReserveData storage reserve)
+    internal
+    view
+    returns (uint256, uint256)
+  {
     return (
       IERC20(reserve.stableDebtTokenAddress).balanceOf(user),
       IERC20(reserve.variableDebtTokenAddress).balanceOf(user)
     );
   }
 
-  function getUserCurrentDebtMemory(
-    address user,
-    DataTypes.ReserveData memory reserve
-  ) internal view returns (uint256, uint256) {
+  function getUserCurrentDebtMemory(address user, DataTypes.ReserveData memory reserve)
+    internal
+    view
+    returns (uint256, uint256)
+  {
     return (
       IERC20(reserve.stableDebtTokenAddress).balanceOf(user),
       IERC20(reserve.variableDebtTokenAddress).balanceOf(user)
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/GenericLogic.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/GenericLogic.sol
index b93b69b..d4081dd 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/GenericLogic.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/GenericLogic.sol
@@ -89,7 +89,7 @@ library GenericLogic {
     }
 
     vars.amountToDecreaseInETH = IPriceOracleGetter(oracle).getAssetPrice(asset).mul(amount).div(
-      10 ** vars.decimals
+      10**vars.decimals
     );
 
     vars.collateralBalanceAfterDecrease = vars.totalCollateralInETH.sub(vars.amountToDecreaseInETH);
@@ -105,11 +105,12 @@ library GenericLogic {
       .sub(vars.amountToDecreaseInETH.mul(vars.liquidationThreshold))
       .div(vars.collateralBalanceAfterDecrease);
 
-    uint256 healthFactorAfterDecrease = calculateHealthFactorFromBalances(
-      vars.collateralBalanceAfterDecrease,
-      vars.totalDebtInETH,
-      vars.liquidationThresholdAfterDecrease
-    );
+    uint256 healthFactorAfterDecrease =
+      calculateHealthFactorFromBalances(
+        vars.collateralBalanceAfterDecrease,
+        vars.totalDebtInETH,
+        vars.liquidationThresholdAfterDecrease
+      );
 
     return healthFactorAfterDecrease >= GenericLogic.HEALTH_FACTOR_LIQUIDATION_THRESHOLD;
   }
@@ -153,7 +154,17 @@ library GenericLogic {
     mapping(uint256 => address) storage reserves,
     uint256 reservesCount,
     address oracle
-  ) internal view returns (uint256, uint256, uint256, uint256, uint256) {
+  )
+    internal
+    view
+    returns (
+      uint256,
+      uint256,
+      uint256,
+      uint256,
+      uint256
+    )
+  {
     CalculateUserAccountDataVars memory vars;
 
     if (userConfig.isEmpty()) {
@@ -171,16 +182,14 @@ library GenericLogic {
         .configuration
         .getParams();
 
-      vars.tokenUnit = 10 ** vars.decimals;
+      vars.tokenUnit = 10**vars.decimals;
       vars.reserveUnitPrice = IPriceOracleGetter(oracle).getAssetPrice(vars.currentReserveAddress);
 
       if (vars.liquidationThreshold != 0 && userConfig.isUsingAsCollateral(vars.i)) {
         vars.compoundedLiquidityBalance = IERC20(currentReserve.aTokenAddress).balanceOf(user);
 
-        uint256 liquidityBalanceETH = vars
-          .reserveUnitPrice
-          .mul(vars.compoundedLiquidityBalance)
-          .div(vars.tokenUnit);
+        uint256 liquidityBalanceETH =
+          vars.reserveUnitPrice.mul(vars.compoundedLiquidityBalance).div(vars.tokenUnit);
 
         vars.totalCollateralInETH = vars.totalCollateralInETH.add(liquidityBalanceETH);
 
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ReserveLogic.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ReserveLogic.sol
index cba1961..2b5b2cf 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ReserveLogic.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ReserveLogic.sol
@@ -54,9 +54,11 @@ library ReserveLogic {
    * @param reserve The reserve object
    * @return the normalized income. expressed in ray
    **/
-  function getNormalizedIncome(
-    DataTypes.ReserveData storage reserve
-  ) internal view returns (uint256) {
+  function getNormalizedIncome(DataTypes.ReserveData storage reserve)
+    internal
+    view
+    returns (uint256)
+  {
     uint40 timestamp = reserve.lastUpdateTimestamp;
 
     //solium-disable-next-line
@@ -65,9 +67,10 @@ library ReserveLogic {
       return reserve.liquidityIndex;
     }
 
-    uint256 cumulated = MathUtils
-      .calculateLinearInterest(reserve.currentLiquidityRate, timestamp)
-      .rayMul(reserve.liquidityIndex);
+    uint256 cumulated =
+      MathUtils.calculateLinearInterest(reserve.currentLiquidityRate, timestamp).rayMul(
+        reserve.liquidityIndex
+      );
 
     return cumulated;
   }
@@ -79,9 +82,11 @@ library ReserveLogic {
    * @param reserve The reserve object
    * @return The normalized variable debt. expressed in ray
    **/
-  function getNormalizedDebt(
-    DataTypes.ReserveData storage reserve
-  ) internal view returns (uint256) {
+  function getNormalizedDebt(DataTypes.ReserveData storage reserve)
+    internal
+    view
+    returns (uint256)
+  {
     uint40 timestamp = reserve.lastUpdateTimestamp;
 
     //solium-disable-next-line
@@ -90,9 +95,10 @@ library ReserveLogic {
       return reserve.variableBorrowIndex;
     }
 
-    uint256 cumulated = MathUtils
-      .calculateCompoundedInterest(reserve.currentVariableBorrowRate, timestamp)
-      .rayMul(reserve.variableBorrowIndex);
+    uint256 cumulated =
+      MathUtils.calculateCompoundedInterest(reserve.currentVariableBorrowRate, timestamp).rayMul(
+        reserve.variableBorrowIndex
+      );
 
     return cumulated;
   }
@@ -102,19 +108,20 @@ library ReserveLogic {
    * @param reserve the reserve object
    **/
   function updateState(DataTypes.ReserveData storage reserve) internal {
-    uint256 scaledVariableDebt = IVariableDebtToken(reserve.variableDebtTokenAddress)
-      .scaledTotalSupply();
+    uint256 scaledVariableDebt =
+      IVariableDebtToken(reserve.variableDebtTokenAddress).scaledTotalSupply();
     uint256 previousVariableBorrowIndex = reserve.variableBorrowIndex;
     uint256 previousLiquidityIndex = reserve.liquidityIndex;
     uint40 lastUpdatedTimestamp = reserve.lastUpdateTimestamp;
 
-    (uint256 newLiquidityIndex, uint256 newVariableBorrowIndex) = _updateIndexes(
-      reserve,
-      scaledVariableDebt,
-      previousLiquidityIndex,
-      previousVariableBorrowIndex,
-      lastUpdatedTimestamp
-    );
+    (uint256 newLiquidityIndex, uint256 newVariableBorrowIndex) =
+      _updateIndexes(
+        reserve,
+        scaledVariableDebt,
+        previousLiquidityIndex,
+        previousVariableBorrowIndex,
+        lastUpdatedTimestamp
+      );
 
     _mintToTreasury(
       reserve,
@@ -338,10 +345,8 @@ library ReserveLogic {
 
     //only cumulating if there is any income being produced
     if (currentLiquidityRate > 0) {
-      uint256 cumulatedLiquidityInterest = MathUtils.calculateLinearInterest(
-        currentLiquidityRate,
-        timestamp
-      );
+      uint256 cumulatedLiquidityInterest =
+        MathUtils.calculateLinearInterest(currentLiquidityRate, timestamp);
       newLiquidityIndex = cumulatedLiquidityInterest.rayMul(liquidityIndex);
       require(newLiquidityIndex <= type(uint128).max, Errors.RL_LIQUIDITY_INDEX_OVERFLOW);
 
@@ -350,10 +355,8 @@ library ReserveLogic {
       //as the liquidity rate might come only from stable rate loans, we need to ensure
       //that there is actual variable debt before accumulating
       if (scaledVariableDebt != 0) {
-        uint256 cumulatedVariableBorrowInterest = MathUtils.calculateCompoundedInterest(
-          reserve.currentVariableBorrowRate,
-          timestamp
-        );
+        uint256 cumulatedVariableBorrowInterest =
+          MathUtils.calculateCompoundedInterest(reserve.currentVariableBorrowRate, timestamp);
         newVariableBorrowIndex = cumulatedVariableBorrowInterest.rayMul(variableBorrowIndex);
         require(
           newVariableBorrowIndex <= type(uint128).max,
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ValidationLogic.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ValidationLogic.sol
index 010c970..080b792 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ValidationLogic.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ValidationLogic.sol
@@ -312,10 +312,8 @@ library ValidationLogic {
     require(isActive, Errors.VL_NO_ACTIVE_RESERVE);
 
     //if the usage ratio is below 95%, no rebalances are needed
-    uint256 totalDebt = stableDebtToken
-      .totalSupply()
-      .add(variableDebtToken.totalSupply())
-      .wadToRay();
+    uint256 totalDebt =
+      stableDebtToken.totalSupply().add(variableDebtToken.totalSupply()).wadToRay();
     uint256 availableLiquidity = IERC20(reserveAddress).balanceOf(aTokenAddress).wadToRay();
     uint256 usageRatio = totalDebt == 0 ? 0 : totalDebt.rayDiv(availableLiquidity.add(totalDebt));
 
@@ -323,9 +321,8 @@ library ValidationLogic {
     //then we allow rebalancing of the stable rate positions.
 
     uint256 currentLiquidityRate = reserve.currentLiquidityRate;
-    uint256 maxVariableBorrowRate = IReserveInterestRateStrategy(
-      reserve.interestRateStrategyAddress
-    ).getMaxVariableBorrowRate();
+    uint256 maxVariableBorrowRate =
+      IReserveInterestRateStrategy(reserve.interestRateStrategyAddress).getMaxVariableBorrowRate();
 
     require(
       usageRatio >= REBALANCE_UP_USAGE_RATIO_THRESHOLD &&
@@ -416,8 +413,9 @@ library ValidationLogic {
       );
     }
 
-    bool isCollateralEnabled = collateralReserve.configuration.getLiquidationThreshold() > 0 &&
-      userConfig.isUsingAsCollateral(collateralReserve.id);
+    bool isCollateralEnabled =
+      collateralReserve.configuration.getLiquidationThreshold() > 0 &&
+        userConfig.isUsingAsCollateral(collateralReserve.id);
 
     //if collateral isn't enabled as collateral by user, it cannot be liquidated
     if (!isCollateralEnabled) {
@@ -453,14 +451,15 @@ library ValidationLogic {
     uint256 reservesCount,
     address oracle
   ) internal view {
-    (, , , , uint256 healthFactor) = GenericLogic.calculateUserAccountData(
-      from,
-      reservesData,
-      userConfig,
-      reserves,
-      reservesCount,
-      oracle
-    );
+    (, , , , uint256 healthFactor) =
+      GenericLogic.calculateUserAccountData(
+        from,
+        reservesData,
+        userConfig,
+        reserves,
+        reservesCount,
+        oracle
+      );
 
     require(
       healthFactor >= GenericLogic.HEALTH_FACTOR_LIQUIDATION_THRESHOLD,
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/math/MathUtils.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/math/MathUtils.sol
index 18d42a5..7078a82 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/math/MathUtils.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/math/MathUtils.sol
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
diff --git a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/types/DataTypes.sol b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/types/DataTypes.sol
index 25ef764..a19e5ef 100644
--- a/etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/types/DataTypes.sol
+++ b/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/types/DataTypes.sol
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
```
