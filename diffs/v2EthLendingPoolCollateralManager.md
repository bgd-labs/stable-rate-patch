```diff
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/IERC20.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/IERC20.sol
index 3096454..3d69bff 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/IERC20.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/IERC20.sol
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
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeERC20.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeERC20.sol
index 48c7e18..0a27559 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeERC20.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeERC20.sol
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
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeMath.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeMath.sol
index 5c68ca1..80f7d67 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeMath.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeMath.sol
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
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAToken.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAToken.sol
index 8ae0780..5fa1a4f 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAToken.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAToken.sol
@@ -20,7 +20,11 @@ interface IAToken is IERC20, IScaledBalanceToken {
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
@@ -47,7 +51,12 @@ interface IAToken is IERC20, IScaledBalanceToken {
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
@@ -62,7 +71,11 @@ interface IAToken is IERC20, IScaledBalanceToken {
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
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IReserveInterestRateStrategy.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IReserveInterestRateStrategy.sol
index 2409bfd..430145e 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IReserveInterestRateStrategy.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IReserveInterestRateStrategy.sol
@@ -21,5 +21,9 @@ interface IReserveInterestRateStrategy {
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
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IStableDebtToken.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IStableDebtToken.sol
index b68cddf..c24750b 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IStableDebtToken.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IStableDebtToken.sol
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
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IVariableDebtToken.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IVariableDebtToken.sol
index 8c1be62..6a0c155 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IVariableDebtToken.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IVariableDebtToken.sol
@@ -47,5 +47,9 @@ interface IVariableDebtToken is IScaledBalanceToken {
    * @param user The user which debt is burnt
    * @param index The variable debt index of the reserve
    **/
-  function burn(address user, uint256 amount, uint256 index) external;
+  function burn(
+    address user,
+    uint256 amount,
+    uint256 index
+  ) external;
 }
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol
index ab08244..8069272 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol
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
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
index b8e356a..f2b73b8 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
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
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/ReserveConfiguration.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
index 3e853a9..60076a6 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
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
 
@@ -88,10 +90,7 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param bonus The new liquidation bonus
    **/
-  function setLiquidationBonus(
-    DataTypes.ReserveConfigurationMap memory self,
-    uint256 bonus
-  ) internal pure {
+  function setLiquidationBonus(DataTypes.ReserveConfigurationMap memory self, uint256 bonus) internal pure {
     require(bonus <= MAX_VALID_LIQUIDATION_BONUS, Errors.RC_INVALID_LIQ_BONUS);
 
     self.data =
@@ -104,9 +103,11 @@ library ReserveConfiguration {
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
 
@@ -115,10 +116,7 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param decimals The decimals
    **/
-  function setDecimals(
-    DataTypes.ReserveConfigurationMap memory self,
-    uint256 decimals
-  ) internal pure {
+  function setDecimals(DataTypes.ReserveConfigurationMap memory self, uint256 decimals) internal pure {
     require(decimals <= MAX_VALID_DECIMALS, Errors.RC_INVALID_DECIMALS);
 
     self.data = (self.data & DECIMALS_MASK) | (decimals << RESERVE_DECIMALS_START_BIT_POSITION);
@@ -129,9 +127,7 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The decimals of the asset
    **/
-  function getDecimals(
-    DataTypes.ReserveConfigurationMap storage self
-  ) internal view returns (uint256) {
+  function getDecimals(DataTypes.ReserveConfigurationMap storage self) internal view returns (uint256) {
     return (self.data & ~DECIMALS_MASK) >> RESERVE_DECIMALS_START_BIT_POSITION;
   }
 
@@ -180,10 +176,7 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param enabled True if the borrowing needs to be enabled, false otherwise
    **/
-  function setBorrowingEnabled(
-    DataTypes.ReserveConfigurationMap memory self,
-    bool enabled
-  ) internal pure {
+  function setBorrowingEnabled(DataTypes.ReserveConfigurationMap memory self, bool enabled) internal pure {
     self.data =
       (self.data & BORROWING_MASK) |
       (uint256(enabled ? 1 : 0) << BORROWING_ENABLED_START_BIT_POSITION);
@@ -194,9 +187,7 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The borrowing state
    **/
-  function getBorrowingEnabled(
-    DataTypes.ReserveConfigurationMap storage self
-  ) internal view returns (bool) {
+  function getBorrowingEnabled(DataTypes.ReserveConfigurationMap storage self) internal view returns (bool) {
     return (self.data & ~BORROWING_MASK) != 0;
   }
 
@@ -205,10 +196,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param enabled True if the stable rate borrowing needs to be enabled, false otherwise
    **/
-  function setStableRateBorrowingEnabled(
-    DataTypes.ReserveConfigurationMap memory self,
-    bool enabled
-  ) internal pure {
+  function setStableRateBorrowingEnabled(DataTypes.ReserveConfigurationMap memory self, bool enabled)
+    internal
+    pure
+  {
     self.data =
       (self.data & STABLE_BORROWING_MASK) |
       (uint256(enabled ? 1 : 0) << STABLE_BORROWING_ENABLED_START_BIT_POSITION);
@@ -219,9 +210,11 @@ library ReserveConfiguration {
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
 
@@ -230,10 +223,10 @@ library ReserveConfiguration {
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
@@ -246,9 +239,7 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The reserve factor
    **/
-  function getReserveFactor(
-    DataTypes.ReserveConfigurationMap storage self
-  ) internal view returns (uint256) {
+  function getReserveFactor(DataTypes.ReserveConfigurationMap storage self) internal view returns (uint256) {
     return (self.data & ~RESERVE_FACTOR_MASK) >> RESERVE_FACTOR_START_BIT_POSITION;
   }
 
@@ -257,9 +248,16 @@ library ReserveConfiguration {
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
@@ -275,9 +273,17 @@ library ReserveConfiguration {
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
@@ -294,9 +300,17 @@ library ReserveConfiguration {
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
@@ -311,9 +325,16 @@ library ReserveConfiguration {
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
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/UserConfiguration.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/UserConfiguration.sol
index e957402..b56f614 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/UserConfiguration.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/UserConfiguration.sol
@@ -53,10 +53,11 @@ library UserConfiguration {
    * @param reserveIndex The index of the reserve in the bitmap
    * @return True if the user has been using a reserve for borrowing or as collateral, false otherwise
    **/
-  function isUsingAsCollateralOrBorrowing(
-    DataTypes.UserConfigurationMap memory self,
-    uint256 reserveIndex
-  ) internal pure returns (bool) {
+  function isUsingAsCollateralOrBorrowing(DataTypes.UserConfigurationMap memory self, uint256 reserveIndex)
+    internal
+    pure
+    returns (bool)
+  {
     require(reserveIndex < 128, Errors.UL_INVALID_INDEX);
     return (self.data >> (reserveIndex * 2)) & 3 != 0;
   }
@@ -67,10 +68,11 @@ library UserConfiguration {
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
@@ -81,10 +83,11 @@ library UserConfiguration {
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
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Helpers.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Helpers.sol
index 8e92a56..b0117ef 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Helpers.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Helpers.sol
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
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/GenericLogic.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/GenericLogic.sol
index b93b69b..e921ec5 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/GenericLogic.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/GenericLogic.sol
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
 
@@ -204,7 +213,9 @@ library GenericLogic {
       }
     }
 
-    vars.avgLtv = vars.totalCollateralInETH > 0 ? vars.avgLtv.div(vars.totalCollateralInETH) : 0;
+    vars.avgLtv = vars.totalCollateralInETH > 0
+      ? vars.avgLtv.div(vars.totalCollateralInETH)
+      : 0;
     vars.avgLiquidationThreshold = vars.totalCollateralInETH > 0
       ? vars.avgLiquidationThreshold.div(vars.totalCollateralInETH)
       : 0;
@@ -254,6 +265,7 @@ library GenericLogic {
     uint256 totalDebtInETH,
     uint256 ltv
   ) internal pure returns (uint256) {
+    
     uint256 availableBorrowsETH = totalCollateralInETH.percentMul(ltv); 
 
     if (availableBorrowsETH < totalDebtInETH) {
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ReserveLogic.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ReserveLogic.sol
index 70669bd..3b0884c 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ReserveLogic.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ReserveLogic.sol
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
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ValidationLogic.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ValidationLogic.sol
index 09a0f51..d08e705 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ValidationLogic.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ValidationLogic.sol
@@ -319,10 +319,8 @@ library ValidationLogic {
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
 
@@ -330,9 +328,8 @@ library ValidationLogic {
     //then we allow rebalancing of the stable rate positions.
 
     uint256 currentLiquidityRate = reserve.currentLiquidityRate;
-    uint256 maxVariableBorrowRate = IReserveInterestRateStrategy(
-      reserve.interestRateStrategyAddress
-    ).getMaxVariableBorrowRate();
+    uint256 maxVariableBorrowRate =
+      IReserveInterestRateStrategy(reserve.interestRateStrategyAddress).getMaxVariableBorrowRate();
 
     require(
       usageRatio >= REBALANCE_UP_USAGE_RATIO_THRESHOLD &&
@@ -423,8 +420,9 @@ library ValidationLogic {
       );
     }
 
-    bool isCollateralEnabled = collateralReserve.configuration.getLiquidationThreshold() > 0 &&
-      userConfig.isUsingAsCollateral(collateralReserve.id);
+    bool isCollateralEnabled =
+      collateralReserve.configuration.getLiquidationThreshold() > 0 &&
+        userConfig.isUsingAsCollateral(collateralReserve.id);
 
     //if collateral isn't enabled as collateral by user, it cannot be liquidated
     if (!isCollateralEnabled) {
@@ -460,14 +458,15 @@ library ValidationLogic {
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
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/math/MathUtils.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/math/MathUtils.sol
index 18d42a5..7078a82 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/math/MathUtils.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/math/MathUtils.sol
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
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/types/DataTypes.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/types/DataTypes.sol
index 25ef764..a19e5ef 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/types/DataTypes.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/types/DataTypes.sol
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
