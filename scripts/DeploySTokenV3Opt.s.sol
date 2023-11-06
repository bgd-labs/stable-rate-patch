// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import 'forge-std/Script.sol';
import {StableDebtToken} from '../src/v3OptStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol';
import {AaveV3Optimism} from 'aave-address-book/AaveV3Optimism.sol';
import {IPool} from '../src/v3OptStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IPool.sol';
import {IERC20Detailed} from '../src/v3OptStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';
import {V3OptSTokenPayload} from '../src/payloads/V3OptSTokenPayload.sol';

struct StableToken {
  address underlying;
  address stableToken;
  address newSTImpl;
}

contract BaseDeploy {
  function _deploy() internal returns (StableToken[] memory) {
    address[] memory reserves = AaveV3Optimism.POOL.getReservesList();
    StableToken[] memory deployedImpl = new StableToken[](reserves.length);
    StableDebtToken newStableDebtImpl = new StableDebtToken(IPool(address(AaveV3Optimism.POOL)));

    for (uint256 i = 0; i < reserves.length; i++) {
      (, , , , , , , bool stableBorrowRateEnabled, , ) = AaveV3Optimism
        .AAVE_PROTOCOL_DATA_PROVIDER
        .getReserveConfigurationData(reserves[i]);
      (, address stableDebtTokenAddress, ) = AaveV3Optimism
        .AAVE_PROTOCOL_DATA_PROVIDER
        .getReserveTokensAddresses(reserves[i]);

      if (!stableBorrowRateEnabled) {
        continue;
      }

      console.log(
        IERC20Detailed(stableDebtTokenAddress).symbol(),
        reserves[i],
        stableDebtTokenAddress,
        address(newStableDebtImpl)
      );
      deployedImpl[i] = StableToken({
        underlying: reserves[i],
        stableToken: stableDebtTokenAddress,
        newSTImpl: address(newStableDebtImpl)
      });
    }
    return deployedImpl;
  }
}

contract DeploySTokensV3Opt is BaseDeploy, Script {
  function run() public {
    vm.startBroadcast();

    _deploy();

    vm.stopBroadcast();
  }
}

contract DeployPayloadV3Opt is Script {
  function run() public {
    vm.startBroadcast();

    new V3OptSTokenPayload();

    vm.stopBroadcast();
  }
}
