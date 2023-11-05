```diff
diff --git a/etherscan/v2PolStableDebtToken/StableDebtToken/contracts/mocks/swap/MockUniswapV2Router02.sol b/src/v2PolStableDebtToken/StableDebtToken/contracts/mocks/swap/MockUniswapV2Router02.sol
index b7fd3f8..4f5e851 100644
--- a/etherscan/v2PolStableDebtToken/StableDebtToken/contracts/mocks/swap/MockUniswapV2Router02.sol
+++ b/src/v2PolStableDebtToken/StableDebtToken/contracts/mocks/swap/MockUniswapV2Router02.sol
@@ -2,7 +2,7 @@
 pragma solidity 0.6.12;
 
 import {IUniswapV2Router02} from '../../interfaces/IUniswapV2Router02.sol';
-import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
+import {IERC20} from '../../../@openzeppelin/contracts/token/ERC20/IERC20.sol';
 import {MintableERC20} from '../tokens/MintableERC20.sol';
 
 contract MockUniswapV2Router02 is IUniswapV2Router02 {
```
