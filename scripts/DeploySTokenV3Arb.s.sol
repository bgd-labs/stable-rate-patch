// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import 'forge-std/Script.sol';
import {StableDebtToken} from '../src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol';
import {AaveV3Arbitrum} from 'aave-address-book/AaveV3Arbitrum.sol';
import {IPool} from '../src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IPool.sol';
import {IERC20Detailed} from '../src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';
import {V3ArbSTokenPayload} from "../src/payloads/V3ArbSTokenPayload.sol";

contract BaseDeploy {
  function _deploy() internal {
    address[] memory reserves = AaveV3Arbitrum.POOL.getReservesList();

    for (uint256 i = 0; i < reserves.length; i++) {
      (, , , , , , , bool stableBorrowRateEnabled, , ) = AaveV3Arbitrum
        .AAVE_PROTOCOL_DATA_PROVIDER
        .getReserveConfigurationData(reserves[i]);
      (, address stableDebtTokenAddress, ) = AaveV3Arbitrum
        .AAVE_PROTOCOL_DATA_PROVIDER
        .getReserveTokensAddresses(reserves[i]);

      if (!stableBorrowRateEnabled) {
        continue;
      }

      StableDebtToken newStableDebtImpl = new StableDebtToken(IPool(address(AaveV3Arbitrum.POOL)));

      console.log(
        IERC20Detailed(stableDebtTokenAddress).symbol(),
        reserves[i],
        stableDebtTokenAddress,
        address(newStableDebtImpl)
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

contract DeployPayloadV3Arb is Script {
  function run() public {
    vm.startBroadcast();

    new V3ArbSTokenPayload();

    vm.stopBroadcast();
  }
}
