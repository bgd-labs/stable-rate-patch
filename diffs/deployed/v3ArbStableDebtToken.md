```diff
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/Context.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/Context.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/Context.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/Context.sol
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
similarity index 91%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
index 6303454..a67ea68 100644
--- a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
+++ b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
-
+pragma solidity ^0.8.10;
 import {IERC20} from './IERC20.sol';
 
 interface IERC20Detailed is IERC20 {
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/SafeCast.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/SafeCast.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/SafeCast.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/SafeCast.sol
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IACLManager.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IACLManager.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IACLManager.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IACLManager.sol
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IAaveIncentivesController.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IAaveIncentivesController.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IAaveIncentivesController.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IAaveIncentivesController.sol
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/ICreditDelegationToken.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/ICreditDelegationToken.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/ICreditDelegationToken.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/ICreditDelegationToken.sol
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IInitializableDebtToken.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IInitializableDebtToken.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IInitializableDebtToken.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IInitializableDebtToken.sol
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IPool.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IPool.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IPool.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IPool.sol
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IStableDebtToken.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IStableDebtToken.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IStableDebtToken.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IStableDebtToken.sol
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/helpers/Errors.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/helpers/Errors.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/helpers/Errors.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/helpers/Errors.sol
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/math/MathUtils.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/math/MathUtils.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/math/MathUtils.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/math/MathUtils.sol
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/math/WadRayMath.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/math/WadRayMath.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/math/WadRayMath.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/math/WadRayMath.sol
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/types/DataTypes.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/types/DataTypes.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/types/DataTypes.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/libraries/types/DataTypes.sol
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol
similarity index 85%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol
index eac46ce..f507721 100644
--- a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol
+++ b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol
@@ -26,7 +26,7 @@ contract StableDebtToken is DebtTokenBase, IncentivizedERC20, IStableDebtToken {
   using WadRayMath for uint256;
   using SafeCast for uint256;
 
-  uint256 public constant DEBT_TOKEN_REVISION = 0x2;
+  uint256 public constant DEBT_TOKEN_REVISION = 0x3;
 
   // Map of users address and the timestamp of their last update (userAddress => lastUpdateTimestamp)
   mapping(address => uint40) internal _timestamps;
@@ -111,67 +111,17 @@ contract StableDebtToken is DebtTokenBase, IncentivizedERC20, IStableDebtToken {
     return accountBalance.rayMul(cumulatedInterest);
   }
 
-  struct MintLocalVars {
-    uint256 previousSupply;
-    uint256 nextSupply;
-    uint256 amountInRay;
-    uint256 currentStableRate;
-    uint256 nextStableRate;
-    uint256 currentAvgStableRate;
-  }
-
   /// @inheritdoc IStableDebtToken
+  /**
+   * @dev DEPRECATED, no stable debt should be minted in any operation
+   **/
   function mint(
-    address user,
-    address onBehalfOf,
-    uint256 amount,
-    uint256 rate
+    address,
+    address,
+    uint256,
+    uint256
   ) external virtual override onlyPool returns (bool, uint256, uint256) {
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
-    vars.nextSupply = _totalSupply = vars.previousSupply + amount;
-
-    vars.amountInRay = amount.wadToRay();
-
-    vars.currentStableRate = _userState[onBehalfOf].additionalData;
-    vars.nextStableRate = (vars.currentStableRate.rayMul(currentBalance.wadToRay()) +
-      vars.amountInRay.rayMul(rate)).rayDiv((currentBalance + amount).wadToRay());
-
-    _userState[onBehalfOf].additionalData = vars.nextStableRate.toUint128();
-
-    //solium-disable-next-line
-    _totalSupplyTimestamp = _timestamps[onBehalfOf] = uint40(block.timestamp);
-
-    // Calculates the updated average stable rate
-    vars.currentAvgStableRate = _avgStableRate = (
-      (vars.currentAvgStableRate.rayMul(vars.previousSupply.wadToRay()) +
-        rate.rayMul(vars.amountInRay)).rayDiv(vars.nextSupply.wadToRay())
-    ).toUint128();
-
-    uint256 amountToMint = amount + balanceIncrease;
-    _mint(onBehalfOf, amountToMint, vars.previousSupply);
-
-    emit Transfer(address(0), onBehalfOf, amountToMint);
-    emit Mint(
-      user,
-      onBehalfOf,
-      amountToMint,
-      currentBalance,
-      balanceIncrease,
-      vars.nextStableRate,
-      vars.currentAvgStableRate,
-      vars.nextSupply
-    );
-
-    return (currentBalance == 0, vars.nextSupply, vars.currentAvgStableRate);
+    revert('STABLE_BORROWING_DEPRECATED');
   }
 
   /// @inheritdoc IStableDebtToken
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/base/DebtTokenBase.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/base/DebtTokenBase.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/base/DebtTokenBase.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/base/DebtTokenBase.sol
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/base/EIP712Base.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/base/EIP712Base.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/base/EIP712Base.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/base/EIP712Base.sol
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/base/IncentivizedERC20.sol b/etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/base/IncentivizedERC20.sol
similarity index 100%
rename from etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/base/IncentivizedERC20.sol
rename to etherscan/deployed/v3ArbStableDebtToken/StableDebtToken/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/base/IncentivizedERC20.sol
```
