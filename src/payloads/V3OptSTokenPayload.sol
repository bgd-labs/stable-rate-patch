// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import {AaveV3Optimism, AaveV3OptimismAssets} from 'aave-address-book/AaveV3Optimism.sol';
import {V3TokenPayload} from './V3TokenPayload.sol';

contract V3OptSTokenPayload is V3TokenPayload {
  constructor() V3TokenPayload(AaveV3Optimism.POOL_CONFIGURATOR) {}

  function getTokensToUpdate() public pure override returns (TokenToUpdate[] memory) {
    TokenToUpdate[] memory tokensToUpdate = new TokenToUpdate[](3);

    tokensToUpdate[0] = TokenToUpdate({
      underlyingAsset: AaveV3OptimismAssets.DAI_UNDERLYING,
      stableTokenProxy: AaveV3OptimismAssets.DAI_S_TOKEN,
      newSTokenImpl: 0x69713dA5fDfacf77E80C31F9B928Ec0Fc3716384
    });
    tokensToUpdate[1] = TokenToUpdate({
      underlyingAsset: AaveV3OptimismAssets.USDC_UNDERLYING,
      stableTokenProxy: AaveV3OptimismAssets.USDC_S_TOKEN,
      newSTokenImpl: 0x69713dA5fDfacf77E80C31F9B928Ec0Fc3716384
    });
    tokensToUpdate[2] = TokenToUpdate({
      underlyingAsset: AaveV3OptimismAssets.USDT_UNDERLYING,
      stableTokenProxy: AaveV3OptimismAssets.USDT_S_TOKEN,
      newSTokenImpl: 0x69713dA5fDfacf77E80C31F9B928Ec0Fc3716384
    });

    return tokensToUpdate;
  }
}
