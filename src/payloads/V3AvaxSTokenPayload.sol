// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import {AaveV3Avalanche, AaveV3AvalancheAssets} from 'aave-address-book/AaveV3Avalanche.sol';
import {V3TokenPayload} from './V3TokenPayload.sol';

contract V3AvaxSTokenPayload is V3TokenPayload {
  constructor() V3TokenPayload(AaveV3Avalanche.POOL_CONFIGURATOR) {}

  function getTokensToUpdate() public pure override returns (TokenToUpdate[] memory) {
    TokenToUpdate[] memory tokensToUpdate = new TokenToUpdate[](3);

    tokensToUpdate[0] = TokenToUpdate({
      underlyingAsset: AaveV3AvalancheAssets.DAIe_UNDERLYING,
      stableTokenProxy: AaveV3AvalancheAssets.DAIe_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[1] = TokenToUpdate({
      underlyingAsset: AaveV3AvalancheAssets.USDC_UNDERLYING,
      stableTokenProxy: AaveV3AvalancheAssets.USDC_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[2] = TokenToUpdate({
      underlyingAsset: AaveV3AvalancheAssets.USDt_UNDERLYING,
      stableTokenProxy: AaveV3AvalancheAssets.USDt_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });

    return tokensToUpdate;
  }
}
