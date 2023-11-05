// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {StableDebtToken} from '../src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol';
import {AaveV3Arbitrum} from 'aave-address-book/AaveV3Arbitrum.sol';
import {IPool} from '../src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IPool.sol';


contract BaseDeploy {
  function _deploy() internal {
    address[] memory reserves = AaveV3Arbitrum.POOL.getReservesList();

    for (uint256 i = 0; i < reserves.length; i++) {
      (,,,,,,, bool stableBorrowRateEnabled,,) =
                  AaveV3Arbitrum.AAVE_PROTOCOL_DATA_PROVIDER.getReserveConfigurationData(reserves[i]);

      if (!stableBorrowRateEnabled) {
        continue;
      }

      new StableDebtToken(
        IPool(address(AaveV3Arbitrum.POOL))
      );
    }
  }
}

contract DeploySTokensV3Arb is BaseDeploy, Script {
  function run() public {
    vm.startBroadcast();

    _deploy();

    vm.stopBroadcast();
  }
}
