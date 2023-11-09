```diff
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
diff --git a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol b/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol
index 7840140..3283510 100644
--- a/etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol
+++ b/src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol
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
```
