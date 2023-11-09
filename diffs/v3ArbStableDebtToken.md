```diff
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol b/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
index 6303454..a67ea68 100644
--- a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
+++ b/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
-
+pragma solidity ^0.8.10;
 import {IERC20} from './IERC20.sol';
 
 interface IERC20Detailed is IERC20 {
diff --git a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol b/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol
index eac46ce..f507721 100644
--- a/etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol
+++ b/src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol
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
```
