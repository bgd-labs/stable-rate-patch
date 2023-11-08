```diff
diff --git a/etherscan/v2AmmEthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol b/src/v2AmmEthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol
index 49451d9..02c3dac 100644
--- a/etherscan/v2AmmEthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol
+++ b/src/v2AmmEthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol
@@ -46,7 +46,15 @@ contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigur
     _;
   }
 
-  uint256 internal constant CONFIGURATOR_REVISION = 0x1;
+  modifier onlyPoolOrEmergencyAdmin() {
+    require(
+      addressesProvider.getPoolAdmin() == msg.sender || addressesProvider.getEmergencyAdmin() == msg.sender,
+      Errors.CALLER_NOT_POOL_OR_EMERGENCY_ADMIN
+    );
+    _;
+  }
+
+  uint256 internal constant CONFIGURATOR_REVISION = 0x2;
 
   function getRevision() internal pure override returns (uint256) {
     return CONFIGURATOR_REVISION;
@@ -391,7 +399,7 @@ contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigur
    *  but allows repayments, liquidations, rate rebalances and withdrawals
    * @param asset The address of the underlying asset of the reserve
    **/
-  function freezeReserve(address asset) external onlyPoolAdmin {
+  function freezeReserve(address asset) external onlyPoolOrEmergencyAdmin {
     DataTypes.ReserveConfigurationMap memory currentConfig = pool.getConfiguration(asset);
 
     currentConfig.setFrozen(true);
@@ -405,7 +413,7 @@ contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigur
    * @dev Unfreezes a reserve
    * @param asset The address of the underlying asset of the reserve
    **/
-  function unfreezeReserve(address asset) external onlyPoolAdmin {
+  function unfreezeReserve(address asset) external onlyPoolOrEmergencyAdmin {
     DataTypes.ReserveConfigurationMap memory currentConfig = pool.getConfiguration(asset);
 
     currentConfig.setFrozen(false);
diff --git a/etherscan/v2AmmEthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/libraries/helpers/Errors.sol b/src/v2AmmEthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/libraries/helpers/Errors.sol
index 8756d79..0d9d2b5 100644
--- a/etherscan/v2AmmEthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/libraries/helpers/Errors.sol
+++ b/src/v2AmmEthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/libraries/helpers/Errors.sol
@@ -103,6 +103,7 @@ library Errors {
   string public constant LP_NOT_CONTRACT = '78';
   string public constant SDT_STABLE_DEBT_OVERFLOW = '79';
   string public constant SDT_BURN_EXCEEDS_BALANCE = '80';
+  string public constant CALLER_NOT_POOL_OR_EMERGENCY_ADMIN = '81'; // 'The caller must be the emergency or pool admin'
 
   enum CollateralManagerErrors {
     NO_ERROR,
```
