// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;
pragma experimental ABIEncoderV2;

import "forge-std/Script.sol";
import {StableDebtToken} from '../src/v2AvaStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol';
import {AaveV2Avalanche} from 'aave-address-book/AaveV2Avalanche.sol';
import {DataTypes} from '../src/v2AvaStableDebtToken/StableDebtToken/contracts/protocol/libraries/types/DataTypes.sol';
import {IERC20Detailed} from '../src/v2AvaStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';


contract BaseDeploy {
  function _deploy() internal {
    address[] memory reserves = AaveV2Avalanche.POOL.getReservesList();

    for (uint256 i = 0; i < reserves.length; i++) {
      (,,,,,,, bool stableBorrowRateEnabled,,) =
                  AaveV2Avalanche.AAVE_PROTOCOL_DATA_PROVIDER.getReserveConfigurationData(reserves[i]);
      (, address stableDebtTokenAddress, ) = AaveV2Avalanche
        .AAVE_PROTOCOL_DATA_PROVIDER
        .getReserveTokensAddresses(reserves[i]);

      if (!stableBorrowRateEnabled) {
        continue;
      }

      StableDebtToken newStableDebtImpl = new StableDebtToken();

      console.log(
        IERC20Detailed(stableDebtTokenAddress).symbol(),
        reserves[i],
        stableDebtTokenAddress,
        address(newStableDebtImpl)
      );
    }
  }
}

contract DeploySTokensV2Avax is BaseDeploy, Script {
  function run() public {
    vm.startBroadcast();

    _deploy();

    vm.stopBroadcast();
  }
}
