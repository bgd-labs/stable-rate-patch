// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import 'forge-std/Script.sol';
import {StableDebtToken, IAaveIncentivesController} from '../src/v3FanHarStableDebtToken/StableDebtToken/@aave/core-v3/contracts/protocol/tokenization/StableDebtToken.sol';
import {AaveV3Harmony, AaveV3HarmonyAssets} from 'aave-address-book/AaveV3Harmony.sol';
import {IPool} from '../src/v3FanHarStableDebtToken/StableDebtToken/@aave/core-v3/contracts/interfaces/IPool.sol';
import {IERC20Detailed} from '../src/v3FanHarStableDebtToken/StableDebtToken/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';
import {V3HarSTokenPayload} from '../src/payloads/V3HarSTokenPayload.sol';

struct StableToken {
  address underlying;
  address stableToken;
  address newSTImpl;
}

contract BaseDeploy {
  function _deploy() internal returns (StableToken[] memory) {
    address[] memory reserves = new address[](5);
    reserves[0] = AaveV3HarmonyAssets.ONE_DAI_UNDERLYING;
    reserves[1] = AaveV3HarmonyAssets.LINK_UNDERLYING;
    reserves[2] = AaveV3HarmonyAssets.ONE_USDC_UNDERLYING;
    reserves[3] = AaveV3HarmonyAssets.ONE_ETH_UNDERLYING;
    reserves[4] = AaveV3HarmonyAssets.ONE_USDT_UNDERLYING;

    StableToken[] memory deployedImpl = new StableToken[](reserves.length);

    StableDebtToken newStableDebtImpl = new StableDebtToken(IPool(address(AaveV3Harmony.POOL)));

    // initialize impl
    newStableDebtImpl.initialize(
      IPool(address(AaveV3Harmony.POOL)),
      address(0),
      IAaveIncentivesController(address(0)),
      18,
      'STABLE_DEBT_TOKEN_IMPL',
      'STABLE_DEBT_TOKEN_IMPL',
      bytes('')
    );

    for (uint256 i = 0; i < reserves.length; i++) {
      (, , , , , , , bool stableBorrowRateEnabled, , ) = AaveV3Harmony
        .AAVE_PROTOCOL_DATA_PROVIDER
        .getReserveConfigurationData(reserves[i]);
      (, address stableDebtTokenAddress, ) = AaveV3Harmony
        .AAVE_PROTOCOL_DATA_PROVIDER
        .getReserveTokensAddresses(reserves[i]);

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

contract DeploySTokensV3Har is BaseDeploy, Script {
  function run() public {
    vm.startBroadcast();

    _deploy();

    vm.stopBroadcast();
  }
}

contract DeployPayloadV3Har is Script {
  function run() public {
    vm.startBroadcast();

    new V3HarSTokenPayload();

    vm.stopBroadcast();
  }
}
