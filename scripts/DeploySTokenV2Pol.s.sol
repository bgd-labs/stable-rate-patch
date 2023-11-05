// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;
pragma experimental ABIEncoderV2;

import 'forge-std/Script.sol';
import {StableDebtToken} from '../src/v2PolStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol';
import {AaveV2Polygon} from 'aave-address-book/AaveV2Polygon.sol';
import {DataTypes} from '../src/v2PolStableDebtToken/StableDebtToken/contracts/protocol/libraries/types/DataTypes.sol';
import {IERC20Detailed} from '../src/v2PolStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';

contract BaseDeploy {
  function _deploy() internal {
    address[] memory reserves = AaveV2Polygon.POOL.getReservesList();

    for (uint256 i = 0; i < reserves.length; i++) {
      (, , , , , , , bool stableBorrowRateEnabled, , ) = AaveV2Polygon
        .AAVE_PROTOCOL_DATA_PROVIDER
        .getReserveConfigurationData(reserves[i]);

      if (!stableBorrowRateEnabled) {
        continue;
      }

      StableDebtToken newStableDebtImpl = new StableDebtToken();

      (, address stableDebtTokenAddress, ) = AaveV2Polygon
        .AAVE_PROTOCOL_DATA_PROVIDER
        .getReserveTokensAddresses(reserves[i]);

      console.log(
        IERC20Detailed(stableDebtTokenAddress).symbol(),
        reserves[i],
        stableDebtTokenAddress,
        address(newStableDebtImpl)
      );
    }
  }
}

contract DeploySTokensV2Pol is BaseDeploy, Script {
  function run() public {
    vm.startBroadcast();

    _deploy();

    vm.stopBroadcast();
  }
}
