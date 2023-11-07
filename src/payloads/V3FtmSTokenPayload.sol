// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import {AaveV3Fantom, AaveV3FantomAssets} from 'aave-address-book/AaveV3Fantom.sol';
import {V3TokenPayload} from './V3TokenPayload.sol';

contract V3FtmSTokenPayload is V3TokenPayload {
  constructor() V3TokenPayload(AaveV3Fantom.POOL_CONFIGURATOR) {}

  function getTokensToUpdate() public pure override returns (TokenToUpdate[] memory) {
    TokenToUpdate[] memory tokensToUpdate = new TokenToUpdate[](3);

    tokensToUpdate[0] = TokenToUpdate({
      underlyingAsset: AaveV3FantomAssets.DAI_UNDERLYING,
      stableTokenProxy: AaveV3FantomAssets.DAI_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill when deployed
    });
    tokensToUpdate[1] = TokenToUpdate({
      underlyingAsset: AaveV3FantomAssets.USDC_UNDERLYING,
      stableTokenProxy: AaveV3FantomAssets.USDC_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill when deployed
    });
    tokensToUpdate[2] = TokenToUpdate({
      underlyingAsset: AaveV3FantomAssets.ETH_UNDERLYING,
      stableTokenProxy: AaveV3FantomAssets.ETH_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill when deployed
    });
    tokensToUpdate[2] = TokenToUpdate({
      underlyingAsset: AaveV3FantomAssets.fUSDT_UNDERLYING,
      stableTokenProxy: AaveV3FantomAssets.fUSDT_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill when deployed
    });

    return tokensToUpdate;
  }
}
