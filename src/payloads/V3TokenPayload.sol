// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import {ConfiguratorInputTypes, IPoolConfigurator} from 'aave-address-book/AaveV3.sol';
import {IERC20Detailed} from '../v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';

interface IGetIncentivesController {
  function getIncentivesController() external returns (address);
}

abstract contract V3TokenPayload {
  struct TokenToUpdate {
    address underlyingAsset;
    address newSTokenImpl;
    address stableTokenProxy;
  }

  IPoolConfigurator immutable POOL_CONFIGURATOR;

  constructor(IPoolConfigurator configurator) {
    POOL_CONFIGURATOR = configurator;
  }

  function execute() external {
    TokenToUpdate[] memory tokensToUpdate = getTokensToUpdate();

    for (uint256 i = 0; i < tokensToUpdate.length; i++) {
      ConfiguratorInputTypes.UpdateDebtTokenInput memory input = ConfiguratorInputTypes
        .UpdateDebtTokenInput({
          asset: tokensToUpdate[i].underlyingAsset,
          incentivesController: IGetIncentivesController(tokensToUpdate[i].stableTokenProxy)
            .getIncentivesController(),
          name: IERC20Detailed(tokensToUpdate[i].stableTokenProxy).name(),
          symbol: IERC20Detailed(tokensToUpdate[i].stableTokenProxy).symbol(),
          implementation: tokensToUpdate[i].newSTokenImpl,
          params: bytes('')
        });

      POOL_CONFIGURATOR.updateStableDebtToken(input);
    }
  }

  function getTokensToUpdate() public pure virtual returns (TokenToUpdate[] memory);
}
