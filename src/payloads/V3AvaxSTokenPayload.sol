// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import {AaveV3Avalanche, AaveV3AvalancheAssets} from 'aave-address-book/AaveV3Avalanche.sol';
import {ConfiguratorInputTypes} from 'aave-address-book/AaveV3.sol';
import {IERC20Detailed} from '../v3AvaStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';

interface IGetIncentivesController {
  function getIncentivesController() external returns (address);
}

contract V3AvaxSTokenPayload {
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

      AaveV3Avalanche.POOL_CONFIGURATOR.updateStableDebtToken(input);
    }
  }

  function getTokensToUpdate() public pure returns (TokenToUpdate[] memory){
    TokenToUpdate[] memory tokensToUpdate = new TokenToUpdate[](3);

    tokensToUpdate[0] = TokenToUpdate({
      underlyingAsset: AaveV3AvalancheAssets.DAIe_UNDERLYING,
    stableTokenProxy:AaveV3AvalancheAssets.DAIe_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[1] = TokenToUpdate({
      underlyingAsset: AaveV3AvalancheAssets.USDC_UNDERLYING,
      stableTokenProxy:AaveV3AvalancheAssets.USDC_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[2] = TokenToUpdate({
      underlyingAsset: AaveV3AvalancheAssets.USDt_UNDERLYING,
      stableTokenProxy:AaveV3AvalancheAssets.USDt_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });

    return tokensToUpdate;
  }
}
