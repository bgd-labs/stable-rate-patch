// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {StableDebtToken} from '../src/v3PolStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol';
import {AaveV3Optimism} from 'aave-address-book/AaveV3Optimism.sol';
import {IPool} from '../src/v3PolStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IPool.sol';
import {IERC20Detailed} from '../src/v3OptStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';


contract BaseDeploy {
  function _deploy() internal {
    address[] memory reserves = AaveV3Optimism.POOL.getReservesList();

    for (uint256 i = 0; i < reserves.length; i++) {
      (,,,,,,, bool stableBorrowRateEnabled,,) =
                  AaveV3Optimism.AAVE_PROTOCOL_DATA_PROVIDER.getReserveConfigurationData(reserves[i]);
      (, address stableDebtTokenAddress, ) = AaveV3Optimism
        .AAVE_PROTOCOL_DATA_PROVIDER
        .getReserveTokensAddresses(reserves[i]);

      if (!stableBorrowRateEnabled) {
        continue;
      }

      StableDebtToken newStableDebtImpl = new StableDebtToken(
        IPool(address(AaveV3Optimism.POOL))
      );

      console.log(
        IERC20Detailed(stableDebtTokenAddress).symbol(),
        reserves[i],
        stableDebtTokenAddress,
        address(newStableDebtImpl)
      );
    }
  }
}

contract DeploySTokensV3Opt is BaseDeploy, Script {
  function run() public {
    vm.startBroadcast();

    _deploy();

    vm.stopBroadcast();
  }
}