// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;
pragma experimental ABIEncoderV2;

import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {MiscEthereum} from "aave-address-book/MiscEthereum.sol";
import {IERC20Detailed} from '../v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';

contract V2EthTokenPayload {
  struct TokenToUpdate {
    address underlyingAsset;
    address newSTokenImpl;
  }

  function execute() external {

    TokenToUpdate[] memory tokensToUpdate = getTokensToUpdate();

    for (uint256 i = 0; i < tokensToUpdate.length; i++) {
      AaveV2Ethereum.POOL_CONFIGURATOR.updateStableDebtToken(
        tokensToUpdate[i].underlyingAsset,
        tokensToUpdate[i].newSTokenImpl
      );
    }
  }

  function getTokensToUpdate() public returns (TokenToUpdate[] memory){
    TokenToUpdate[] memory tokensToUpdate = new TokenToUpdate[](13);

    tokensToUpdate[0] = TokenToUpdate({
      underlyingAsset: AaveV2EthereumAssets.USDT_UNDERLYING,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[1] = TokenToUpdate({
      underlyingAsset: AaveV2EthereumAssets.WBTC_UNDERLYING,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[2] = TokenToUpdate({
      underlyingAsset: AaveV2EthereumAssets.WETH_UNDERLYING,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[3] = TokenToUpdate({
      underlyingAsset: AaveV2EthereumAssets.ZRX_UNDERLYING,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[4] = TokenToUpdate({
      underlyingAsset: AaveV2EthereumAssets.BAT_UNDERLYING,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[5] = TokenToUpdate({
      underlyingAsset: AaveV2EthereumAssets.ENJ_UNDERLYING,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[6] = TokenToUpdate({
      underlyingAsset: AaveV2EthereumAssets.KNC_UNDERLYING,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[7] = TokenToUpdate({
      underlyingAsset: AaveV2EthereumAssets.LINK_UNDERLYING,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[8] = TokenToUpdate({
      underlyingAsset: AaveV2EthereumAssets.MANA_UNDERLYING,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[9] = TokenToUpdate({
      underlyingAsset: AaveV2EthereumAssets.MKR_UNDERLYING,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[10] = TokenToUpdate({
      underlyingAsset: AaveV2EthereumAssets.REN_UNDERLYING,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[11] = TokenToUpdate({
      underlyingAsset: AaveV2EthereumAssets.USDC_UNDERLYING,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[12] = TokenToUpdate({
      underlyingAsset: AaveV2EthereumAssets.LUSD_UNDERLYING,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });

    return tokensToUpdate;
  }
}
