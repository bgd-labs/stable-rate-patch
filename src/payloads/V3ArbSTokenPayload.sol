// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {V3TokenPayload} from './V3TokenPayload.sol';

contract V3ArbSTokenPayload {
  constructor() V3TokenPayload(AaveV3Arbitrum.POOL_CONFIGURATOR) {}

  function getTokensToUpdate() public pure override returns (TokenToUpdate[] memory) {
    TokenToUpdate[] memory tokensToUpdate = new TokenToUpdate[](4);

    tokensToUpdate[0] = TokenToUpdate({
      underlyingAsset: AaveV3ArbitrumAssets.DAI_UNDERLYING,
      stableTokenProxy: AaveV3ArbitrumAssets.DAI_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[1] = TokenToUpdate({
      underlyingAsset: AaveV3ArbitrumAssets.USDC_UNDERLYING,
      stableTokenProxy: AaveV3ArbitrumAssets.USDC_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[2] = TokenToUpdate({
      underlyingAsset: AaveV3ArbitrumAssets.USDT_UNDERLYING,
      stableTokenProxy: AaveV3ArbitrumAssets.USDT_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[2] = TokenToUpdate({
      underlyingAsset: AaveV3ArbitrumAssets.EURS_UNDERLYING,
      stableTokenProxy: AaveV3ArbitrumAssets.EURS_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });

    return tokensToUpdate;
  }
}
