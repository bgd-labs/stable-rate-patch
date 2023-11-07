// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;
pragma experimental ABIEncoderV2;

import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';

contract V2EthSTokenPayload {
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

  function getTokensToUpdate() public pure returns (TokenToUpdate[] memory) {
    TokenToUpdate[] memory tokensToUpdate = new TokenToUpdate[](3);

    tokensToUpdate[0] = TokenToUpdate({
      underlyingAsset: AaveV2EthereumAssets.TUSD_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[1] = TokenToUpdate({
      underlyingAsset: AaveV2EthereumAssets.DAI_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[2] = TokenToUpdate({
      underlyingAsset: AaveV2EthereumAssets.UNI_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });

    return tokensToUpdate;
  }
}
