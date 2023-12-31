// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import {V3TokenPayload} from './V3TokenPayload.sol';

contract V3PolSTokenPayload is V3TokenPayload {
  constructor() V3TokenPayload(AaveV3Polygon.POOL_CONFIGURATOR) {}

  function getTokensToUpdate() public pure override returns (TokenToUpdate[] memory) {
    TokenToUpdate[] memory tokensToUpdate = new TokenToUpdate[](4);

    tokensToUpdate[0] = TokenToUpdate({
      underlyingAsset: AaveV3PolygonAssets.DAI_UNDERLYING,
      stableTokenProxy: AaveV3PolygonAssets.DAI_S_TOKEN,
      newSTokenImpl: 0xF4294973B7E6F6C411dD8A388592E7c7D32F2486
    });
    tokensToUpdate[1] = TokenToUpdate({
      underlyingAsset: AaveV3PolygonAssets.USDC_UNDERLYING,
      stableTokenProxy: AaveV3PolygonAssets.USDC_S_TOKEN,
      newSTokenImpl: 0xF4294973B7E6F6C411dD8A388592E7c7D32F2486
    });
    tokensToUpdate[2] = TokenToUpdate({
      underlyingAsset: AaveV3PolygonAssets.USDT_UNDERLYING,
      stableTokenProxy: AaveV3PolygonAssets.USDT_S_TOKEN,
      newSTokenImpl: 0xF4294973B7E6F6C411dD8A388592E7c7D32F2486
    });
    tokensToUpdate[3] = TokenToUpdate({
      underlyingAsset: AaveV3PolygonAssets.EURS_UNDERLYING,
      stableTokenProxy: AaveV3PolygonAssets.EURS_S_TOKEN,
      newSTokenImpl: 0xF4294973B7E6F6C411dD8A388592E7c7D32F2486
    });

    return tokensToUpdate;
  }
}
