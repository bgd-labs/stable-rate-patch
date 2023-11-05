// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import {ConfiguratorInputTypes} from 'aave-address-book/AaveV3.sol';
import {IERC20Detailed} from '../v3PolStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';

interface GetIncentivesController {
  function getIncentivesController() external returns (address);
}

contract V3PolSTokenPayload {
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
        incentivesController: GetIncentivesController(tokensToUpdate[i].stableTokenProxy).getIncentivesController(),
        name: IERC20Detailed(tokensToUpdate[i].stableTokenProxy).name(),
        symbol: IERC20Detailed(tokensToUpdate[i].stableTokenProxy).symbol(),
        implementation:tokensToUpdate[i].newSTokenImpl,
        params: bytes('')
      });

      AaveV3Polygon.POOL_CONFIGURATOR.updateStableDebtToken(input);
    }
  }

  function getTokensToUpdate() public pure returns (TokenToUpdate[] memory){
    TokenToUpdate[] memory tokensToUpdate = new TokenToUpdate[](4);

    tokensToUpdate[0] = TokenToUpdate({
      underlyingAsset: AaveV3PolygonAssets.DAI_UNDERLYING,
      stableTokenProxy:AaveV3PolygonAssets.DAI_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[1] = TokenToUpdate({
      underlyingAsset: AaveV3PolygonAssets.USDC_UNDERLYING,
      stableTokenProxy:AaveV3PolygonAssets.USDC_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[2] = TokenToUpdate({
      underlyingAsset: AaveV3PolygonAssets.USDT_UNDERLYING,
      stableTokenProxy:AaveV3PolygonAssets.USDT_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });
    tokensToUpdate[2] = TokenToUpdate({
      underlyingAsset: AaveV3PolygonAssets.EURS_UNDERLYING,
      stableTokenProxy:AaveV3PolygonAssets.EURS_S_TOKEN,
      newSTokenImpl: address(0) // TODO: fill with deployed address
    });


    return tokensToUpdate;
  }
}
