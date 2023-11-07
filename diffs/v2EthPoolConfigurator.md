```diff
diff --git a/etherscan/v2EthPoolConfigurator/flattened/PoolConfigurator.sol b/src/v2EthPoolConfigurator/flattened/PoolConfigurator.sol
index 13bfc8d..0bcf7bd 100644
--- a/etherscan/v2EthPoolConfigurator/flattened/PoolConfigurator.sol
+++ b/src/v2EthPoolConfigurator/flattened/PoolConfigurator.sol
@@ -648,6 +648,7 @@ library Errors {
   string public constant LP_NOT_CONTRACT = '78';
   string public constant SDT_STABLE_DEBT_OVERFLOW = '79';
   string public constant SDT_BURN_EXCEEDS_BALANCE = '80';
+  string public constant CALLER_NOT_POOL_OR_EMERGENCY_ADMIN = '81'; // 'The caller must be the emergency or pool admin'
 
   enum CollateralManagerErrors {
     NO_ERROR,
@@ -1823,7 +1824,15 @@ contract LendingPoolConfigurator is VersionedInitializable {
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
@@ -2093,7 +2102,7 @@ contract LendingPoolConfigurator is VersionedInitializable {
    *  but allows repayments, liquidations, rate rebalances and withdrawals
    * @param asset The address of the underlying asset of the reserve
    **/
-  function freezeReserve(address asset) external onlyPoolAdmin {
+  function freezeReserve(address asset) external onlyPoolOrEmergencyAdmin {
     DataTypes.ReserveConfigurationMap memory currentConfig = pool.getConfiguration(asset);
 
     currentConfig.setFrozen(true);
@@ -2107,7 +2116,7 @@ contract LendingPoolConfigurator is VersionedInitializable {
    * @dev Unfreezes a reserve
    * @param asset The address of the underlying asset of the reserve
    **/
-  function unfreezeReserve(address asset) external onlyPoolAdmin {
+  function unfreezeReserve(address asset) external onlyPoolOrEmergencyAdmin {
     DataTypes.ReserveConfigurationMap memory currentConfig = pool.getConfiguration(asset);
 
     currentConfig.setFrozen(false);
```
