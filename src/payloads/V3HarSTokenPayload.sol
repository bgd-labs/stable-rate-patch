// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import {AaveV3Harmony, AaveV3HarmonyAssets} from 'aave-address-book/AaveV3Harmony.sol';
import {V3TokenPayload} from './V3TokenPayload.sol';

contract V3HarSTokenPayload is V3TokenPayload {
  constructor() V3TokenPayload(AaveV3Harmony.POOL_CONFIGURATOR) {}

  function getTokensToUpdate() public pure override returns (TokenToUpdate[] memory) {
    TokenToUpdate[] memory tokensToUpdate = new TokenToUpdate[](5);

    tokensToUpdate[0] = TokenToUpdate({
      underlyingAsset: AaveV3HarmonyAssets.ONE_DAI_UNDERLYING,
      stableTokenProxy: AaveV3HarmonyAssets.ONE_DAI_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill when deployed
    });
    tokensToUpdate[1] = TokenToUpdate({
      underlyingAsset: AaveV3HarmonyAssets.LINK_UNDERLYING,
      stableTokenProxy: AaveV3HarmonyAssets.LINK_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill when deployed
    });
    tokensToUpdate[2] = TokenToUpdate({
      underlyingAsset: AaveV3HarmonyAssets.ONE_USDC_UNDERLYING,
      stableTokenProxy: AaveV3HarmonyAssets.ONE_USDC_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill when deployed
    });
    tokensToUpdate[3] = TokenToUpdate({
      underlyingAsset: AaveV3HarmonyAssets.ONE_ETH_UNDERLYING,
      stableTokenProxy: AaveV3HarmonyAssets.ONE_ETH_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill when deployed
    });
    tokensToUpdate[4] = TokenToUpdate({
      underlyingAsset: AaveV3HarmonyAssets.ONE_USDT_UNDERLYING,
      stableTokenProxy: AaveV3HarmonyAssets.ONE_USDT_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill when deployed
    });

    return tokensToUpdate;
  }
}
