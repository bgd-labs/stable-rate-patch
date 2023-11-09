```diff
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/ILendingPoolCollateralManager.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/ILendingPoolCollateralManager.sol
index ed70ea0..5792efb 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/ILendingPoolCollateralManager.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/ILendingPoolCollateralManager.sol
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: agpl-3.0
 pragma solidity 0.6.12;
+import {ILiquidationsGraceSentinel} from '../../../../ILiquidationsGraceSentinel.sol';
 
 /**
  * @title ILendingPoolCollateralManager
@@ -57,4 +58,10 @@ interface ILendingPoolCollateralManager {
     uint256 debtToCover,
     bool receiveAToken
   ) external returns (uint256, string memory);
+
+  /**
+   * @dev Function to get an address LiquidationsGraceSentinel
+   * @return ILiquidationsGraceSentinel
+  **/
+  function LIQUIDATIONS_GRACE_SENTINEL() external view returns(ILiquidationsGraceSentinel);
 }
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol
index 8069272..7c4c9d0 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol
@@ -7,7 +7,7 @@ import {IAToken} from '../../interfaces/IAToken.sol';
 import {IStableDebtToken} from '../../interfaces/IStableDebtToken.sol';
 import {IVariableDebtToken} from '../../interfaces/IVariableDebtToken.sol';
 import {IPriceOracleGetter} from '../../interfaces/IPriceOracleGetter.sol';
-import {ILendingPoolCollateralManager} from '../../interfaces/ILendingPoolCollateralManager.sol';
+import {ILendingPoolCollateralManager, ILiquidationsGraceSentinel} from '../../interfaces/ILendingPoolCollateralManager.sol';
 import {VersionedInitializable} from '../libraries/aave-upgradeability/VersionedInitializable.sol';
 import {GenericLogic} from '../libraries/logic/GenericLogic.sol';
 import {Helpers} from '../libraries/helpers/Helpers.sol';
@@ -37,6 +37,7 @@ contract LendingPoolCollateralManager is
   using PercentageMath for uint256;
 
   uint256 internal constant LIQUIDATION_CLOSE_FACTOR_PERCENT = 5000;
+  ILiquidationsGraceSentinel public immutable override LIQUIDATIONS_GRACE_SENTINEL;
 
   struct LiquidationCallLocalVars {
     uint256 userCollateralBalance;
@@ -58,6 +59,10 @@ contract LendingPoolCollateralManager is
     string errorMsg;
   }
 
+  constructor(address liquidationsGraceRegistry) public {
+    LIQUIDATIONS_GRACE_SENTINEL = ILiquidationsGraceSentinel(liquidationsGraceRegistry);
+  }
+
   /**
    * @dev As thIS contract extends the VersionedInitializable contract to match the state
    * of the LendingPool contract, the getRevision() function is needed, but the value is not
@@ -91,6 +96,16 @@ contract LendingPoolCollateralManager is
 
     LiquidationCallLocalVars memory vars;
 
+    if (
+      address(LIQUIDATIONS_GRACE_SENTINEL) != address(0) &&
+      (
+        LIQUIDATIONS_GRACE_SENTINEL.gracePeriodUntil(collateralAsset) >= uint40(block.timestamp) ||
+        LIQUIDATIONS_GRACE_SENTINEL.gracePeriodUntil(debtAsset) >= uint40(block.timestamp)
+      )
+    ) {
+      return (uint256(Errors.CollateralManagerErrors.ON_GRACE_PERIOD), Errors.LPCM_ON_GRACE_PERIOD);
+    }
+
     (, , , , vars.healthFactor) = GenericLogic.calculateUserAccountData(
       user,
       _reserves,
diff --git a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Errors.sol b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Errors.sol
index 8756d79..87d2033 100644
--- a/etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Errors.sol
+++ b/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Errors.sol
@@ -103,6 +103,7 @@ library Errors {
   string public constant LP_NOT_CONTRACT = '78';
   string public constant SDT_STABLE_DEBT_OVERFLOW = '79';
   string public constant SDT_BURN_EXCEEDS_BALANCE = '80';
+  string public constant LPCM_ON_GRACE_PERIOD = '82';
 
   enum CollateralManagerErrors {
     NO_ERROR,
@@ -114,6 +115,7 @@ library Errors {
     NO_ACTIVE_RESERVE,
     HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD,
     INVALID_EQUAL_ASSETS_TO_SWAP,
-    FROZEN_RESERVE
+    FROZEN_RESERVE,
+    ON_GRACE_PERIOD
   }
 }
```
