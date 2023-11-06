// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {ConfiguratorInputTypes} from 'aave-address-book/AaveV3.sol';
import {IERC20Detailed} from '../v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';

interface IGetIncentivesController {
  function getIncentivesController() external returns (address);
}

contract V3ArbSTokenPayload {
  struct TokenToUpdate {
    address underlyingAsset;
    address newSTokenImpl;
    address stableTokenProxy;
  }

  function execute() external {

    TokenToUpdate[] memory tokensToUpdate = getTokensToUpdate();

    for (uint256 i = 0; i < tokensToUpdate.length; i++) {

      ConfiguratorInputTypes.UpdateDebtTokenInput memory input = ConfiguratorInputTypes.UpdateDebtTokenInput({
        asset: tokensToUpdate[i].underlyingAsset,
        incentivesController: IGetIncentivesController(tokensToUpdate[i].stableTokenProxy).getIncentivesController(),
        name: IERC20Detailed(tokensToUpdate[i].stableTokenProxy).name(),
        symbol: IERC20Detailed(tokensToUpdate[i].stableTokenProxy).symbol(),
        implementation:tokensToUpdate[i].newSTokenImpl,
        params: bytes('')
      });

      AaveV3Arbitrum.POOL_CONFIGURATOR.updateStableDebtToken(input);
    }
  }

  function getTokensToUpdate() public pure returns (TokenToUpdate[] memory){
    TokenToUpdate[] memory tokensToUpdate = new TokenToUpdate[](4);

    tokensToUpdate[0] = TokenToUpdate({
      underlyingAsset: AaveV3ArbitrumAssets.DAI_UNDERLYING,
      stableTokenProxy:AaveV3ArbitrumAssets.DAI_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[1] = TokenToUpdate({
      underlyingAsset: AaveV3ArbitrumAssets.USDC_UNDERLYING,
      stableTokenProxy:AaveV3ArbitrumAssets.USDC_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[2] = TokenToUpdate({
      underlyingAsset: AaveV3ArbitrumAssets.USDT_UNDERLYING,
      stableTokenProxy:AaveV3ArbitrumAssets.USDT_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[2] = TokenToUpdate({
      underlyingAsset: AaveV3ArbitrumAssets.EURS_UNDERLYING,
      stableTokenProxy:AaveV3ArbitrumAssets.EURS_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });

    return tokensToUpdate;
  }
}
