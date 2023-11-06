```diff
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/openzeppelin/contracts/token/ERC20/IERC20.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/@openzeppelin/contracts/token/ERC20/IERC20.sol
similarity index 100%
rename from etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/openzeppelin/contracts/token/ERC20/IERC20.sol
rename to src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/@openzeppelin/contracts/token/ERC20/IERC20.sol
diff --git a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/swap/MockUniswapV2Router02.sol b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/swap/MockUniswapV2Router02.sol
index 5eabf1b..4f5e851 100644
--- a/etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/swap/MockUniswapV2Router02.sol
+++ b/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/mocks/swap/MockUniswapV2Router02.sol
@@ -2,7 +2,7 @@
 pragma solidity 0.6.12;
 
 import {IUniswapV2Router02} from '../../interfaces/IUniswapV2Router02.sol';
-import {IERC20} from '../../../openzeppelin/contracts/token/ERC20/IERC20.sol';
+import {IERC20} from '../../../@openzeppelin/contracts/token/ERC20/IERC20.sol';
 import {MintableERC20} from '../tokens/MintableERC20.sol';
 
 contract MockUniswapV2Router02 is IUniswapV2Router02 {
```
