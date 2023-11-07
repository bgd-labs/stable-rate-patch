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