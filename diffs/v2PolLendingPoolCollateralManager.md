```diff
diff --git a/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/@openzeppelin/contracts/token/ERC20/IERC20.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/@openzeppelin/contracts/token/ERC20/IERC20.sol
new file mode 100644
index 0000000..a1f9ca7
--- /dev/null
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/@openzeppelin/contracts/token/ERC20/IERC20.sol
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: MIT
+
+pragma solidity ^0.6.0;
+
+/**
+ * @dev Interface of the ERC20 standard as defined in the EIP.
+ */
+interface IERC20 {
+    /**
+     * @dev Returns the amount of tokens in existence.
+     */
+    function totalSupply() external view returns (uint256);
+
+    /**
+     * @dev Returns the amount of tokens owned by `account`.
+     */
+    function balanceOf(address account) external view returns (uint256);
+
+    /**
+     * @dev Moves `amount` tokens from the caller's account to `recipient`.
+     *
+     * Returns a boolean value indicating whether the operation succeeded.
+     *
+     * Emits a {Transfer} event.
+     */
+    function transfer(address recipient, uint256 amount) external returns (bool);
+
+    /**
+     * @dev Returns the remaining number of tokens that `spender` will be
+     * allowed to spend on behalf of `owner` through {transferFrom}. This is
+     * zero by default.
+     *
+     * This value changes when {approve} or {transferFrom} are called.
+     */
+    function allowance(address owner, address spender) external view returns (uint256);
+
+    /**
+     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
+     *
+     * Returns a boolean value indicating whether the operation succeeded.
+     *
+     * IMPORTANT: Beware that changing an allowance with this method brings the risk
+     * that someone may use both the old and the new allowance by unfortunate
+     * transaction ordering. One possible solution to mitigate this race
+     * condition is to first reduce the spender's allowance to 0 and set the
+     * desired value afterwards:
+     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
+     *
+     * Emits an {Approval} event.
+     */
+    function approve(address spender, uint256 amount) external returns (bool);
+
+    /**
+     * @dev Moves `amount` tokens from `sender` to `recipient` using the
+     * allowance mechanism. `amount` is then deducted from the caller's
+     * allowance.
+     *
+     * Returns a boolean value indicating whether the operation succeeded.
+     *
+     * Emits a {Transfer} event.
+     */
+    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
+
+    /**
+     * @dev Emitted when `value` tokens are moved from one account (`from`) to
+     * another (`to`).
+     *
+     * Note that `value` may be zero.
+     */
+    event Transfer(address indexed from, address indexed to, uint256 value);
+
+    /**
+     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
+     * a call to {approve}. `value` is the new allowance.
+     */
+    event Approval(address indexed owner, address indexed spender, uint256 value);
+}
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/adapters/BaseUniswapAdapter.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/adapters/BaseUniswapAdapter.sol
index 5921238..5a866db 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/adapters/BaseUniswapAdapter.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/adapters/BaseUniswapAdapter.sol
@@ -61,7 +61,18 @@ abstract contract BaseUniswapAdapter is FlashLoanReceiverBase, IBaseUniswapAdapt
     uint256 amountIn,
     address reserveIn,
     address reserveOut
-  ) external view override returns (uint256, uint256, uint256, uint256, address[] memory) {
+  )
+    external
+    view
+    override
+    returns (
+      uint256,
+      uint256,
+      uint256,
+      uint256,
+      address[] memory
+    )
+  {
     AmountCalc memory results = _getAmountsOutData(reserveIn, reserveOut, amountIn);
 
     return (
@@ -87,7 +98,18 @@ abstract contract BaseUniswapAdapter is FlashLoanReceiverBase, IBaseUniswapAdapt
     uint256 amountOut,
     address reserveIn,
     address reserveOut
-  ) external view override returns (uint256, uint256, uint256, uint256, address[] memory) {
+  )
+    external
+    view
+    override
+    returns (
+      uint256,
+      uint256,
+      uint256,
+      uint256,
+      address[] memory
+    )
+  {
     AmountCalc memory results = _getAmountsInData(reserveIn, reserveOut, amountOut);
 
     return (
@@ -120,10 +142,11 @@ abstract contract BaseUniswapAdapter is FlashLoanReceiverBase, IBaseUniswapAdapt
     uint256 fromAssetPrice = _getPrice(assetToSwapFrom);
     uint256 toAssetPrice = _getPrice(assetToSwapTo);
 
-    uint256 expectedMinAmountOut = amountToSwap
-      .mul(fromAssetPrice.mul(10 ** toAssetDecimals))
-      .div(toAssetPrice.mul(10 ** fromAssetDecimals))
-      .percentMul(PercentageMath.PERCENTAGE_FACTOR.sub(MAX_SLIPPAGE_PERCENT));
+    uint256 expectedMinAmountOut =
+      amountToSwap
+        .mul(fromAssetPrice.mul(10**toAssetDecimals))
+        .div(toAssetPrice.mul(10**fromAssetDecimals))
+        .percentMul(PercentageMath.PERCENTAGE_FACTOR.sub(MAX_SLIPPAGE_PERCENT));
 
     require(expectedMinAmountOut < minAmountOut, 'minAmountOut exceed max slippage');
 
@@ -142,13 +165,14 @@ abstract contract BaseUniswapAdapter is FlashLoanReceiverBase, IBaseUniswapAdapt
       path[0] = assetToSwapFrom;
       path[1] = assetToSwapTo;
     }
-    uint256[] memory amounts = UNISWAP_ROUTER.swapExactTokensForTokens(
-      amountToSwap,
-      minAmountOut,
-      path,
-      address(this),
-      block.timestamp
-    );
+    uint256[] memory amounts =
+      UNISWAP_ROUTER.swapExactTokensForTokens(
+        amountToSwap,
+        minAmountOut,
+        path,
+        address(this),
+        block.timestamp
+      );
 
     emit Swapped(assetToSwapFrom, assetToSwapTo, amounts[0], amounts[amounts.length - 1]);
 
@@ -177,10 +201,11 @@ abstract contract BaseUniswapAdapter is FlashLoanReceiverBase, IBaseUniswapAdapt
     uint256 fromAssetPrice = _getPrice(assetToSwapFrom);
     uint256 toAssetPrice = _getPrice(assetToSwapTo);
 
-    uint256 expectedMaxAmountToSwap = amountToReceive
-      .mul(toAssetPrice.mul(10 ** fromAssetDecimals))
-      .div(fromAssetPrice.mul(10 ** toAssetDecimals))
-      .percentMul(PercentageMath.PERCENTAGE_FACTOR.add(MAX_SLIPPAGE_PERCENT));
+    uint256 expectedMaxAmountToSwap =
+      amountToReceive
+        .mul(toAssetPrice.mul(10**fromAssetDecimals))
+        .div(fromAssetPrice.mul(10**toAssetDecimals))
+        .percentMul(PercentageMath.PERCENTAGE_FACTOR.add(MAX_SLIPPAGE_PERCENT));
 
     require(maxAmountToSwap < expectedMaxAmountToSwap, 'maxAmountToSwap exceed max slippage');
 
@@ -200,13 +225,14 @@ abstract contract BaseUniswapAdapter is FlashLoanReceiverBase, IBaseUniswapAdapt
       path[1] = assetToSwapTo;
     }
 
-    uint256[] memory amounts = UNISWAP_ROUTER.swapTokensForExactTokens(
-      amountToReceive,
-      maxAmountToSwap,
-      path,
-      address(this),
-      block.timestamp
-    );
+    uint256[] memory amounts =
+      UNISWAP_ROUTER.swapTokensForExactTokens(
+        amountToReceive,
+        maxAmountToSwap,
+        path,
+        address(this),
+        block.timestamp
+      );
 
     emit Swapped(assetToSwapFrom, assetToSwapTo, amounts[0], amounts[amounts.length - 1]);
 
@@ -298,7 +324,7 @@ abstract contract BaseUniswapAdapter is FlashLoanReceiverBase, IBaseUniswapAdapt
     uint256 ethUsdPrice = _getPrice(USD_ADDRESS);
     uint256 reservePrice = _getPrice(reserve);
 
-    return amount.mul(reservePrice).div(10 ** decimals).mul(ethUsdPrice).div(10 ** 18);
+    return amount.mul(reservePrice).div(10**decimals).mul(ethUsdPrice).div(10**18);
   }
 
   /**
@@ -328,7 +354,7 @@ abstract contract BaseUniswapAdapter is FlashLoanReceiverBase, IBaseUniswapAdapt
       return
         AmountCalc(
           finalAmountIn,
-          finalAmountIn.mul(10 ** 18).div(amountIn),
+          finalAmountIn.mul(10**18).div(amountIn),
           _calcUsdValue(reserveIn, amountIn, reserveDecimals),
           _calcUsdValue(reserveIn, finalAmountIn, reserveDecimals),
           path
@@ -376,9 +402,10 @@ abstract contract BaseUniswapAdapter is FlashLoanReceiverBase, IBaseUniswapAdapt
     uint256 reserveInDecimals = _getDecimals(reserveIn);
     uint256 reserveOutDecimals = _getDecimals(reserveOut);
 
-    uint256 outPerInPrice = finalAmountIn.mul(10 ** 18).mul(10 ** reserveOutDecimals).div(
-      bestAmountOut.mul(10 ** reserveInDecimals)
-    );
+    uint256 outPerInPrice =
+      finalAmountIn.mul(10**18).mul(10**reserveOutDecimals).div(
+        bestAmountOut.mul(10**reserveInDecimals)
+      );
 
     return
       AmountCalc(
@@ -418,18 +445,15 @@ abstract contract BaseUniswapAdapter is FlashLoanReceiverBase, IBaseUniswapAdapt
       return
         AmountCalc(
           amountIn,
-          amountOut.mul(10 ** 18).div(amountIn),
+          amountOut.mul(10**18).div(amountIn),
           _calcUsdValue(reserveIn, amountIn, reserveDecimals),
           _calcUsdValue(reserveIn, amountOut, reserveDecimals),
           path
         );
     }
 
-    (uint256[] memory amounts, address[] memory path) = _getAmountsInAndPath(
-      reserveIn,
-      reserveOut,
-      amountOut
-    );
+    (uint256[] memory amounts, address[] memory path) =
+      _getAmountsInAndPath(reserveIn, reserveOut, amountOut);
 
     // Add flash loan fee
     uint256 finalAmountIn = amounts[0].add(amounts[0].mul(FLASHLOAN_PREMIUM_TOTAL).div(10000));
@@ -437,9 +461,10 @@ abstract contract BaseUniswapAdapter is FlashLoanReceiverBase, IBaseUniswapAdapt
     uint256 reserveInDecimals = _getDecimals(reserveIn);
     uint256 reserveOutDecimals = _getDecimals(reserveOut);
 
-    uint256 inPerOutPrice = amountOut.mul(10 ** 18).mul(10 ** reserveInDecimals).div(
-      finalAmountIn.mul(10 ** reserveOutDecimals)
-    );
+    uint256 inPerOutPrice =
+      amountOut.mul(10**18).mul(10**reserveInDecimals).div(
+        finalAmountIn.mul(10**reserveOutDecimals)
+      );
 
     return
       AmountCalc(
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/adapters/UniswapLiquiditySwapAdapter.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/adapters/UniswapLiquiditySwapAdapter.sol
index 45ef2a7..daac354 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/adapters/UniswapLiquiditySwapAdapter.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/adapters/UniswapLiquiditySwapAdapter.sol
@@ -265,7 +265,8 @@ contract UniswapLiquiditySwapAdapter is BaseUniswapAdapter {
       bytes32[] memory r,
       bytes32[] memory s,
       bool[] memory useEthPath
-    ) = abi.decode(
+    ) =
+      abi.decode(
         params,
         (address[], uint256[], bool[], uint256[], uint256[], uint8[], bytes32[], bytes32[], bool[])
       );
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/adapters/UniswapRepayAdapter.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/adapters/UniswapRepayAdapter.sol
index 3f1b826..b1c9533 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/adapters/UniswapRepayAdapter.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/adapters/UniswapRepayAdapter.sol
@@ -100,10 +100,10 @@ contract UniswapRepayAdapter is BaseUniswapAdapter {
     DataTypes.ReserveData memory collateralReserveData = _getReserveData(collateralAsset);
     DataTypes.ReserveData memory debtReserveData = _getReserveData(debtAsset);
 
-    address debtToken = DataTypes.InterestRateMode(debtRateMode) ==
-      DataTypes.InterestRateMode.STABLE
-      ? debtReserveData.stableDebtTokenAddress
-      : debtReserveData.variableDebtTokenAddress;
+    address debtToken =
+      DataTypes.InterestRateMode(debtRateMode) == DataTypes.InterestRateMode.STABLE
+        ? debtReserveData.stableDebtTokenAddress
+        : debtReserveData.variableDebtTokenAddress;
 
     uint256 currentDebt = IERC20(debtToken).balanceOf(msg.sender);
     uint256 amountToRepay = debtRepayAmount <= currentDebt ? debtRepayAmount : currentDebt;
@@ -115,12 +115,8 @@ contract UniswapRepayAdapter is BaseUniswapAdapter {
       }
 
       // Get exact collateral needed for the swap to avoid leftovers
-      uint256[] memory amounts = _getAmountsIn(
-        collateralAsset,
-        debtAsset,
-        amountToRepay,
-        useEthPath
-      );
+      uint256[] memory amounts =
+        _getAmountsIn(collateralAsset, debtAsset, amountToRepay, useEthPath);
       require(amounts[0] <= maxCollateralToSwap, 'slippage too high');
 
       // Pull aTokens from user
@@ -190,12 +186,8 @@ contract UniswapRepayAdapter is BaseUniswapAdapter {
       }
 
       uint256 neededForFlashLoanDebt = repaidAmount.add(premium);
-      uint256[] memory amounts = _getAmountsIn(
-        collateralAsset,
-        debtAsset,
-        neededForFlashLoanDebt,
-        useEthPath
-      );
+      uint256[] memory amounts =
+        _getAmountsIn(collateralAsset, debtAsset, neededForFlashLoanDebt, useEthPath);
       require(amounts[0] <= maxCollateralToSwap, 'slippage too high');
 
       // Pull aTokens from user
@@ -256,7 +248,8 @@ contract UniswapRepayAdapter is BaseUniswapAdapter {
       bytes32 r,
       bytes32 s,
       bool useEthPath
-    ) = abi.decode(
+    ) =
+      abi.decode(
         params,
         (address, uint256, uint256, uint256, uint256, uint8, bytes32, bytes32, bool)
       );
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/adapters/interfaces/IBaseUniswapAdapter.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/adapters/interfaces/IBaseUniswapAdapter.sol
index cd1a5de..82997b7 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/adapters/interfaces/IBaseUniswapAdapter.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/adapters/interfaces/IBaseUniswapAdapter.sol
@@ -51,7 +51,16 @@ interface IBaseUniswapAdapter {
     uint256 amountIn,
     address reserveIn,
     address reserveOut
-  ) external view returns (uint256, uint256, uint256, uint256, address[] memory);
+  )
+    external
+    view
+    returns (
+      uint256,
+      uint256,
+      uint256,
+      uint256,
+      address[] memory
+    );
 
   /**
    * @dev Returns the minimum input asset amount required to buy the given output asset amount and the prices
@@ -68,5 +77,14 @@ interface IBaseUniswapAdapter {
     uint256 amountOut,
     address reserveIn,
     address reserveOut
-  ) external view returns (uint256, uint256, uint256, uint256, address[] memory);
+  )
+    external
+    view
+    returns (
+      uint256,
+      uint256,
+      uint256,
+      uint256,
+      address[] memory
+    );
 }
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/ERC20.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/ERC20.sol
index c256bed..07fea73 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/ERC20.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/ERC20.sol
@@ -122,10 +122,13 @@ contract ERC20 is Context, IERC20 {
   /**
    * @dev See {IERC20-allowance}.
    */
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
 
@@ -198,10 +201,11 @@ contract ERC20 is Context, IERC20 {
    * - `spender` must have allowance for the caller of at least
    * `subtractedValue`.
    */
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
@@ -227,7 +231,11 @@ contract ERC20 is Context, IERC20 {
    * - `recipient` cannot be the zero address.
    * - `sender` must have a balance of at least `amount`.
    */
-  function _transfer(address sender, address recipient, uint256 amount) internal virtual {
+  function _transfer(
+    address sender,
+    address recipient,
+    uint256 amount
+  ) internal virtual {
     require(sender != address(0), 'ERC20: transfer from the zero address');
     require(recipient != address(0), 'ERC20: transfer to the zero address');
 
@@ -291,7 +299,11 @@ contract ERC20 is Context, IERC20 {
    * - `owner` cannot be the zero address.
    * - `spender` cannot be the zero address.
    */
-  function _approve(address owner, address spender, uint256 amount) internal virtual {
+  function _approve(
+    address owner,
+    address spender,
+    uint256 amount
+  ) internal virtual {
     require(owner != address(0), 'ERC20: approve from the zero address');
     require(spender != address(0), 'ERC20: approve to the zero address');
 
@@ -324,5 +336,9 @@ contract ERC20 is Context, IERC20 {
    *
    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
    */
-  function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
+  function _beforeTokenTransfer(
+    address from,
+    address to,
+    uint256 amount
+  ) internal virtual {}
 }
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/IERC20.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/IERC20.sol
index 3096454..3d69bff 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/IERC20.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/IERC20.sol
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
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeERC20.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeERC20.sol
index 48c7e18..0a27559 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeERC20.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeERC20.sol
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
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeMath.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeMath.sol
index 5c68ca1..80f7d67 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeMath.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeMath.sol
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
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/upgradeability/BaseAdminUpgradeabilityProxy.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/upgradeability/BaseAdminUpgradeabilityProxy.sol
index 7ca135c..87e8895 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/upgradeability/BaseAdminUpgradeabilityProxy.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/upgradeability/BaseAdminUpgradeabilityProxy.sol
@@ -83,10 +83,11 @@ contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
    * It should include the signature and the parameters of the function to be called, as described in
    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
    */
-  function upgradeToAndCall(
-    address newImplementation,
-    bytes calldata data
-  ) external payable ifAdmin {
+  function upgradeToAndCall(address newImplementation, bytes calldata data)
+    external
+    payable
+    ifAdmin
+  {
     _upgradeTo(newImplementation);
     (bool success, ) = newImplementation.delegatecall(data);
     require(success);
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/upgradeability/InitializableAdminUpgradeabilityProxy.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/upgradeability/InitializableAdminUpgradeabilityProxy.sol
index 4c5a2a2..c5d089b 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/upgradeability/InitializableAdminUpgradeabilityProxy.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/upgradeability/InitializableAdminUpgradeabilityProxy.sol
@@ -22,7 +22,11 @@ contract InitializableAdminUpgradeabilityProxy is
    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
    */
-  function initialize(address logic, address admin, bytes memory data) public payable {
+  function initialize(
+    address logic,
+    address admin,
+    bytes memory data
+  ) public payable {
     require(_implementation() == address(0));
     InitializableUpgradeabilityProxy.initialize(logic, data);
     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
index 836dbed..ab20b9a 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
@@ -44,13 +44,13 @@ abstract contract Proxy {
       returndatacopy(0, 0, returndatasize())
 
       switch result
-      // delegatecall returns 0 on error.
-      case 0 {
-        revert(0, returndatasize())
-      }
-      default {
-        return(0, returndatasize())
-      }
+        // delegatecall returns 0 on error.
+        case 0 {
+          revert(0, returndatasize())
+        }
+        default {
+          return(0, returndatasize())
+        }
     }
   }
 
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/deployments/ATokensAndRatesHelper.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/deployments/ATokensAndRatesHelper.sol
index fbc97c4..400f7ca 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/deployments/ATokensAndRatesHelper.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/deployments/ATokensAndRatesHelper.sol
@@ -3,10 +3,14 @@ pragma solidity 0.6.12;
 pragma experimental ABIEncoderV2;
 
 import {LendingPool} from '../protocol/lendingpool/LendingPool.sol';
-import {LendingPoolAddressesProvider} from '../protocol/configuration/LendingPoolAddressesProvider.sol';
+import {
+  LendingPoolAddressesProvider
+} from '../protocol/configuration/LendingPoolAddressesProvider.sol';
 import {LendingPoolConfigurator} from '../protocol/lendingpool/LendingPoolConfigurator.sol';
 import {AToken} from '../protocol/tokenization/AToken.sol';
-import {DefaultReserveInterestRateStrategy} from '../protocol/lendingpool/DefaultReserveInterestRateStrategy.sol';
+import {
+  DefaultReserveInterestRateStrategy
+} from '../protocol/lendingpool/DefaultReserveInterestRateStrategy.sol';
 import {Ownable} from '../dependencies/openzeppelin/contracts/Ownable.sol';
 import {StringLib} from './StringLib.sol';
 
@@ -30,7 +34,11 @@ contract ATokensAndRatesHelper is Ownable {
     bool stableBorrowingEnabled;
   }
 
-  constructor(address payable _pool, address _addressesProvider, address _poolConfigurator) public {
+  constructor(
+    address payable _pool,
+    address _addressesProvider,
+    address _poolConfigurator
+  ) public {
     pool = _pool;
     addressesProvider = _addressesProvider;
     poolConfigurator = _poolConfigurator;
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAToken.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAToken.sol
index 872bacf..3a6ac66 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAToken.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAToken.sol
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
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAaveIncentivesController.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAaveIncentivesController.sol
index c4bfb7d..c049bd7 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAaveIncentivesController.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IAaveIncentivesController.sol
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
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/ILendingPool.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/ILendingPool.sol
index 172d7c9..64f726c 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/ILendingPool.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/ILendingPool.sol
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
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/ILendingPoolAddressesProviderRegistry.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/ILendingPoolAddressesProviderRegistry.sol
index 56e5f10..89f0c61 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/ILendingPoolAddressesProviderRegistry.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/ILendingPoolAddressesProviderRegistry.sol
@@ -15,9 +15,10 @@ interface ILendingPoolAddressesProviderRegistry {
 
   function getAddressesProvidersList() external view returns (address[] memory);
 
-  function getAddressesProviderIdByAddress(
-    address addressesProvider
-  ) external view returns (uint256);
+  function getAddressesProviderIdByAddress(address addressesProvider)
+    external
+    view
+    returns (uint256);
 
   function registerAddressesProvider(address provider, uint256 id) external;
 
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IReserveInterestRateStrategy.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IReserveInterestRateStrategy.sol
index 242774a..cee593c 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IReserveInterestRateStrategy.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IReserveInterestRateStrategy.sol
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
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IStableDebtToken.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IStableDebtToken.sol
index 7fdf8e4..e39cf8b 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IStableDebtToken.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IStableDebtToken.sol
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
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IUniswapV2Router02.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IUniswapV2Router02.sol
index 88f7169..1b1dc47 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IUniswapV2Router02.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IUniswapV2Router02.sol
@@ -18,13 +18,13 @@ interface IUniswapV2Router02 {
     uint256 deadline
   ) external returns (uint256[] memory amounts);
 
-  function getAmountsOut(
-    uint256 amountIn,
-    address[] calldata path
-  ) external view returns (uint256[] memory amounts);
+  function getAmountsOut(uint256 amountIn, address[] calldata path)
+    external
+    view
+    returns (uint256[] memory amounts);
 
-  function getAmountsIn(
-    uint256 amountOut,
-    address[] calldata path
-  ) external view returns (uint256[] memory amounts);
+  function getAmountsIn(uint256 amountOut, address[] calldata path)
+    external
+    view
+    returns (uint256[] memory amounts);
 }
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IVariableDebtToken.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IVariableDebtToken.sol
index 8941a15..d88c25f 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IVariableDebtToken.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/interfaces/IVariableDebtToken.sol
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
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/AaveOracle.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/AaveOracle.sol
index 89cbae4..0cb8e18 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/AaveOracle.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/AaveOracle.sol
@@ -46,10 +46,10 @@ contract AaveOracle is IPriceOracleGetter, Ownable {
   /// @notice External function called by the Aave governance to set or replace sources of assets
   /// @param assets The addresses of the assets
   /// @param sources The address of the source of each asset
-  function setAssetSources(
-    address[] calldata assets,
-    address[] calldata sources
-  ) external onlyOwner {
+  function setAssetSources(address[] calldata assets, address[] calldata sources)
+    external
+    onlyOwner
+  {
     _setAssetsSources(assets, sources);
   }
 
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/AaveProtocolDataProvider.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/AaveProtocolDataProvider.sol
index 1753000..56f7c96 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/AaveProtocolDataProvider.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/AaveProtocolDataProvider.sol
@@ -64,9 +64,7 @@ contract AaveProtocolDataProvider {
     return aTokens;
   }
 
-  function getReserveConfigurationData(
-    address asset
-  )
+  function getReserveConfigurationData(address asset)
     external
     view
     returns (
@@ -82,9 +80,8 @@ contract AaveProtocolDataProvider {
       bool isFrozen
     )
   {
-    DataTypes.ReserveConfigurationMap memory configuration = ILendingPool(
-      ADDRESSES_PROVIDER.getLendingPool()
-    ).getConfiguration(asset);
+    DataTypes.ReserveConfigurationMap memory configuration =
+      ILendingPool(ADDRESSES_PROVIDER.getLendingPool()).getConfiguration(asset);
 
     (ltv, liquidationThreshold, liquidationBonus, decimals, reserveFactor) = configuration
       .getParamsMemory();
@@ -95,9 +92,7 @@ contract AaveProtocolDataProvider {
     usageAsCollateralEnabled = liquidationThreshold > 0;
   }
 
-  function getReserveData(
-    address asset
-  )
+  function getReserveData(address asset)
     external
     view
     returns (
@@ -113,8 +108,8 @@ contract AaveProtocolDataProvider {
       uint40 lastUpdateTimestamp
     )
   {
-    DataTypes.ReserveData memory reserve = ILendingPool(ADDRESSES_PROVIDER.getLendingPool())
-      .getReserveData(asset);
+    DataTypes.ReserveData memory reserve =
+      ILendingPool(ADDRESSES_PROVIDER.getLendingPool()).getReserveData(asset);
 
     return (
       IERC20Detailed(asset).balanceOf(reserve.aTokenAddress),
@@ -130,10 +125,7 @@ contract AaveProtocolDataProvider {
     );
   }
 
-  function getUserReserveData(
-    address asset,
-    address user
-  )
+  function getUserReserveData(address asset, address user)
     external
     view
     returns (
@@ -148,12 +140,11 @@ contract AaveProtocolDataProvider {
       bool usageAsCollateralEnabled
     )
   {
-    DataTypes.ReserveData memory reserve = ILendingPool(ADDRESSES_PROVIDER.getLendingPool())
-      .getReserveData(asset);
+    DataTypes.ReserveData memory reserve =
+      ILendingPool(ADDRESSES_PROVIDER.getLendingPool()).getReserveData(asset);
 
-    DataTypes.UserConfigurationMap memory userConfig = ILendingPool(
-      ADDRESSES_PROVIDER.getLendingPool()
-    ).getUserConfiguration(user);
+    DataTypes.UserConfigurationMap memory userConfig =
+      ILendingPool(ADDRESSES_PROVIDER.getLendingPool()).getUserConfiguration(user);
 
     currentATokenBalance = IERC20Detailed(reserve.aTokenAddress).balanceOf(user);
     currentVariableDebt = IERC20Detailed(reserve.variableDebtTokenAddress).balanceOf(user);
@@ -168,9 +159,7 @@ contract AaveProtocolDataProvider {
     usageAsCollateralEnabled = userConfig.isUsingAsCollateral(reserve.id);
   }
 
-  function getReserveTokensAddresses(
-    address asset
-  )
+  function getReserveTokensAddresses(address asset)
     external
     view
     returns (
@@ -179,8 +168,8 @@ contract AaveProtocolDataProvider {
       address variableDebtTokenAddress
     )
   {
-    DataTypes.ReserveData memory reserve = ILendingPool(ADDRESSES_PROVIDER.getLendingPool())
-      .getReserveData(asset);
+    DataTypes.ReserveData memory reserve =
+      ILendingPool(ADDRESSES_PROVIDER.getLendingPool()).getReserveData(asset);
 
     return (
       reserve.aTokenAddress,
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/UiPoolDataProvider.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/UiPoolDataProvider.sol
index e546a0c..65fdc4d 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/UiPoolDataProvider.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/UiPoolDataProvider.sol
@@ -14,7 +14,9 @@ import {WadRayMath} from '../protocol/libraries/math/WadRayMath.sol';
 import {ReserveConfiguration} from '../protocol/libraries/configuration/ReserveConfiguration.sol';
 import {UserConfiguration} from '../protocol/libraries/configuration/UserConfiguration.sol';
 import {DataTypes} from '../protocol/libraries/types/DataTypes.sol';
-import {DefaultReserveInterestRateStrategy} from '../protocol/lendingpool/DefaultReserveInterestRateStrategy.sol';
+import {
+  DefaultReserveInterestRateStrategy
+} from '../protocol/lendingpool/DefaultReserveInterestRateStrategy.sol';
 
 contract UiPoolDataProvider is IUiPoolDataProvider {
   using WadRayMath for uint256;
@@ -23,9 +25,16 @@ contract UiPoolDataProvider is IUiPoolDataProvider {
 
   address public constant MOCK_USD_ADDRESS = 0x10F7Fc1F91Ba351f9C629c5947AD69bD03C05b96;
 
-  function getInterestRateStrategySlopes(
-    DefaultReserveInterestRateStrategy interestRateStrategy
-  ) internal view returns (uint256, uint256, uint256, uint256) {
+  function getInterestRateStrategySlopes(DefaultReserveInterestRateStrategy interestRateStrategy)
+    internal
+    view
+    returns (
+      uint256,
+      uint256,
+      uint256,
+      uint256
+    )
+  {
     return (
       interestRateStrategy.variableRateSlope1(),
       interestRateStrategy.variableRateSlope2(),
@@ -34,14 +43,15 @@ contract UiPoolDataProvider is IUiPoolDataProvider {
     );
   }
 
-  function getReservesData(
-    ILendingPoolAddressesProvider provider,
-    address user
-  )
+  function getReservesData(ILendingPoolAddressesProvider provider, address user)
     external
     view
     override
-    returns (AggregatedReserveData[] memory, UserReserveData[] memory, uint256)
+    returns (
+      AggregatedReserveData[] memory,
+      UserReserveData[] memory,
+      uint256
+    )
   {
     ILendingPool lendingPool = ILendingPool(provider.getLendingPool());
     IPriceOracleGetter oracle = IPriceOracleGetter(provider.getPriceOracle());
@@ -49,18 +59,16 @@ contract UiPoolDataProvider is IUiPoolDataProvider {
     DataTypes.UserConfigurationMap memory userConfig = lendingPool.getUserConfiguration(user);
 
     AggregatedReserveData[] memory reservesData = new AggregatedReserveData[](reserves.length);
-    UserReserveData[] memory userReservesData = new UserReserveData[](
-      user != address(0) ? reserves.length : 0
-    );
+    UserReserveData[] memory userReservesData =
+      new UserReserveData[](user != address(0) ? reserves.length : 0);
 
     for (uint256 i = 0; i < reserves.length; i++) {
       AggregatedReserveData memory reserveData = reservesData[i];
       reserveData.underlyingAsset = reserves[i];
 
       // reserve current state
-      DataTypes.ReserveData memory baseData = lendingPool.getReserveData(
-        reserveData.underlyingAsset
-      );
+      DataTypes.ReserveData memory baseData =
+        lendingPool.getReserveData(reserveData.underlyingAsset);
       reserveData.liquidityIndex = baseData.liquidityIndex;
       reserveData.variableBorrowIndex = baseData.variableBorrowIndex;
       reserveData.liquidityRate = baseData.currentLiquidityRate;
@@ -123,18 +131,26 @@ contract UiPoolDataProvider is IUiPoolDataProvider {
 
         if (userConfig.isBorrowing(i)) {
           userReservesData[i].scaledVariableDebt = IVariableDebtToken(
-            reserveData.variableDebtTokenAddress
-          ).scaledBalanceOf(user);
+            reserveData
+              .variableDebtTokenAddress
+          )
+            .scaledBalanceOf(user);
           userReservesData[i].principalStableDebt = IStableDebtToken(
-            reserveData.stableDebtTokenAddress
-          ).principalBalanceOf(user);
+            reserveData
+              .stableDebtTokenAddress
+          )
+            .principalBalanceOf(user);
           if (userReservesData[i].principalStableDebt != 0) {
             userReservesData[i].stableBorrowRate = IStableDebtToken(
-              reserveData.stableDebtTokenAddress
-            ).getUserStableRate(user);
+              reserveData
+                .stableDebtTokenAddress
+            )
+              .getUserStableRate(user);
             userReservesData[i].stableBorrowLastUpdateTimestamp = IStableDebtToken(
-              reserveData.stableDebtTokenAddress
-            ).getUserLastUpdated(user);
+              reserveData
+                .stableDebtTokenAddress
+            )
+              .getUserLastUpdated(user);
           }
         }
       }
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/WETHGateway.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/WETHGateway.sol
index ba59e4a..336e8de 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/WETHGateway.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/WETHGateway.sol
@@ -53,7 +53,11 @@ contract WETHGateway is IWETHGateway, Ownable {
    * @param amount amount of aWETH to withdraw and receive native ETH
    * @param to address of the user who will receive native ETH
    */
-  function withdrawETH(address lendingPool, uint256 amount, address to) external override {
+  function withdrawETH(
+    address lendingPool,
+    uint256 amount,
+    address to
+  ) external override {
     IAToken aWETH = IAToken(ILendingPool(lendingPool).getReserveData(address(WETH)).aTokenAddress);
     uint256 userBalance = aWETH.balanceOf(msg.sender);
     uint256 amountToWithdraw = amount;
@@ -81,15 +85,16 @@ contract WETHGateway is IWETHGateway, Ownable {
     uint256 rateMode,
     address onBehalfOf
   ) external payable override {
-    (uint256 stableDebt, uint256 variableDebt) = Helpers.getUserCurrentDebtMemory(
-      onBehalfOf,
-      ILendingPool(lendingPool).getReserveData(address(WETH))
-    );
+    (uint256 stableDebt, uint256 variableDebt) =
+      Helpers.getUserCurrentDebtMemory(
+        onBehalfOf,
+        ILendingPool(lendingPool).getReserveData(address(WETH))
+      );
 
-    uint256 paybackAmount = DataTypes.InterestRateMode(rateMode) ==
-      DataTypes.InterestRateMode.STABLE
-      ? stableDebt
-      : variableDebt;
+    uint256 paybackAmount =
+      DataTypes.InterestRateMode(rateMode) == DataTypes.InterestRateMode.STABLE
+        ? stableDebt
+        : variableDebt;
 
     if (amount < paybackAmount) {
       paybackAmount = amount;
@@ -143,7 +148,11 @@ contract WETHGateway is IWETHGateway, Ownable {
    * @param to recipient of the transfer
    * @param amount amount to send
    */
-  function emergencyTokenTransfer(address token, address to, uint256 amount) external onlyOwner {
+  function emergencyTokenTransfer(
+    address token,
+    address to,
+    uint256 amount
+  ) external onlyOwner {
     IERC20(token).transfer(to, amount);
   }
 
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/WalletBalanceProvider.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/WalletBalanceProvider.sol
index 2373c77..3d4a928 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/WalletBalanceProvider.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/WalletBalanceProvider.sol
@@ -57,10 +57,11 @@ contract WalletBalanceProvider {
    * @param tokens The list of tokens
    * @return And array with the concatenation of, for each user, his/her balances
    **/
-  function batchBalanceOf(
-    address[] calldata users,
-    address[] calldata tokens
-  ) external view returns (uint256[] memory) {
+  function batchBalanceOf(address[] calldata users, address[] calldata tokens)
+    external
+    view
+    returns (uint256[] memory)
+  {
     uint256[] memory balances = new uint256[](users.length * tokens.length);
 
     for (uint256 i = 0; i < users.length; i++) {
@@ -75,10 +76,11 @@ contract WalletBalanceProvider {
   /**
     @dev provides balances of user wallet for all reserves available on the pool
     */
-  function getUserWalletBalances(
-    address provider,
-    address user
-  ) external view returns (address[] memory, uint256[] memory) {
+  function getUserWalletBalances(address provider, address user)
+    external
+    view
+    returns (address[] memory, uint256[] memory)
+  {
     ILendingPool pool = ILendingPool(ILendingPoolAddressesProvider(provider).getLendingPool());
 
     address[] memory reserves = pool.getReservesList();
@@ -91,9 +93,8 @@ contract WalletBalanceProvider {
     uint256[] memory balances = new uint256[](reservesWithEth.length);
 
     for (uint256 j = 0; j < reserves.length; j++) {
-      DataTypes.ReserveConfigurationMap memory configuration = pool.getConfiguration(
-        reservesWithEth[j]
-      );
+      DataTypes.ReserveConfigurationMap memory configuration =
+        pool.getConfiguration(reservesWithEth[j]);
 
       (bool isActive, , , ) = configuration.getFlagsMemory();
 
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/interfaces/IUiPoolDataProvider.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/interfaces/IUiPoolDataProvider.sol
index 7669c61..81a553e 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/interfaces/IUiPoolDataProvider.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/interfaces/IUiPoolDataProvider.sol
@@ -67,10 +67,14 @@ interface IUiPoolDataProvider {
   //    address aTokenAddress;
   //  }
 
-  function getReservesData(
-    ILendingPoolAddressesProvider provider,
-    address user
-  ) external view returns (AggregatedReserveData[] memory, UserReserveData[] memory, uint256);
+  function getReservesData(ILendingPoolAddressesProvider provider, address user)
+    external
+    view
+    returns (
+      AggregatedReserveData[] memory,
+      UserReserveData[] memory,
+      uint256
+    );
 
   //  function getUserReservesData(ILendingPoolAddressesProvider provider, address user)
   //    external
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/interfaces/IWETH.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/interfaces/IWETH.sol
index 6104470..1265cdd 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/interfaces/IWETH.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/interfaces/IWETH.sol
@@ -8,5 +8,9 @@ interface IWETH {
 
   function approve(address guy, uint256 wad) external returns (bool);
 
-  function transferFrom(address src, address dst, uint256 wad) external returns (bool);
+  function transferFrom(
+    address src,
+    address dst,
+    uint256 wad
+  ) external returns (bool);
 }
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/interfaces/IWETHGateway.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/interfaces/IWETHGateway.sol
index 7d01e3a..78d913c 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/interfaces/IWETHGateway.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/misc/interfaces/IWETHGateway.sol
@@ -8,7 +8,11 @@ interface IWETHGateway {
     uint16 referralCode
   ) external payable;
 
-  function withdrawETH(address lendingPool, uint256 amount, address onBehalfOf) external;
+  function withdrawETH(
+    address lendingPool,
+    uint256 amount,
+    address onBehalfOf
+  ) external;
 
   function repayETH(
     address lendingPool,
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/flashloan/MockFlashLoanReceiver.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/flashloan/MockFlashLoanReceiver.sol
index a0b3f8c..9bf2973 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/flashloan/MockFlashLoanReceiver.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/flashloan/MockFlashLoanReceiver.sol
@@ -68,9 +68,8 @@ contract MockFlashLoanReceiver is FlashLoanReceiverBase {
         'Invalid balance for the contract'
       );
 
-      uint256 amountToReturn = (_amountToApprove != 0)
-        ? _amountToApprove
-        : amounts[i].add(premiums[i]);
+      uint256 amountToReturn =
+        (_amountToApprove != 0) ? _amountToApprove : amounts[i].add(premiums[i]);
       //execution does not fail - mint tokens and return them to the _destination
 
       token.mint(premiums[i]);
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/swap/MockUniswapV2Router02.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/swap/MockUniswapV2Router02.sol
index 66bb026..4f5e851 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/swap/MockUniswapV2Router02.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/swap/MockUniswapV2Router02.sol
@@ -2,7 +2,7 @@
 pragma solidity 0.6.12;
 
 import {IUniswapV2Router02} from '../../interfaces/IUniswapV2Router02.sol';
-import {IERC20} from '../../../openzeppelin/contracts/token/ERC20/IERC20.sol';
+import {IERC20} from '../../../@openzeppelin/contracts/token/ERC20/IERC20.sol';
 import {MintableERC20} from '../tokens/MintableERC20.sol';
 
 contract MockUniswapV2Router02 is IUniswapV2Router02 {
@@ -22,7 +22,7 @@ contract MockUniswapV2Router02 is IUniswapV2Router02 {
 
   function swapExactTokensForTokens(
     uint256 amountIn,
-    uint256 /* amountOutMin */,
+    uint256, /* amountOutMin */
     address[] calldata path,
     address to,
     uint256 /* deadline */
@@ -39,7 +39,7 @@ contract MockUniswapV2Router02 is IUniswapV2Router02 {
 
   function swapTokensForExactTokens(
     uint256 amountOut,
-    uint256 /* amountInMax */,
+    uint256, /* amountInMax */
     address[] calldata path,
     address to,
     uint256 /* deadline */
@@ -76,10 +76,12 @@ contract MockUniswapV2Router02 is IUniswapV2Router02 {
     defaultMockValue = value;
   }
 
-  function getAmountsOut(
-    uint256 amountIn,
-    address[] calldata path
-  ) external view override returns (uint256[] memory) {
+  function getAmountsOut(uint256 amountIn, address[] calldata path)
+    external
+    view
+    override
+    returns (uint256[] memory)
+  {
     uint256[] memory amounts = new uint256[](path.length);
     amounts[0] = amountIn;
     amounts[1] = _amountsOut[path[0]][path[1]][amountIn] > 0
@@ -88,10 +90,12 @@ contract MockUniswapV2Router02 is IUniswapV2Router02 {
     return amounts;
   }
 
-  function getAmountsIn(
-    uint256 amountOut,
-    address[] calldata path
-  ) external view override returns (uint256[] memory) {
+  function getAmountsIn(uint256 amountOut, address[] calldata path)
+    external
+    view
+    override
+    returns (uint256[] memory)
+  {
     uint256[] memory amounts = new uint256[](path.length);
     amounts[0] = _amountsIn[path[0]][path[1]][amountOut] > 0
       ? _amountsIn[path[0]][path[1]][amountOut]
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/tokens/MintableDelegationERC20.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/tokens/MintableDelegationERC20.sol
index 8633d47..f546b2d 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/tokens/MintableDelegationERC20.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/tokens/MintableDelegationERC20.sol
@@ -10,7 +10,11 @@ import {ERC20} from '../../dependencies/openzeppelin/contracts/ERC20.sol';
 contract MintableDelegationERC20 is ERC20 {
   address public delegatee;
 
-  constructor(string memory name, string memory symbol, uint8 decimals) public ERC20(name, symbol) {
+  constructor(
+    string memory name,
+    string memory symbol,
+    uint8 decimals
+  ) public ERC20(name, symbol) {
     _setupDecimals(decimals);
   }
 
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/tokens/MintableERC20.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/tokens/MintableERC20.sol
index c2951f2..56da583 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/tokens/MintableERC20.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/tokens/MintableERC20.sol
@@ -8,7 +8,11 @@ import {ERC20} from '../../dependencies/openzeppelin/contracts/ERC20.sol';
  * @dev ERC20 minting logic
  */
 contract MintableERC20 is ERC20 {
-  constructor(string memory name, string memory symbol, uint8 decimals) public ERC20(name, symbol) {
+  constructor(
+    string memory name,
+    string memory symbol,
+    uint8 decimals
+  ) public ERC20(name, symbol) {
     _setupDecimals(decimals);
   }
 
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/configuration/LendingPoolAddressesProvider.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/configuration/LendingPoolAddressesProvider.sol
index 1a372f4..37b2ed8 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/configuration/LendingPoolAddressesProvider.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/configuration/LendingPoolAddressesProvider.sol
@@ -57,10 +57,11 @@ contract LendingPoolAddressesProvider is Ownable, ILendingPoolAddressesProvider
    * @param id The id
    * @param implementationAddress The address of the new implementation
    */
-  function setAddressAsProxy(
-    bytes32 id,
-    address implementationAddress
-  ) external override onlyOwner {
+  function setAddressAsProxy(bytes32 id, address implementationAddress)
+    external
+    override
+    onlyOwner
+  {
     _updateImpl(id, implementationAddress);
     emit AddressSet(id, implementationAddress, true);
   }
@@ -193,9 +194,8 @@ contract LendingPoolAddressesProvider is Ownable, ILendingPoolAddressesProvider
   function _updateImpl(bytes32 id, address newAddress) internal {
     address payable proxyAddress = payable(_addresses[id]);
 
-    InitializableImmutableAdminUpgradeabilityProxy proxy = InitializableImmutableAdminUpgradeabilityProxy(
-        proxyAddress
-      );
+    InitializableImmutableAdminUpgradeabilityProxy proxy =
+      InitializableImmutableAdminUpgradeabilityProxy(proxyAddress);
     bytes memory params = abi.encodeWithSignature('initialize(address)', address(this));
 
     if (proxyAddress == address(0)) {
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/configuration/LendingPoolAddressesProviderRegistry.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/configuration/LendingPoolAddressesProviderRegistry.sol
index 578fe6b..20b11e0 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/configuration/LendingPoolAddressesProviderRegistry.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/configuration/LendingPoolAddressesProviderRegistry.sol
@@ -2,7 +2,9 @@
 pragma solidity 0.6.12;
 
 import {Ownable} from '../../dependencies/openzeppelin/contracts/Ownable.sol';
-import {ILendingPoolAddressesProviderRegistry} from '../../interfaces/ILendingPoolAddressesProviderRegistry.sol';
+import {
+  ILendingPoolAddressesProviderRegistry
+} from '../../interfaces/ILendingPoolAddressesProviderRegistry.sol';
 import {Errors} from '../libraries/helpers/Errors.sol';
 
 /**
@@ -64,9 +66,12 @@ contract LendingPoolAddressesProviderRegistry is Ownable, ILendingPoolAddressesP
    * @dev Returns the id on a registered LendingPoolAddressesProvider
    * @return The id or 0 if the LendingPoolAddressesProvider is not registered
    */
-  function getAddressesProviderIdByAddress(
-    address addressesProvider
-  ) external view override returns (uint256) {
+  function getAddressesProviderIdByAddress(address addressesProvider)
+    external
+    view
+    override
+    returns (uint256)
+  {
     return _addressesProviders[addressesProvider];
   }
 
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/DefaultReserveInterestRateStrategy.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/DefaultReserveInterestRateStrategy.sol
index 5d994e3..7b321d0 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/DefaultReserveInterestRateStrategy.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/DefaultReserveInterestRateStrategy.sol
@@ -117,7 +117,16 @@ contract DefaultReserveInterestRateStrategy is IReserveInterestRateStrategy {
     uint256 totalVariableDebt,
     uint256 averageStableBorrowRate,
     uint256 reserveFactor
-  ) external view override returns (uint256, uint256, uint256) {
+  )
+    external
+    view
+    override
+    returns (
+      uint256,
+      uint256,
+      uint256
+    )
+  {
     uint256 availableLiquidity = IERC20(reserve).balanceOf(aToken);
     //avoid stack too deep
     availableLiquidity = availableLiquidity.add(liquidityAdded).sub(liquidityTaken);
@@ -160,7 +169,16 @@ contract DefaultReserveInterestRateStrategy is IReserveInterestRateStrategy {
     uint256 totalVariableDebt,
     uint256 averageStableBorrowRate,
     uint256 reserveFactor
-  ) public view override returns (uint256, uint256, uint256) {
+  )
+    public
+    view
+    override
+    returns (
+      uint256,
+      uint256,
+      uint256
+    )
+  {
     CalcInterestRatesLocalVars memory vars;
 
     vars.totalDebt = totalStableDebt.add(totalVariableDebt);
@@ -176,10 +194,8 @@ contract DefaultReserveInterestRateStrategy is IReserveInterestRateStrategy {
       .getMarketBorrowRate(reserve);
 
     if (vars.utilizationRate > OPTIMAL_UTILIZATION_RATE) {
-      uint256 excessUtilizationRateRatio = vars
-        .utilizationRate
-        .sub(OPTIMAL_UTILIZATION_RATE)
-        .rayDiv(EXCESS_UTILIZATION_RATE);
+      uint256 excessUtilizationRateRatio =
+        vars.utilizationRate.sub(OPTIMAL_UTILIZATION_RATE).rayDiv(EXCESS_UTILIZATION_RATE);
 
       vars.currentStableBorrowRate = vars.currentStableBorrowRate.add(_stableRateSlope1).add(
         _stableRateSlope2.rayMul(excessUtilizationRateRatio)
@@ -200,9 +216,12 @@ contract DefaultReserveInterestRateStrategy is IReserveInterestRateStrategy {
     vars.currentLiquidityRate = _getOverallBorrowRate(
       totalStableDebt,
       totalVariableDebt,
-      vars.currentVariableBorrowRate,
+      vars
+        .currentVariableBorrowRate,
       averageStableBorrowRate
-    ).rayMul(vars.utilizationRate).percentMul(PercentageMath.PERCENTAGE_FACTOR.sub(reserveFactor));
+    )
+      .rayMul(vars.utilizationRate)
+      .percentMul(PercentageMath.PERCENTAGE_FACTOR.sub(reserveFactor));
 
     return (
       vars.currentLiquidityRate,
@@ -233,9 +252,8 @@ contract DefaultReserveInterestRateStrategy is IReserveInterestRateStrategy {
 
     uint256 weightedStableRate = totalStableDebt.wadToRay().rayMul(currentAverageStableBorrowRate);
 
-    uint256 overallBorrowRate = weightedVariableRate.add(weightedStableRate).rayDiv(
-      totalDebt.wadToRay()
-    );
+    uint256 overallBorrowRate =
+      weightedVariableRate.add(weightedStableRate).rayDiv(totalDebt.wadToRay());
 
     return overallBorrowRate;
   }
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPool.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPool.sol
index 9357ee4..8e38650 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPool.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPool.sol
@@ -254,9 +254,8 @@ contract LendingPool is VersionedInitializable, ILendingPool, LendingPoolStorage
       variableDebt
     );
 
-    uint256 paybackAmount = interestRateMode == DataTypes.InterestRateMode.STABLE
-      ? stableDebt
-      : variableDebt;
+    uint256 paybackAmount =
+      interestRateMode == DataTypes.InterestRateMode.STABLE ? stableDebt : variableDebt;
 
     if (amount < paybackAmount) {
       paybackAmount = amount;
@@ -385,10 +384,11 @@ contract LendingPool is VersionedInitializable, ILendingPool, LendingPoolStorage
    * @param asset The address of the underlying asset deposited
    * @param useAsCollateral `true` if the user wants to use the deposit as collateral, `false` otherwise
    **/
-  function setUserUseReserveAsCollateral(
-    address asset,
-    bool useAsCollateral
-  ) external override whenNotPaused {
+  function setUserUseReserveAsCollateral(address asset, bool useAsCollateral)
+    external
+    override
+    whenNotPaused
+  {
     DataTypes.ReserveData storage reserve = _reserves[asset];
 
     ValidationLogic.validateSetUseReserveAsCollateral(
@@ -432,16 +432,17 @@ contract LendingPool is VersionedInitializable, ILendingPool, LendingPoolStorage
     address collateralManager = _addressesProvider.getLendingPoolCollateralManager();
 
     //solium-disable-next-line
-    (bool success, bytes memory result) = collateralManager.delegatecall(
-      abi.encodeWithSignature(
-        'liquidationCall(address,address,address,uint256,bool)',
-        collateralAsset,
-        debtAsset,
-        user,
-        debtToCover,
-        receiveAToken
-      )
-    );
+    (bool success, bytes memory result) =
+      collateralManager.delegatecall(
+        abi.encodeWithSignature(
+          'liquidationCall(address,address,address,uint256,bool)',
+          collateralAsset,
+          debtAsset,
+          user,
+          debtToCover,
+          receiveAToken
+        )
+      );
 
     require(success, Errors.LP_LIQUIDATION_CALL_FAILED);
 
@@ -567,9 +568,12 @@ contract LendingPool is VersionedInitializable, ILendingPool, LendingPoolStorage
    * @param asset The address of the underlying asset of the reserve
    * @return The state of the reserve
    **/
-  function getReserveData(
-    address asset
-  ) external view override returns (DataTypes.ReserveData memory) {
+  function getReserveData(address asset)
+    external
+    view
+    override
+    returns (DataTypes.ReserveData memory)
+  {
     return _reserves[asset];
   }
 
@@ -583,9 +587,7 @@ contract LendingPool is VersionedInitializable, ILendingPool, LendingPoolStorage
    * @return ltv the loan to value of the user
    * @return healthFactor the current health factor of the user
    **/
-  function getUserAccountData(
-    address user
-  )
+  function getUserAccountData(address user)
     external
     view
     override
@@ -625,9 +627,12 @@ contract LendingPool is VersionedInitializable, ILendingPool, LendingPoolStorage
    * @param asset The address of the underlying asset of the reserve
    * @return The configuration of the reserve
    **/
-  function getConfiguration(
-    address asset
-  ) external view override returns (DataTypes.ReserveConfigurationMap memory) {
+  function getConfiguration(address asset)
+    external
+    view
+    override
+    returns (DataTypes.ReserveConfigurationMap memory)
+  {
     return _reserves[asset].configuration;
   }
 
@@ -636,9 +641,12 @@ contract LendingPool is VersionedInitializable, ILendingPool, LendingPoolStorage
    * @param user The user address
    * @return The configuration of the user
    **/
-  function getUserConfiguration(
-    address user
-  ) external view override returns (DataTypes.UserConfigurationMap memory) {
+  function getUserConfiguration(address user)
+    external
+    view
+    override
+    returns (DataTypes.UserConfigurationMap memory)
+  {
     return _usersConfig[user];
   }
 
@@ -647,9 +655,13 @@ contract LendingPool is VersionedInitializable, ILendingPool, LendingPoolStorage
    * @param asset The address of the underlying asset of the reserve
    * @return The reserve's normalized income
    */
-  function getReserveNormalizedIncome(
-    address asset
-  ) external view virtual override returns (uint256) {
+  function getReserveNormalizedIncome(address asset)
+    external
+    view
+    virtual
+    override
+    returns (uint256)
+  {
     return _reserves[asset].getNormalizedIncome();
   }
 
@@ -658,9 +670,12 @@ contract LendingPool is VersionedInitializable, ILendingPool, LendingPoolStorage
    * @param asset The address of the underlying asset of the reserve
    * @return The reserve normalized variable debt
    */
-  function getReserveNormalizedVariableDebt(
-    address asset
-  ) external view override returns (uint256) {
+  function getReserveNormalizedVariableDebt(address asset)
+    external
+    view
+    override
+    returns (uint256)
+  {
     return _reserves[asset].getNormalizedDebt();
   }
 
@@ -790,10 +805,11 @@ contract LendingPool is VersionedInitializable, ILendingPool, LendingPoolStorage
    * @param asset The address of the underlying asset of the reserve
    * @param rateStrategyAddress The address of the interest rate strategy contract
    **/
-  function setReserveInterestRateStrategyAddress(
-    address asset,
-    address rateStrategyAddress
-  ) external override onlyLendingPoolConfigurator {
+  function setReserveInterestRateStrategyAddress(address asset, address rateStrategyAddress)
+    external
+    override
+    onlyLendingPoolConfigurator
+  {
     _reserves[asset].interestRateStrategyAddress = rateStrategyAddress;
   }
 
@@ -803,10 +819,11 @@ contract LendingPool is VersionedInitializable, ILendingPool, LendingPoolStorage
    * @param asset The address of the underlying asset of the reserve
    * @param configuration The new configuration bitmap
    **/
-  function setConfiguration(
-    address asset,
-    uint256 configuration
-  ) external override onlyLendingPoolConfigurator {
+  function setConfiguration(address asset, uint256 configuration)
+    external
+    override
+    onlyLendingPoolConfigurator
+  {
     _reserves[asset].configuration.data = configuration;
   }
 
@@ -841,9 +858,10 @@ contract LendingPool is VersionedInitializable, ILendingPool, LendingPoolStorage
 
     address oracle = _addressesProvider.getPriceOracle();
 
-    uint256 amountInETH = IPriceOracleGetter(oracle).getAssetPrice(vars.asset).mul(vars.amount).div(
-      10 ** reserve.configuration.getDecimals()
-    );
+    uint256 amountInETH =
+      IPriceOracleGetter(oracle).getAssetPrice(vars.asset).mul(vars.amount).div(
+        10**reserve.configuration.getDecimals()
+      );
 
     ValidationLogic.validateBorrow(
       vars.asset,
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol
index ab08244..8069272 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol
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
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolConfigurator.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolConfigurator.sol
index 42e1a02..49451d9 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolConfigurator.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolConfigurator.sol
@@ -4,7 +4,9 @@ pragma experimental ABIEncoderV2;
 
 import {SafeMath} from '../../dependencies/openzeppelin/contracts/SafeMath.sol';
 import {VersionedInitializable} from '../libraries/aave-upgradeability/VersionedInitializable.sol';
-import {InitializableImmutableAdminUpgradeabilityProxy} from '../libraries/aave-upgradeability/InitializableImmutableAdminUpgradeabilityProxy.sol';
+import {
+  InitializableImmutableAdminUpgradeabilityProxy
+} from '../libraries/aave-upgradeability/InitializableImmutableAdminUpgradeabilityProxy.sol';
 import {ReserveConfiguration} from '../libraries/configuration/ReserveConfiguration.sol';
 import {ILendingPoolAddressesProvider} from '../../interfaces/ILendingPoolAddressesProvider.sol';
 import {ILendingPool} from '../../interfaces/ILendingPool.sol';
@@ -31,12 +33,12 @@ contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigur
   ILendingPoolAddressesProvider internal addressesProvider;
   ILendingPool internal pool;
 
-  modifier onlyPoolAdmin() {
+  modifier onlyPoolAdmin {
     require(addressesProvider.getPoolAdmin() == msg.sender, Errors.CALLER_NOT_POOL_ADMIN);
     _;
   }
 
-  modifier onlyEmergencyAdmin() {
+  modifier onlyEmergencyAdmin {
     require(
       addressesProvider.getEmergencyAdmin() == msg.sender,
       Errors.LPC_CALLER_NOT_EMERGENCY_ADMIN
@@ -66,48 +68,51 @@ contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigur
   }
 
   function _initReserve(ILendingPool pool, InitReserveInput calldata input) internal {
-    address aTokenProxyAddress = _initTokenWithProxy(
-      input.aTokenImpl,
-      abi.encodeWithSelector(
-        IInitializableAToken.initialize.selector,
-        pool,
-        input.treasury,
-        input.underlyingAsset,
-        IAaveIncentivesController(input.incentivesController),
-        input.underlyingAssetDecimals,
-        input.aTokenName,
-        input.aTokenSymbol,
-        input.params
-      )
-    );
+    address aTokenProxyAddress =
+      _initTokenWithProxy(
+        input.aTokenImpl,
+        abi.encodeWithSelector(
+          IInitializableAToken.initialize.selector,
+          pool,
+          input.treasury,
+          input.underlyingAsset,
+          IAaveIncentivesController(input.incentivesController),
+          input.underlyingAssetDecimals,
+          input.aTokenName,
+          input.aTokenSymbol,
+          input.params
+        )
+      );
 
-    address stableDebtTokenProxyAddress = _initTokenWithProxy(
-      input.stableDebtTokenImpl,
-      abi.encodeWithSelector(
-        IInitializableDebtToken.initialize.selector,
-        pool,
-        input.underlyingAsset,
-        IAaveIncentivesController(input.incentivesController),
-        input.underlyingAssetDecimals,
-        input.stableDebtTokenName,
-        input.stableDebtTokenSymbol,
-        input.params
-      )
-    );
+    address stableDebtTokenProxyAddress =
+      _initTokenWithProxy(
+        input.stableDebtTokenImpl,
+        abi.encodeWithSelector(
+          IInitializableDebtToken.initialize.selector,
+          pool,
+          input.underlyingAsset,
+          IAaveIncentivesController(input.incentivesController),
+          input.underlyingAssetDecimals,
+          input.stableDebtTokenName,
+          input.stableDebtTokenSymbol,
+          input.params
+        )
+      );
 
-    address variableDebtTokenProxyAddress = _initTokenWithProxy(
-      input.variableDebtTokenImpl,
-      abi.encodeWithSelector(
-        IInitializableDebtToken.initialize.selector,
-        pool,
-        input.underlyingAsset,
-        IAaveIncentivesController(input.incentivesController),
-        input.underlyingAssetDecimals,
-        input.variableDebtTokenName,
-        input.variableDebtTokenSymbol,
-        input.params
-      )
-    );
+    address variableDebtTokenProxyAddress =
+      _initTokenWithProxy(
+        input.variableDebtTokenImpl,
+        abi.encodeWithSelector(
+          IInitializableDebtToken.initialize.selector,
+          pool,
+          input.underlyingAsset,
+          IAaveIncentivesController(input.incentivesController),
+          input.underlyingAssetDecimals,
+          input.variableDebtTokenName,
+          input.variableDebtTokenSymbol,
+          input.params
+        )
+      );
 
     pool.initReserve(
       input.underlyingAsset,
@@ -117,9 +122,8 @@ contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigur
       input.interestRateStrategyAddress
     );
 
-    DataTypes.ReserveConfigurationMap memory currentConfig = pool.getConfiguration(
-      input.underlyingAsset
-    );
+    DataTypes.ReserveConfigurationMap memory currentConfig =
+      pool.getConfiguration(input.underlyingAsset);
 
     currentConfig.setDecimals(input.underlyingAssetDecimals);
 
@@ -148,18 +152,22 @@ contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigur
     (, , , uint256 decimals, ) = cachedPool.getConfiguration(input.asset).getParamsMemory();
 
     bytes memory encodedCall = abi.encodeWithSelector(
-      IInitializableAToken.initialize.selector,
-      cachedPool,
-      input.treasury,
-      input.asset,
-      input.incentivesController,
-      decimals,
-      input.name,
-      input.symbol,
-      input.params
-    );
+        IInitializableAToken.initialize.selector,
+        cachedPool,
+        input.treasury,
+        input.asset,
+        input.incentivesController,
+        decimals,
+        input.name,
+        input.symbol,
+        input.params
+      );
 
-    _upgradeTokenImplementation(reserveData.aTokenAddress, input.implementation, encodedCall);
+    _upgradeTokenImplementation(
+      reserveData.aTokenAddress,
+      input.implementation,
+      encodedCall
+    );
 
     emit ATokenUpgraded(input.asset, reserveData.aTokenAddress, input.implementation);
   }
@@ -175,15 +183,15 @@ contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigur
     (, , , uint256 decimals, ) = cachedPool.getConfiguration(input.asset).getParamsMemory();
 
     bytes memory encodedCall = abi.encodeWithSelector(
-      IInitializableDebtToken.initialize.selector,
-      cachedPool,
-      input.asset,
-      input.incentivesController,
-      decimals,
-      input.name,
-      input.symbol,
-      input.params
-    );
+        IInitializableDebtToken.initialize.selector,
+        cachedPool,
+        input.asset,
+        input.incentivesController,
+        decimals,
+        input.name,
+        input.symbol,
+        input.params
+      );
 
     _upgradeTokenImplementation(
       reserveData.stableDebtTokenAddress,
@@ -201,7 +209,10 @@ contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigur
   /**
    * @dev Updates the variable debt token implementation for the asset
    **/
-  function updateVariableDebtToken(UpdateDebtTokenInput calldata input) external onlyPoolAdmin {
+  function updateVariableDebtToken(UpdateDebtTokenInput calldata input)
+    external
+    onlyPoolAdmin
+  {
     ILendingPool cachedPool = pool;
 
     DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(input.asset);
@@ -209,15 +220,15 @@ contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigur
     (, , , uint256 decimals, ) = cachedPool.getConfiguration(input.asset).getParamsMemory();
 
     bytes memory encodedCall = abi.encodeWithSelector(
-      IInitializableDebtToken.initialize.selector,
-      cachedPool,
-      input.asset,
-      input.incentivesController,
-      decimals,
-      input.name,
-      input.symbol,
-      input.params
-    );
+        IInitializableDebtToken.initialize.selector,
+        cachedPool,
+        input.asset,
+        input.incentivesController,
+        decimals,
+        input.name,
+        input.symbol,
+        input.params
+      );
 
     _upgradeTokenImplementation(
       reserveData.variableDebtTokenAddress,
@@ -237,10 +248,10 @@ contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigur
    * @param asset The address of the underlying asset of the reserve
    * @param stableBorrowRateEnabled True if stable borrow rate needs to be enabled by default on this reserve
    **/
-  function enableBorrowingOnReserve(
-    address asset,
-    bool stableBorrowRateEnabled
-  ) external onlyPoolAdmin {
+  function enableBorrowingOnReserve(address asset, bool stableBorrowRateEnabled)
+    external
+    onlyPoolAdmin
+  {
     DataTypes.ReserveConfigurationMap memory currentConfig = pool.getConfiguration(asset);
 
     currentConfig.setBorrowingEnabled(true);
@@ -424,10 +435,10 @@ contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigur
    * @param asset The address of the underlying asset of the reserve
    * @param rateStrategyAddress The new address of the interest strategy contract
    **/
-  function setReserveInterestRateStrategyAddress(
-    address asset,
-    address rateStrategyAddress
-  ) external onlyPoolAdmin {
+  function setReserveInterestRateStrategyAddress(address asset, address rateStrategyAddress)
+    external
+    onlyPoolAdmin
+  {
     pool.setReserveInterestRateStrategyAddress(asset, rateStrategyAddress);
     emit ReserveInterestRateStrategyChanged(asset, rateStrategyAddress);
   }
@@ -440,13 +451,12 @@ contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigur
     pool.setPause(val);
   }
 
-  function _initTokenWithProxy(
-    address implementation,
-    bytes memory initParams
-  ) internal returns (address) {
-    InitializableImmutableAdminUpgradeabilityProxy proxy = new InitializableImmutableAdminUpgradeabilityProxy(
-        address(this)
-      );
+  function _initTokenWithProxy(address implementation, bytes memory initParams)
+    internal
+    returns (address)
+  {
+    InitializableImmutableAdminUpgradeabilityProxy proxy =
+      new InitializableImmutableAdminUpgradeabilityProxy(address(this));
 
     proxy.initialize(implementation, initParams);
 
@@ -458,9 +468,8 @@ contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigur
     address implementation,
     bytes memory initParams
   ) internal {
-    InitializableImmutableAdminUpgradeabilityProxy proxy = InitializableImmutableAdminUpgradeabilityProxy(
-        payable(proxyAddress)
-      );
+    InitializableImmutableAdminUpgradeabilityProxy proxy =
+      InitializableImmutableAdminUpgradeabilityProxy(payable(proxyAddress));
 
     proxy.upgradeToAndCall(implementation, initParams);
   }
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol
index ac4d10d..78ad4cb 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol
@@ -60,10 +60,11 @@ contract BaseImmutableAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
    * It should include the signature and the parameters of the function to be called, as described in
    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
    */
-  function upgradeToAndCall(
-    address newImplementation,
-    bytes calldata data
-  ) external payable ifAdmin {
+  function upgradeToAndCall(address newImplementation, bytes calldata data)
+    external
+    payable
+    ifAdmin
+  {
     _upgradeTo(newImplementation);
     (bool success, ) = newImplementation.delegatecall(data);
     require(success);
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/ReserveConfiguration.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
index 3e853a9..5649a58 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
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
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/UserConfiguration.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/UserConfiguration.sol
index e957402..2994f05 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/UserConfiguration.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/configuration/UserConfiguration.sol
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
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Helpers.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Helpers.sol
index 8e92a56..b0117ef 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Helpers.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Helpers.sol
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
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/GenericLogic.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/GenericLogic.sol
index b93b69b..d4081dd 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/GenericLogic.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/GenericLogic.sol
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
 
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ReserveLogic.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ReserveLogic.sol
index cba1961..2b5b2cf 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ReserveLogic.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ReserveLogic.sol
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
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ValidationLogic.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ValidationLogic.sol
index 010c970..080b792 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ValidationLogic.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/logic/ValidationLogic.sol
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
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/math/MathUtils.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/math/MathUtils.sol
index 18d42a5..7078a82 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/math/MathUtils.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/math/MathUtils.sol
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
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/types/DataTypes.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/types/DataTypes.sol
index 25ef764..a19e5ef 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/types/DataTypes.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/types/DataTypes.sol
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
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/AToken.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/AToken.sol
index 73456cb..f278473 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/AToken.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/AToken.sol
@@ -42,7 +42,7 @@ contract AToken is
   address internal _underlyingAsset;
   IAaveIncentivesController internal _incentivesController;
 
-  modifier onlyLendingPool() {
+  modifier onlyLendingPool {
     require(_msgSender() == address(_pool), Errors.CT_CALLER_MUST_BE_LENDING_POOL);
     _;
   }
@@ -205,9 +205,12 @@ contract AToken is
    * @param user The user whose balance is calculated
    * @return The balance of the user
    **/
-  function balanceOf(
-    address user
-  ) public view override(IncentivizedERC20, IERC20) returns (uint256) {
+  function balanceOf(address user)
+    public
+    view
+    override(IncentivizedERC20, IERC20)
+    returns (uint256)
+  {
     return super.balanceOf(user).rayMul(_pool.getReserveNormalizedIncome(_underlyingAsset));
   }
 
@@ -227,9 +230,12 @@ contract AToken is
    * @return The scaled balance of the user
    * @return The scaled balance and the scaled total supply
    **/
-  function getScaledUserBalanceAndSupply(
-    address user
-  ) external view override returns (uint256, uint256) {
+  function getScaledUserBalanceAndSupply(address user)
+    external
+    view
+    override
+    returns (uint256, uint256)
+  {
     return (super.balanceOf(user), super.totalSupply());
   }
 
@@ -299,10 +305,12 @@ contract AToken is
    * @param amount The amount getting transferred
    * @return The amount transferred
    **/
-  function transferUnderlyingTo(
-    address target,
-    uint256 amount
-  ) external override onlyLendingPool returns (uint256) {
+  function transferUnderlyingTo(address target, uint256 amount)
+    external
+    override
+    onlyLendingPool
+    returns (uint256)
+  {
     IERC20(_underlyingAsset).safeTransfer(target, amount);
     return amount;
   }
@@ -338,13 +346,14 @@ contract AToken is
     //solium-disable-next-line
     require(block.timestamp <= deadline, 'INVALID_EXPIRATION');
     uint256 currentValidNonce = _nonces[owner];
-    bytes32 digest = keccak256(
-      abi.encodePacked(
-        '\x19\x01',
-        DOMAIN_SEPARATOR,
-        keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, currentValidNonce, deadline))
-      )
-    );
+    bytes32 digest =
+      keccak256(
+        abi.encodePacked(
+          '\x19\x01',
+          DOMAIN_SEPARATOR,
+          keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, currentValidNonce, deadline))
+        )
+      );
     require(owner == ecrecover(digest, v, r, s), 'INVALID_SIGNATURE');
     _nonces[owner] = currentValidNonce.add(1);
     _approve(owner, spender, value);
@@ -358,7 +367,12 @@ contract AToken is
    * @param amount The amount getting transferred
    * @param validate `true` if the transfer needs to be validated
    **/
-  function _transfer(address from, address to, uint256 amount, bool validate) internal {
+  function _transfer(
+    address from,
+    address to,
+    uint256 amount,
+    bool validate
+  ) internal {
     address underlyingAsset = _underlyingAsset;
     ILendingPool pool = _pool;
 
@@ -382,7 +396,11 @@ contract AToken is
    * @param to The destination address
    * @param amount The amount getting transferred
    **/
-  function _transfer(address from, address to, uint256 amount) internal override {
+  function _transfer(
+    address from,
+    address to,
+    uint256 amount
+  ) internal override {
     _transfer(from, to, amount, true);
   }
 }
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/DelegationAwareAToken.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/DelegationAwareAToken.sol
index d9591fa..443e10f 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/DelegationAwareAToken.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/DelegationAwareAToken.sol
@@ -12,7 +12,7 @@ import {AToken} from './AToken.sol';
  * @author Aave
  */
 contract DelegationAwareAToken is AToken {
-  modifier onlyPoolAdmin() {
+  modifier onlyPoolAdmin {
     require(
       _msgSender() == ILendingPool(_pool).getAddressesProvider().getPoolAdmin(),
       Errors.CALLER_NOT_POOL_ADMIN
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/IncentivizedERC20.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/IncentivizedERC20.sol
index 48d271b..fb83176 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/IncentivizedERC20.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/IncentivizedERC20.sol
@@ -23,7 +23,11 @@ abstract contract IncentivizedERC20 is Context, IERC20, IERC20Detailed {
   string private _symbol;
   uint8 private _decimals;
 
-  constructor(string memory name, string memory symbol, uint8 decimals) public {
+  constructor(
+    string memory name,
+    string memory symbol,
+    uint8 decimals
+  ) public {
     _name = name;
     _symbol = symbol;
     _decimals = decimals;
@@ -68,7 +72,7 @@ abstract contract IncentivizedERC20 is Context, IERC20, IERC20Detailed {
    * @return Abstract function implemented by the child aToken/debtToken. 
    * Done this way in order to not break compatibility with previous versions of aTokens/debtTokens
    **/
-  function _getIncentivesController() internal view virtual returns (IAaveIncentivesController);
+  function _getIncentivesController() internal view virtual returns(IAaveIncentivesController);
 
   /**
    * @dev Executes a transfer of tokens from _msgSender() to recipient
@@ -88,10 +92,13 @@ abstract contract IncentivizedERC20 is Context, IERC20, IERC20Detailed {
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
 
@@ -144,10 +151,11 @@ abstract contract IncentivizedERC20 is Context, IERC20, IERC20Detailed {
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
@@ -159,7 +167,11 @@ abstract contract IncentivizedERC20 is Context, IERC20, IERC20Detailed {
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
 
@@ -211,7 +223,11 @@ abstract contract IncentivizedERC20 is Context, IERC20, IERC20Detailed {
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
 
@@ -231,5 +247,9 @@ abstract contract IncentivizedERC20 is Context, IERC20, IERC20Detailed {
     _decimals = newDecimals;
   }
 
-  function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
+  function _beforeTokenTransfer(
+    address from,
+    address to,
+    uint256 amount
+  ) internal virtual {}
 }
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/StableDebtToken.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/StableDebtToken.sol
index 2b5c096..2212e9c 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/StableDebtToken.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/StableDebtToken.sol
@@ -109,10 +109,8 @@ contract StableDebtToken is IStableDebtToken, DebtTokenBase {
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
 
@@ -263,9 +261,15 @@ contract StableDebtToken is IStableDebtToken, DebtTokenBase {
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
@@ -285,7 +289,17 @@ contract StableDebtToken is IStableDebtToken, DebtTokenBase {
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
@@ -375,10 +389,8 @@ contract StableDebtToken is IStableDebtToken, DebtTokenBase {
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
@@ -389,7 +401,11 @@ contract StableDebtToken is IStableDebtToken, DebtTokenBase {
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
 
@@ -404,7 +420,11 @@ contract StableDebtToken is IStableDebtToken, DebtTokenBase {
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
 
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/VariableDebtToken.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/VariableDebtToken.sol
index 8f1ed63..a7a2817 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/VariableDebtToken.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/VariableDebtToken.sol
@@ -121,7 +121,11 @@ contract VariableDebtToken is DebtTokenBase, IVariableDebtToken {
    * @param amount The amount getting burned
    * @param index The variable debt index of the reserve
    **/
-  function burn(address user, uint256 amount, uint256 index) external override onlyLendingPool {
+  function burn(
+    address user,
+    uint256 amount,
+    uint256 index
+  ) external override onlyLendingPool {
     uint256 amountScaled = amount.rayDiv(index);
     require(amountScaled != 0, Errors.CT_INVALID_BURN_AMOUNT);
 
@@ -161,9 +165,12 @@ contract VariableDebtToken is DebtTokenBase, IVariableDebtToken {
    * @return The principal balance of the user
    * @return The principal total supply
    **/
-  function getScaledUserBalanceAndSupply(
-    address user
-  ) external view override returns (uint256, uint256) {
+  function getScaledUserBalanceAndSupply(address user)
+    external
+    view
+    override
+    returns (uint256, uint256)
+  {
     return (super.balanceOf(user), super.totalSupply());
   }
 
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/base/DebtTokenBase.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/base/DebtTokenBase.sol
index 0fb967c..4d75bc2 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/base/DebtTokenBase.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/tokenization/base/DebtTokenBase.sol
@@ -3,7 +3,9 @@ pragma solidity 0.6.12;
 
 import {ILendingPool} from '../../../interfaces/ILendingPool.sol';
 import {ICreditDelegationToken} from '../../../interfaces/ICreditDelegationToken.sol';
-import {VersionedInitializable} from '../../libraries/aave-upgradeability/VersionedInitializable.sol';
+import {
+  VersionedInitializable
+} from '../../libraries/aave-upgradeability/VersionedInitializable.sol';
 import {IncentivizedERC20} from '../IncentivizedERC20.sol';
 import {Errors} from '../../libraries/helpers/Errors.sol';
 
@@ -23,7 +25,7 @@ abstract contract DebtTokenBase is
   /**
    * @dev Only lending pool can call functions marked by this modifier
    **/
-  modifier onlyLendingPool() {
+  modifier onlyLendingPool {
     require(_msgSender() == address(_getLendingPool()), Errors.CT_CALLER_MUST_BE_LENDING_POOL);
     _;
   }
@@ -46,10 +48,12 @@ abstract contract DebtTokenBase is
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
 
@@ -63,10 +67,13 @@ abstract contract DebtTokenBase is
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
@@ -89,29 +96,35 @@ abstract contract DebtTokenBase is
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
 
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/hardhat/console.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/hardhat/console.sol
index e20b11a..d65e3b4 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/hardhat/console.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/hardhat/console.sol
@@ -1,1538 +1,1532 @@
 // SPDX-License-Identifier: MIT
-pragma solidity >=0.4.22 <0.9.0;
+pragma solidity >= 0.4.22 <0.9.0;
 
 library console {
-  address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
-
-  function _sendLogPayload(bytes memory payload) private view {
-    uint256 payloadLength = payload.length;
-    address consoleAddress = CONSOLE_ADDRESS;
-    assembly {
-      let payloadStart := add(payload, 32)
-      let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
-    }
-  }
+	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
+
+	function _sendLogPayload(bytes memory payload) private view {
+		uint256 payloadLength = payload.length;
+		address consoleAddress = CONSOLE_ADDRESS;
+		assembly {
+			let payloadStart := add(payload, 32)
+			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
+		}
+	}
 
-  function log() internal view {
-    _sendLogPayload(abi.encodeWithSignature('log()'));
-  }
+	function log() internal view {
+		_sendLogPayload(abi.encodeWithSignature("log()"));
+	}
 
-  function logInt(int p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(int)', p0));
-  }
+	function logInt(int p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
+	}
 
-  function logUint(uint p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint)', p0));
-  }
+	function logUint(uint p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
+	}
 
-  function logString(string memory p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string)', p0));
-  }
+	function logString(string memory p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
+	}
 
-  function logBool(bool p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool)', p0));
-  }
+	function logBool(bool p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
+	}
 
-  function logAddress(address p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address)', p0));
-  }
+	function logAddress(address p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
+	}
 
-  function logBytes(bytes memory p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes)', p0));
-  }
+	function logBytes(bytes memory p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
+	}
 
-  function logBytes1(bytes1 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes1)', p0));
-  }
+	function logBytes1(bytes1 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
+	}
 
-  function logBytes2(bytes2 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes2)', p0));
-  }
+	function logBytes2(bytes2 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
+	}
 
-  function logBytes3(bytes3 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes3)', p0));
-  }
+	function logBytes3(bytes3 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
+	}
 
-  function logBytes4(bytes4 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes4)', p0));
-  }
+	function logBytes4(bytes4 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
+	}
 
-  function logBytes5(bytes5 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes5)', p0));
-  }
+	function logBytes5(bytes5 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
+	}
 
-  function logBytes6(bytes6 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes6)', p0));
-  }
+	function logBytes6(bytes6 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
+	}
 
-  function logBytes7(bytes7 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes7)', p0));
-  }
+	function logBytes7(bytes7 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
+	}
 
-  function logBytes8(bytes8 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes8)', p0));
-  }
+	function logBytes8(bytes8 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
+	}
 
-  function logBytes9(bytes9 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes9)', p0));
-  }
+	function logBytes9(bytes9 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
+	}
 
-  function logBytes10(bytes10 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes10)', p0));
-  }
+	function logBytes10(bytes10 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
+	}
 
-  function logBytes11(bytes11 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes11)', p0));
-  }
+	function logBytes11(bytes11 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
+	}
 
-  function logBytes12(bytes12 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes12)', p0));
-  }
+	function logBytes12(bytes12 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
+	}
 
-  function logBytes13(bytes13 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes13)', p0));
-  }
+	function logBytes13(bytes13 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
+	}
 
-  function logBytes14(bytes14 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes14)', p0));
-  }
+	function logBytes14(bytes14 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
+	}
 
-  function logBytes15(bytes15 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes15)', p0));
-  }
+	function logBytes15(bytes15 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
+	}
 
-  function logBytes16(bytes16 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes16)', p0));
-  }
-
-  function logBytes17(bytes17 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes17)', p0));
-  }
+	function logBytes16(bytes16 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
+	}
+
+	function logBytes17(bytes17 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
+	}
 
-  function logBytes18(bytes18 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes18)', p0));
-  }
+	function logBytes18(bytes18 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
+	}
 
-  function logBytes19(bytes19 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes19)', p0));
-  }
+	function logBytes19(bytes19 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
+	}
 
-  function logBytes20(bytes20 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes20)', p0));
-  }
+	function logBytes20(bytes20 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
+	}
 
-  function logBytes21(bytes21 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes21)', p0));
-  }
+	function logBytes21(bytes21 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
+	}
 
-  function logBytes22(bytes22 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes22)', p0));
-  }
+	function logBytes22(bytes22 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
+	}
 
-  function logBytes23(bytes23 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes23)', p0));
-  }
+	function logBytes23(bytes23 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
+	}
 
-  function logBytes24(bytes24 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes24)', p0));
-  }
+	function logBytes24(bytes24 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
+	}
 
-  function logBytes25(bytes25 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes25)', p0));
-  }
+	function logBytes25(bytes25 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
+	}
 
-  function logBytes26(bytes26 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes26)', p0));
-  }
+	function logBytes26(bytes26 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
+	}
 
-  function logBytes27(bytes27 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes27)', p0));
-  }
+	function logBytes27(bytes27 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
+	}
 
-  function logBytes28(bytes28 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes28)', p0));
-  }
+	function logBytes28(bytes28 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
+	}
 
-  function logBytes29(bytes29 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes29)', p0));
-  }
+	function logBytes29(bytes29 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
+	}
 
-  function logBytes30(bytes30 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes30)', p0));
-  }
+	function logBytes30(bytes30 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
+	}
 
-  function logBytes31(bytes31 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes31)', p0));
-  }
+	function logBytes31(bytes31 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
+	}
 
-  function logBytes32(bytes32 p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bytes32)', p0));
-  }
+	function logBytes32(bytes32 p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
+	}
 
-  function log(uint p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint)', p0));
-  }
+	function log(uint p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
+	}
 
-  function log(string memory p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string)', p0));
-  }
+	function log(string memory p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
+	}
 
-  function log(bool p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool)', p0));
-  }
+	function log(bool p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
+	}
 
-  function log(address p0) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address)', p0));
-  }
+	function log(address p0) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
+	}
 
-  function log(uint p0, uint p1) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint)', p0, p1));
-  }
+	function log(uint p0, uint p1) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
+	}
 
-  function log(uint p0, string memory p1) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string)', p0, p1));
-  }
+	function log(uint p0, string memory p1) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
+	}
 
-  function log(uint p0, bool p1) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool)', p0, p1));
-  }
+	function log(uint p0, bool p1) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
+	}
 
-  function log(uint p0, address p1) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address)', p0, p1));
-  }
+	function log(uint p0, address p1) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
+	}
 
-  function log(string memory p0, uint p1) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint)', p0, p1));
-  }
+	function log(string memory p0, uint p1) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
+	}
 
-  function log(string memory p0, string memory p1) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string)', p0, p1));
-  }
+	function log(string memory p0, string memory p1) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
+	}
 
-  function log(string memory p0, bool p1) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool)', p0, p1));
-  }
+	function log(string memory p0, bool p1) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
+	}
 
-  function log(string memory p0, address p1) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address)', p0, p1));
-  }
+	function log(string memory p0, address p1) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
+	}
 
-  function log(bool p0, uint p1) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint)', p0, p1));
-  }
+	function log(bool p0, uint p1) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
+	}
 
-  function log(bool p0, string memory p1) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string)', p0, p1));
-  }
+	function log(bool p0, string memory p1) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
+	}
 
-  function log(bool p0, bool p1) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool)', p0, p1));
-  }
+	function log(bool p0, bool p1) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
+	}
 
-  function log(bool p0, address p1) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address)', p0, p1));
-  }
+	function log(bool p0, address p1) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
+	}
 
-  function log(address p0, uint p1) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint)', p0, p1));
-  }
+	function log(address p0, uint p1) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
+	}
 
-  function log(address p0, string memory p1) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string)', p0, p1));
-  }
+	function log(address p0, string memory p1) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
+	}
 
-  function log(address p0, bool p1) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool)', p0, p1));
-  }
+	function log(address p0, bool p1) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
+	}
 
-  function log(address p0, address p1) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address)', p0, p1));
-  }
+	function log(address p0, address p1) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
+	}
 
-  function log(uint p0, uint p1, uint p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,uint)', p0, p1, p2));
-  }
+	function log(uint p0, uint p1, uint p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
+	}
 
-  function log(uint p0, uint p1, string memory p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,string)', p0, p1, p2));
-  }
+	function log(uint p0, uint p1, string memory p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
+	}
 
-  function log(uint p0, uint p1, bool p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,bool)', p0, p1, p2));
-  }
+	function log(uint p0, uint p1, bool p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
+	}
 
-  function log(uint p0, uint p1, address p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,address)', p0, p1, p2));
-  }
+	function log(uint p0, uint p1, address p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
+	}
 
-  function log(uint p0, string memory p1, uint p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,uint)', p0, p1, p2));
-  }
+	function log(uint p0, string memory p1, uint p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
+	}
 
-  function log(uint p0, string memory p1, string memory p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,string)', p0, p1, p2));
-  }
+	function log(uint p0, string memory p1, string memory p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
+	}
 
-  function log(uint p0, string memory p1, bool p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,bool)', p0, p1, p2));
-  }
+	function log(uint p0, string memory p1, bool p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
+	}
 
-  function log(uint p0, string memory p1, address p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,address)', p0, p1, p2));
-  }
+	function log(uint p0, string memory p1, address p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
+	}
 
-  function log(uint p0, bool p1, uint p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,uint)', p0, p1, p2));
-  }
+	function log(uint p0, bool p1, uint p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
+	}
 
-  function log(uint p0, bool p1, string memory p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,string)', p0, p1, p2));
-  }
+	function log(uint p0, bool p1, string memory p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
+	}
 
-  function log(uint p0, bool p1, bool p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,bool)', p0, p1, p2));
-  }
+	function log(uint p0, bool p1, bool p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
+	}
 
-  function log(uint p0, bool p1, address p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,address)', p0, p1, p2));
-  }
+	function log(uint p0, bool p1, address p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
+	}
 
-  function log(uint p0, address p1, uint p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,uint)', p0, p1, p2));
-  }
+	function log(uint p0, address p1, uint p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
+	}
 
-  function log(uint p0, address p1, string memory p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,string)', p0, p1, p2));
-  }
+	function log(uint p0, address p1, string memory p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
+	}
 
-  function log(uint p0, address p1, bool p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,bool)', p0, p1, p2));
-  }
+	function log(uint p0, address p1, bool p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
+	}
 
-  function log(uint p0, address p1, address p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,address)', p0, p1, p2));
-  }
+	function log(uint p0, address p1, address p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
+	}
 
-  function log(string memory p0, uint p1, uint p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,uint)', p0, p1, p2));
-  }
+	function log(string memory p0, uint p1, uint p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
+	}
 
-  function log(string memory p0, uint p1, string memory p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,string)', p0, p1, p2));
-  }
+	function log(string memory p0, uint p1, string memory p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
+	}
 
-  function log(string memory p0, uint p1, bool p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,bool)', p0, p1, p2));
-  }
+	function log(string memory p0, uint p1, bool p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
+	}
 
-  function log(string memory p0, uint p1, address p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,address)', p0, p1, p2));
-  }
+	function log(string memory p0, uint p1, address p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
+	}
 
-  function log(string memory p0, string memory p1, uint p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,uint)', p0, p1, p2));
-  }
+	function log(string memory p0, string memory p1, uint p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
+	}
 
-  function log(string memory p0, string memory p1, string memory p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,string)', p0, p1, p2));
-  }
+	function log(string memory p0, string memory p1, string memory p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
+	}
 
-  function log(string memory p0, string memory p1, bool p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,bool)', p0, p1, p2));
-  }
+	function log(string memory p0, string memory p1, bool p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
+	}
 
-  function log(string memory p0, string memory p1, address p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,address)', p0, p1, p2));
-  }
+	function log(string memory p0, string memory p1, address p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
+	}
 
-  function log(string memory p0, bool p1, uint p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,uint)', p0, p1, p2));
-  }
+	function log(string memory p0, bool p1, uint p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
+	}
 
-  function log(string memory p0, bool p1, string memory p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,string)', p0, p1, p2));
-  }
+	function log(string memory p0, bool p1, string memory p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
+	}
 
-  function log(string memory p0, bool p1, bool p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,bool)', p0, p1, p2));
-  }
+	function log(string memory p0, bool p1, bool p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
+	}
 
-  function log(string memory p0, bool p1, address p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,address)', p0, p1, p2));
-  }
+	function log(string memory p0, bool p1, address p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
+	}
 
-  function log(string memory p0, address p1, uint p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,uint)', p0, p1, p2));
-  }
+	function log(string memory p0, address p1, uint p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
+	}
 
-  function log(string memory p0, address p1, string memory p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,string)', p0, p1, p2));
-  }
+	function log(string memory p0, address p1, string memory p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
+	}
 
-  function log(string memory p0, address p1, bool p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,bool)', p0, p1, p2));
-  }
+	function log(string memory p0, address p1, bool p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
+	}
 
-  function log(string memory p0, address p1, address p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,address)', p0, p1, p2));
-  }
+	function log(string memory p0, address p1, address p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
+	}
 
-  function log(bool p0, uint p1, uint p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,uint)', p0, p1, p2));
-  }
+	function log(bool p0, uint p1, uint p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
+	}
 
-  function log(bool p0, uint p1, string memory p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,string)', p0, p1, p2));
-  }
+	function log(bool p0, uint p1, string memory p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
+	}
 
-  function log(bool p0, uint p1, bool p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,bool)', p0, p1, p2));
-  }
+	function log(bool p0, uint p1, bool p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
+	}
 
-  function log(bool p0, uint p1, address p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,address)', p0, p1, p2));
-  }
+	function log(bool p0, uint p1, address p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
+	}
 
-  function log(bool p0, string memory p1, uint p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,uint)', p0, p1, p2));
-  }
+	function log(bool p0, string memory p1, uint p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
+	}
 
-  function log(bool p0, string memory p1, string memory p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,string)', p0, p1, p2));
-  }
+	function log(bool p0, string memory p1, string memory p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
+	}
 
-  function log(bool p0, string memory p1, bool p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,bool)', p0, p1, p2));
-  }
+	function log(bool p0, string memory p1, bool p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
+	}
 
-  function log(bool p0, string memory p1, address p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,address)', p0, p1, p2));
-  }
+	function log(bool p0, string memory p1, address p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
+	}
 
-  function log(bool p0, bool p1, uint p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,uint)', p0, p1, p2));
-  }
+	function log(bool p0, bool p1, uint p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
+	}
 
-  function log(bool p0, bool p1, string memory p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,string)', p0, p1, p2));
-  }
+	function log(bool p0, bool p1, string memory p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
+	}
 
-  function log(bool p0, bool p1, bool p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,bool)', p0, p1, p2));
-  }
+	function log(bool p0, bool p1, bool p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
+	}
 
-  function log(bool p0, bool p1, address p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,address)', p0, p1, p2));
-  }
+	function log(bool p0, bool p1, address p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
+	}
 
-  function log(bool p0, address p1, uint p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,uint)', p0, p1, p2));
-  }
+	function log(bool p0, address p1, uint p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
+	}
 
-  function log(bool p0, address p1, string memory p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,string)', p0, p1, p2));
-  }
+	function log(bool p0, address p1, string memory p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
+	}
 
-  function log(bool p0, address p1, bool p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,bool)', p0, p1, p2));
-  }
+	function log(bool p0, address p1, bool p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
+	}
 
-  function log(bool p0, address p1, address p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,address)', p0, p1, p2));
-  }
+	function log(bool p0, address p1, address p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
+	}
 
-  function log(address p0, uint p1, uint p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,uint)', p0, p1, p2));
-  }
+	function log(address p0, uint p1, uint p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
+	}
 
-  function log(address p0, uint p1, string memory p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,string)', p0, p1, p2));
-  }
+	function log(address p0, uint p1, string memory p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
+	}
 
-  function log(address p0, uint p1, bool p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,bool)', p0, p1, p2));
-  }
+	function log(address p0, uint p1, bool p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
+	}
 
-  function log(address p0, uint p1, address p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,address)', p0, p1, p2));
-  }
+	function log(address p0, uint p1, address p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
+	}
 
-  function log(address p0, string memory p1, uint p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,uint)', p0, p1, p2));
-  }
+	function log(address p0, string memory p1, uint p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
+	}
 
-  function log(address p0, string memory p1, string memory p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,string)', p0, p1, p2));
-  }
+	function log(address p0, string memory p1, string memory p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
+	}
 
-  function log(address p0, string memory p1, bool p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,bool)', p0, p1, p2));
-  }
+	function log(address p0, string memory p1, bool p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
+	}
 
-  function log(address p0, string memory p1, address p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,address)', p0, p1, p2));
-  }
+	function log(address p0, string memory p1, address p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
+	}
 
-  function log(address p0, bool p1, uint p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,uint)', p0, p1, p2));
-  }
+	function log(address p0, bool p1, uint p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
+	}
 
-  function log(address p0, bool p1, string memory p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,string)', p0, p1, p2));
-  }
+	function log(address p0, bool p1, string memory p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
+	}
 
-  function log(address p0, bool p1, bool p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,bool)', p0, p1, p2));
-  }
+	function log(address p0, bool p1, bool p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
+	}
 
-  function log(address p0, bool p1, address p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,address)', p0, p1, p2));
-  }
+	function log(address p0, bool p1, address p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
+	}
 
-  function log(address p0, address p1, uint p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,uint)', p0, p1, p2));
-  }
+	function log(address p0, address p1, uint p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
+	}
 
-  function log(address p0, address p1, string memory p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,string)', p0, p1, p2));
-  }
+	function log(address p0, address p1, string memory p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
+	}
 
-  function log(address p0, address p1, bool p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,bool)', p0, p1, p2));
-  }
+	function log(address p0, address p1, bool p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
+	}
 
-  function log(address p0, address p1, address p2) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,address)', p0, p1, p2));
-  }
+	function log(address p0, address p1, address p2) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
+	}
 
-  function log(uint p0, uint p1, uint p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,uint,uint)', p0, p1, p2, p3));
-  }
+	function log(uint p0, uint p1, uint p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, uint p1, uint p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,uint,string)', p0, p1, p2, p3));
-  }
+	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, uint p1, uint p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,uint,bool)', p0, p1, p2, p3));
-  }
+	function log(uint p0, uint p1, uint p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, uint p1, uint p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,uint,address)', p0, p1, p2, p3));
-  }
+	function log(uint p0, uint p1, uint p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, uint p1, string memory p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,string,uint)', p0, p1, p2, p3));
-  }
+	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,string,string)', p0, p1, p2, p3));
-  }
+	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, uint p1, string memory p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,string,bool)', p0, p1, p2, p3));
-  }
+	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, uint p1, string memory p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,string,address)', p0, p1, p2, p3));
-  }
+	function log(uint p0, uint p1, string memory p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, uint p1, bool p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,bool,uint)', p0, p1, p2, p3));
-  }
+	function log(uint p0, uint p1, bool p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, uint p1, bool p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,bool,string)', p0, p1, p2, p3));
-  }
+	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, uint p1, bool p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,bool,bool)', p0, p1, p2, p3));
-  }
+	function log(uint p0, uint p1, bool p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, uint p1, bool p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,bool,address)', p0, p1, p2, p3));
-  }
+	function log(uint p0, uint p1, bool p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, uint p1, address p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,address,uint)', p0, p1, p2, p3));
-  }
+	function log(uint p0, uint p1, address p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, uint p1, address p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,address,string)', p0, p1, p2, p3));
-  }
+	function log(uint p0, uint p1, address p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, uint p1, address p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,address,bool)', p0, p1, p2, p3));
-  }
+	function log(uint p0, uint p1, address p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, uint p1, address p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,address,address)', p0, p1, p2, p3));
-  }
+	function log(uint p0, uint p1, address p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, string memory p1, uint p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,uint,uint)', p0, p1, p2, p3));
-  }
+	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,uint,string)', p0, p1, p2, p3));
-  }
+	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, string memory p1, uint p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,uint,bool)', p0, p1, p2, p3));
-  }
+	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, string memory p1, uint p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,uint,address)', p0, p1, p2, p3));
-  }
+	function log(uint p0, string memory p1, uint p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,string,uint)', p0, p1, p2, p3));
-  }
+	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,string,string)', p0, p1, p2, p3));
-  }
+	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,string,bool)', p0, p1, p2, p3));
-  }
+	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, string memory p1, string memory p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,string,address)', p0, p1, p2, p3));
-  }
+	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, string memory p1, bool p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,bool,uint)', p0, p1, p2, p3));
-  }
+	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,bool,string)', p0, p1, p2, p3));
-  }
+	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, string memory p1, bool p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,bool,bool)', p0, p1, p2, p3));
-  }
+	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, string memory p1, bool p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,bool,address)', p0, p1, p2, p3));
-  }
+	function log(uint p0, string memory p1, bool p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, string memory p1, address p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,address,uint)', p0, p1, p2, p3));
-  }
+	function log(uint p0, string memory p1, address p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, string memory p1, address p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,address,string)', p0, p1, p2, p3));
-  }
+	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, string memory p1, address p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,address,bool)', p0, p1, p2, p3));
-  }
+	function log(uint p0, string memory p1, address p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, string memory p1, address p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,string,address,address)', p0, p1, p2, p3));
-  }
+	function log(uint p0, string memory p1, address p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, bool p1, uint p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,uint,uint)', p0, p1, p2, p3));
-  }
+	function log(uint p0, bool p1, uint p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, bool p1, uint p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,uint,string)', p0, p1, p2, p3));
-  }
+	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, bool p1, uint p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,uint,bool)', p0, p1, p2, p3));
-  }
+	function log(uint p0, bool p1, uint p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, bool p1, uint p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,uint,address)', p0, p1, p2, p3));
-  }
+	function log(uint p0, bool p1, uint p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, bool p1, string memory p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,string,uint)', p0, p1, p2, p3));
-  }
+	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,string,string)', p0, p1, p2, p3));
-  }
+	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, bool p1, string memory p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,string,bool)', p0, p1, p2, p3));
-  }
+	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, bool p1, string memory p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,string,address)', p0, p1, p2, p3));
-  }
+	function log(uint p0, bool p1, string memory p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, bool p1, bool p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,bool,uint)', p0, p1, p2, p3));
-  }
+	function log(uint p0, bool p1, bool p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, bool p1, bool p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,bool,string)', p0, p1, p2, p3));
-  }
+	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, bool p1, bool p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,bool,bool)', p0, p1, p2, p3));
-  }
+	function log(uint p0, bool p1, bool p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, bool p1, bool p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,bool,address)', p0, p1, p2, p3));
-  }
+	function log(uint p0, bool p1, bool p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, bool p1, address p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,address,uint)', p0, p1, p2, p3));
-  }
+	function log(uint p0, bool p1, address p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, bool p1, address p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,address,string)', p0, p1, p2, p3));
-  }
+	function log(uint p0, bool p1, address p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, bool p1, address p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,address,bool)', p0, p1, p2, p3));
-  }
+	function log(uint p0, bool p1, address p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, bool p1, address p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,address,address)', p0, p1, p2, p3));
-  }
+	function log(uint p0, bool p1, address p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, address p1, uint p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,uint,uint)', p0, p1, p2, p3));
-  }
+	function log(uint p0, address p1, uint p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, address p1, uint p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,uint,string)', p0, p1, p2, p3));
-  }
+	function log(uint p0, address p1, uint p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, address p1, uint p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,uint,bool)', p0, p1, p2, p3));
-  }
+	function log(uint p0, address p1, uint p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, address p1, uint p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,uint,address)', p0, p1, p2, p3));
-  }
+	function log(uint p0, address p1, uint p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, address p1, string memory p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,string,uint)', p0, p1, p2, p3));
-  }
+	function log(uint p0, address p1, string memory p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, address p1, string memory p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,string,string)', p0, p1, p2, p3));
-  }
+	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, address p1, string memory p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,string,bool)', p0, p1, p2, p3));
-  }
+	function log(uint p0, address p1, string memory p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, address p1, string memory p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,string,address)', p0, p1, p2, p3));
-  }
+	function log(uint p0, address p1, string memory p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, address p1, bool p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,bool,uint)', p0, p1, p2, p3));
-  }
+	function log(uint p0, address p1, bool p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, address p1, bool p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,bool,string)', p0, p1, p2, p3));
-  }
+	function log(uint p0, address p1, bool p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, address p1, bool p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,bool,bool)', p0, p1, p2, p3));
-  }
+	function log(uint p0, address p1, bool p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, address p1, bool p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,bool,address)', p0, p1, p2, p3));
-  }
+	function log(uint p0, address p1, bool p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, address p1, address p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,address,uint)', p0, p1, p2, p3));
-  }
+	function log(uint p0, address p1, address p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
+	}
 
-  function log(uint p0, address p1, address p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,address,string)', p0, p1, p2, p3));
-  }
-
-  function log(uint p0, address p1, address p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,address,bool)', p0, p1, p2, p3));
-  }
-
-  function log(uint p0, address p1, address p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(uint,address,address,address)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, uint p1, uint p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,uint,uint)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,uint,string)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, uint p1, uint p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,uint,bool)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, uint p1, uint p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,uint,address)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,string,uint)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,string,string)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,string,bool)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, uint p1, string memory p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,string,address)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, uint p1, bool p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,bool,uint)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,bool,string)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, uint p1, bool p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,bool,bool)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, uint p1, bool p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,bool,address)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, uint p1, address p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,address,uint)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, uint p1, address p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,address,string)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, uint p1, address p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,address,bool)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, uint p1, address p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,uint,address,address)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,uint,uint)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,uint,string)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,uint,bool)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, string memory p1, uint p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,uint,address)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,string,uint)', p0, p1, p2, p3));
-  }
-
-  function log(
-    string memory p0,
-    string memory p1,
-    string memory p2,
-    string memory p3
-  ) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,string,string)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,string,bool)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,string,address)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,bool,uint)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,bool,string)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,bool,bool)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, string memory p1, bool p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,bool,address)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, string memory p1, address p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,address,uint)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,address,string)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, string memory p1, address p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,address,bool)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, string memory p1, address p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,string,address,address)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, bool p1, uint p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,uint,uint)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,uint,string)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, bool p1, uint p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,uint,bool)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, bool p1, uint p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,uint,address)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,string,uint)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,string,string)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,string,bool)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, bool p1, string memory p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,string,address)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, bool p1, bool p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,bool,uint)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,bool,string)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, bool p1, bool p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,bool,bool)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, bool p1, bool p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,bool,address)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, bool p1, address p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,address,uint)', p0, p1, p2, p3));
-  }
-
-  function log(string memory p0, bool p1, address p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,address,string)', p0, p1, p2, p3));
-  }
+	function log(uint p0, address p1, address p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, bool p1, address p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,address,bool)', p0, p1, p2, p3));
-  }
+	function log(uint p0, address p1, address p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, bool p1, address p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,bool,address,address)', p0, p1, p2, p3));
-  }
+	function log(uint p0, address p1, address p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, address p1, uint p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,uint,uint)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, address p1, uint p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,uint,string)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, address p1, uint p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,uint,bool)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, address p1, uint p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,uint,address)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, uint p1, uint p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, address p1, string memory p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,string,uint)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,string,string)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, address p1, string memory p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,string,bool)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, address p1, string memory p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,string,address)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, address p1, bool p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,bool,uint)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, address p1, bool p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,bool,string)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, address p1, bool p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,bool,bool)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, address p1, bool p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,bool,address)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, uint p1, bool p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, address p1, address p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,address,uint)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, uint p1, address p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, address p1, address p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,address,string)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, address p1, address p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,address,bool)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, uint p1, address p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
+	}
 
-  function log(string memory p0, address p1, address p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(string,address,address,address)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, uint p1, address p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, uint p1, uint p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,uint,uint)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, uint p1, uint p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,uint,string)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, uint p1, uint p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,uint,bool)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, uint p1, uint p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,uint,address)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, uint p1, string memory p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,string,uint)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,string,string)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, uint p1, string memory p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,string,bool)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, uint p1, string memory p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,string,address)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, uint p1, bool p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,bool,uint)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, uint p1, bool p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,bool,string)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, uint p1, bool p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,bool,bool)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, uint p1, bool p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,bool,address)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, uint p1, address p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,address,uint)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, uint p1, address p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,address,string)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, uint p1, address p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,address,bool)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, uint p1, address p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,address,address)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, string memory p1, address p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, string memory p1, uint p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,uint,uint)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,uint,string)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, string memory p1, uint p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,uint,bool)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, string memory p1, uint p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,uint,address)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, bool p1, uint p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,string,uint)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,string,string)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,string,bool)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, string memory p1, string memory p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,string,address)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, string memory p1, bool p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,bool,uint)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,bool,string)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, string memory p1, bool p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,bool,bool)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, string memory p1, bool p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,bool,address)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, bool p1, bool p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, string memory p1, address p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,address,uint)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, bool p1, address p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, string memory p1, address p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,address,string)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, string memory p1, address p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,address,bool)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, bool p1, address p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, string memory p1, address p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,string,address,address)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, bool p1, address p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, bool p1, uint p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,uint,uint)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, address p1, uint p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, bool p1, uint p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,uint,string)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, bool p1, uint p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,uint,bool)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, address p1, uint p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, bool p1, uint p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,uint,address)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, address p1, uint p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, bool p1, string memory p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,string,uint)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,string,string)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, bool p1, string memory p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,string,bool)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, bool p1, string memory p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,string,address)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, address p1, string memory p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, bool p1, bool p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,bool,uint)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, address p1, bool p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, bool p1, bool p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,bool,string)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, bool p1, bool p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,bool,bool)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, address p1, bool p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, bool p1, bool p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,bool,address)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, address p1, bool p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, bool p1, address p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,address,uint)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, address p1, address p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, bool p1, address p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,address,string)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, address p1, address p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, bool p1, address p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,address,bool)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, address p1, address p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, bool p1, address p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,address,address)', p0, p1, p2, p3));
-  }
+	function log(string memory p0, address p1, address p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, address p1, uint p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,uint,uint)', p0, p1, p2, p3));
-  }
+	function log(bool p0, uint p1, uint p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, address p1, uint p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,uint,string)', p0, p1, p2, p3));
-  }
+	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, address p1, uint p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,uint,bool)', p0, p1, p2, p3));
-  }
+	function log(bool p0, uint p1, uint p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, address p1, uint p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,uint,address)', p0, p1, p2, p3));
-  }
+	function log(bool p0, uint p1, uint p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, address p1, string memory p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,string,uint)', p0, p1, p2, p3));
-  }
+	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, address p1, string memory p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,string,string)', p0, p1, p2, p3));
-  }
+	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, address p1, string memory p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,string,bool)', p0, p1, p2, p3));
-  }
+	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, address p1, string memory p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,string,address)', p0, p1, p2, p3));
-  }
+	function log(bool p0, uint p1, string memory p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, address p1, bool p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,bool,uint)', p0, p1, p2, p3));
-  }
+	function log(bool p0, uint p1, bool p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, address p1, bool p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,bool,string)', p0, p1, p2, p3));
-  }
+	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, address p1, bool p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,bool,bool)', p0, p1, p2, p3));
-  }
+	function log(bool p0, uint p1, bool p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, address p1, bool p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,bool,address)', p0, p1, p2, p3));
-  }
+	function log(bool p0, uint p1, bool p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, address p1, address p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,address,uint)', p0, p1, p2, p3));
-  }
+	function log(bool p0, uint p1, address p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, address p1, address p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,address,string)', p0, p1, p2, p3));
-  }
+	function log(bool p0, uint p1, address p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, address p1, address p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,address,bool)', p0, p1, p2, p3));
-  }
+	function log(bool p0, uint p1, address p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
+	}
 
-  function log(bool p0, address p1, address p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(bool,address,address,address)', p0, p1, p2, p3));
-  }
+	function log(bool p0, uint p1, address p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, uint p1, uint p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,uint,uint)', p0, p1, p2, p3));
-  }
+	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, uint p1, uint p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,uint,string)', p0, p1, p2, p3));
-  }
+	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, uint p1, uint p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,uint,bool)', p0, p1, p2, p3));
-  }
+	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, uint p1, uint p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,uint,address)', p0, p1, p2, p3));
-  }
+	function log(bool p0, string memory p1, uint p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, uint p1, string memory p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,string,uint)', p0, p1, p2, p3));
-  }
+	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, uint p1, string memory p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,string,string)', p0, p1, p2, p3));
-  }
+	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, uint p1, string memory p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,string,bool)', p0, p1, p2, p3));
-  }
+	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, uint p1, string memory p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,string,address)', p0, p1, p2, p3));
-  }
+	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, uint p1, bool p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,bool,uint)', p0, p1, p2, p3));
-  }
+	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, uint p1, bool p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,bool,string)', p0, p1, p2, p3));
-  }
+	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, uint p1, bool p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,bool,bool)', p0, p1, p2, p3));
-  }
+	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, uint p1, bool p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,bool,address)', p0, p1, p2, p3));
-  }
+	function log(bool p0, string memory p1, bool p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, uint p1, address p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,address,uint)', p0, p1, p2, p3));
-  }
+	function log(bool p0, string memory p1, address p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, uint p1, address p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,address,string)', p0, p1, p2, p3));
-  }
+	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, uint p1, address p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,address,bool)', p0, p1, p2, p3));
-  }
+	function log(bool p0, string memory p1, address p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, uint p1, address p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,uint,address,address)', p0, p1, p2, p3));
-  }
+	function log(bool p0, string memory p1, address p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, string memory p1, uint p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,uint,uint)', p0, p1, p2, p3));
-  }
+	function log(bool p0, bool p1, uint p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, string memory p1, uint p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,uint,string)', p0, p1, p2, p3));
-  }
+	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, string memory p1, uint p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,uint,bool)', p0, p1, p2, p3));
-  }
+	function log(bool p0, bool p1, uint p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, string memory p1, uint p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,uint,address)', p0, p1, p2, p3));
-  }
+	function log(bool p0, bool p1, uint p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, string memory p1, string memory p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,string,uint)', p0, p1, p2, p3));
-  }
+	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,string,string)', p0, p1, p2, p3));
-  }
+	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, string memory p1, string memory p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,string,bool)', p0, p1, p2, p3));
-  }
+	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, string memory p1, string memory p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,string,address)', p0, p1, p2, p3));
-  }
+	function log(bool p0, bool p1, string memory p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, string memory p1, bool p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,bool,uint)', p0, p1, p2, p3));
-  }
+	function log(bool p0, bool p1, bool p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, string memory p1, bool p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,bool,string)', p0, p1, p2, p3));
-  }
+	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, string memory p1, bool p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,bool,bool)', p0, p1, p2, p3));
-  }
+	function log(bool p0, bool p1, bool p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, string memory p1, bool p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,bool,address)', p0, p1, p2, p3));
-  }
+	function log(bool p0, bool p1, bool p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, string memory p1, address p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,address,uint)', p0, p1, p2, p3));
-  }
+	function log(bool p0, bool p1, address p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, string memory p1, address p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,address,string)', p0, p1, p2, p3));
-  }
+	function log(bool p0, bool p1, address p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, string memory p1, address p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,address,bool)', p0, p1, p2, p3));
-  }
+	function log(bool p0, bool p1, address p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, string memory p1, address p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,string,address,address)', p0, p1, p2, p3));
-  }
+	function log(bool p0, bool p1, address p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, bool p1, uint p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,uint,uint)', p0, p1, p2, p3));
-  }
+	function log(bool p0, address p1, uint p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, bool p1, uint p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,uint,string)', p0, p1, p2, p3));
-  }
+	function log(bool p0, address p1, uint p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, bool p1, uint p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,uint,bool)', p0, p1, p2, p3));
-  }
+	function log(bool p0, address p1, uint p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, bool p1, uint p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,uint,address)', p0, p1, p2, p3));
-  }
+	function log(bool p0, address p1, uint p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, bool p1, string memory p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,string,uint)', p0, p1, p2, p3));
-  }
+	function log(bool p0, address p1, string memory p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, bool p1, string memory p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,string,string)', p0, p1, p2, p3));
-  }
+	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, bool p1, string memory p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,string,bool)', p0, p1, p2, p3));
-  }
+	function log(bool p0, address p1, string memory p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, bool p1, string memory p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,string,address)', p0, p1, p2, p3));
-  }
+	function log(bool p0, address p1, string memory p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, bool p1, bool p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,bool,uint)', p0, p1, p2, p3));
-  }
+	function log(bool p0, address p1, bool p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, bool p1, bool p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,bool,string)', p0, p1, p2, p3));
-  }
+	function log(bool p0, address p1, bool p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, bool p1, bool p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,bool,bool)', p0, p1, p2, p3));
-  }
+	function log(bool p0, address p1, bool p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, bool p1, bool p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,bool,address)', p0, p1, p2, p3));
-  }
+	function log(bool p0, address p1, bool p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, bool p1, address p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,address,uint)', p0, p1, p2, p3));
-  }
+	function log(bool p0, address p1, address p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, bool p1, address p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,address,string)', p0, p1, p2, p3));
-  }
+	function log(bool p0, address p1, address p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, bool p1, address p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,address,bool)', p0, p1, p2, p3));
-  }
+	function log(bool p0, address p1, address p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, bool p1, address p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,bool,address,address)', p0, p1, p2, p3));
-  }
+	function log(bool p0, address p1, address p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, address p1, uint p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,uint,uint)', p0, p1, p2, p3));
-  }
+	function log(address p0, uint p1, uint p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, address p1, uint p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,uint,string)', p0, p1, p2, p3));
-  }
+	function log(address p0, uint p1, uint p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, address p1, uint p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,uint,bool)', p0, p1, p2, p3));
-  }
+	function log(address p0, uint p1, uint p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, address p1, uint p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,uint,address)', p0, p1, p2, p3));
-  }
+	function log(address p0, uint p1, uint p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, address p1, string memory p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,string,uint)', p0, p1, p2, p3));
-  }
+	function log(address p0, uint p1, string memory p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, address p1, string memory p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,string,string)', p0, p1, p2, p3));
-  }
+	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, address p1, string memory p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,string,bool)', p0, p1, p2, p3));
-  }
+	function log(address p0, uint p1, string memory p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, address p1, string memory p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,string,address)', p0, p1, p2, p3));
-  }
+	function log(address p0, uint p1, string memory p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, address p1, bool p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,bool,uint)', p0, p1, p2, p3));
-  }
+	function log(address p0, uint p1, bool p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, address p1, bool p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,bool,string)', p0, p1, p2, p3));
-  }
+	function log(address p0, uint p1, bool p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, address p1, bool p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,bool,bool)', p0, p1, p2, p3));
-  }
+	function log(address p0, uint p1, bool p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, address p1, bool p2, address p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,bool,address)', p0, p1, p2, p3));
-  }
+	function log(address p0, uint p1, bool p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, address p1, address p2, uint p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,address,uint)', p0, p1, p2, p3));
-  }
+	function log(address p0, uint p1, address p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, address p1, address p2, string memory p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,address,string)', p0, p1, p2, p3));
-  }
+	function log(address p0, uint p1, address p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, address p1, address p2, bool p3) internal view {
-    _sendLogPayload(abi.encodeWithSignature('log(address,address,address,bool)', p0, p1, p2, p3));
-  }
+	function log(address p0, uint p1, address p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, uint p1, address p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, string memory p1, uint p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, string memory p1, uint p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, string memory p1, uint p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, string memory p1, string memory p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, string memory p1, bool p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, string memory p1, bool p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, string memory p1, bool p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, string memory p1, address p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, string memory p1, address p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, string memory p1, address p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, string memory p1, address p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, bool p1, uint p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, bool p1, uint p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, bool p1, uint p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, bool p1, uint p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, bool p1, string memory p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, bool p1, string memory p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, bool p1, string memory p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, bool p1, bool p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, bool p1, bool p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, bool p1, bool p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, bool p1, bool p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, bool p1, address p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, bool p1, address p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, bool p1, address p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, bool p1, address p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, address p1, uint p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, address p1, uint p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, address p1, uint p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, address p1, uint p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, address p1, string memory p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, address p1, string memory p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, address p1, string memory p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, address p1, string memory p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, address p1, bool p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, address p1, bool p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, address p1, bool p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, address p1, bool p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, address p1, address p2, uint p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, address p1, address p2, string memory p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, address p1, address p2, bool p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
+	}
+
+	function log(address p0, address p1, address p2, address p3) internal view {
+		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
+	}
 
-  function log(address p0, address p1, address p2, address p3) internal view {
-    _sendLogPayload(
-      abi.encodeWithSignature('log(address,address,address,address)', p0, p1, p2, p3)
-    );
-  }
 }
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/openzeppelin/contracts/token/ERC20/IERC20.sol b/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/openzeppelin/contracts/token/ERC20/IERC20.sol
deleted file mode 100644
index 62ba69f..0000000
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/openzeppelin/contracts/token/ERC20/IERC20.sol
+++ /dev/null
@@ -1,77 +0,0 @@
-// SPDX-License-Identifier: MIT
-
-pragma solidity ^0.6.0;
-
-/**
- * @dev Interface of the ERC20 standard as defined in the EIP.
- */
-interface IERC20 {
-  /**
-   * @dev Returns the amount of tokens in existence.
-   */
-  function totalSupply() external view returns (uint256);
-
-  /**
-   * @dev Returns the amount of tokens owned by `account`.
-   */
-  function balanceOf(address account) external view returns (uint256);
-
-  /**
-   * @dev Moves `amount` tokens from the caller's account to `recipient`.
-   *
-   * Returns a boolean value indicating whether the operation succeeded.
-   *
-   * Emits a {Transfer} event.
-   */
-  function transfer(address recipient, uint256 amount) external returns (bool);
-
-  /**
-   * @dev Returns the remaining number of tokens that `spender` will be
-   * allowed to spend on behalf of `owner` through {transferFrom}. This is
-   * zero by default.
-   *
-   * This value changes when {approve} or {transferFrom} are called.
-   */
-  function allowance(address owner, address spender) external view returns (uint256);
-
-  /**
-   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
-   *
-   * Returns a boolean value indicating whether the operation succeeded.
-   *
-   * IMPORTANT: Beware that changing an allowance with this method brings the risk
-   * that someone may use both the old and the new allowance by unfortunate
-   * transaction ordering. One possible solution to mitigate this race
-   * condition is to first reduce the spender's allowance to 0 and set the
-   * desired value afterwards:
-   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
-   *
-   * Emits an {Approval} event.
-   */
-  function approve(address spender, uint256 amount) external returns (bool);
-
-  /**
-   * @dev Moves `amount` tokens from `sender` to `recipient` using the
-   * allowance mechanism. `amount` is then deducted from the caller's
-   * allowance.
-   *
-   * Returns a boolean value indicating whether the operation succeeded.
-   *
-   * Emits a {Transfer} event.
-   */
-  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
-
-  /**
-   * @dev Emitted when `value` tokens are moved from one account (`from`) to
-   * another (`to`).
-   *
-   * Note that `value` may be zero.
-   */
-  event Transfer(address indexed from, address indexed to, uint256 value);
-
-  /**
-   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
-   * a call to {approve}. `value` is the new allowance.
-   */
-  event Approval(address indexed owner, address indexed spender, uint256 value);
-}
```
