// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import 'forge-std/Script.sol';
import {StableDebtToken} from '../src/v3OptStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol';
import {AaveV3Fantom, AaveV3FantomAssets} from 'aave-address-book/AaveV3Fantom.sol';
import {IPool} from '../src/v3OptStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/interfaces/IPool.sol';
import {IERC20Detailed} from '../src/v3OptStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';
import {V3FtmSTokenPayload} from '../src/payloads/V3FtmSTokenPayload.sol';

  struct StableToken {
    address underlying;
    address stableToken;
    address newSTImpl;
  }

contract BaseDeploy {
  function _deploy() internal returns (StableToken[] memory) {
    address[] memory reserves = address[](4);
    reserves[0] = AaveV3FantomAssets.DAI_UNDERLYING;
    reserves[1] = AaveV3FantomAssets.USDC_UNDERLYING;
    reserves[2] = AaveV3FantomAssets.ETH_UNDERLYING;
    reserves[3] = AaveV3FantomAssets.fUSDT_UNDERLYING;

    StableToken[] memory deployedImpl = new StableToken[](reserves.length);
    StableDebtToken newStableDebtImpl = new StableDebtToken(IPool(address(AaveV3Fantom.POOL)));

    for (uint256 i = 0; i < reserves.length; i++) {
      (, , , , , , , bool stableBorrowRateEnabled, , ) = AaveV3Fantom
        .AAVE_PROTOCOL_DATA_PROVIDER
        .getReserveConfigurationData(reserves[i]);
      (, address stableDebtTokenAddress, ) = AaveV3Fantom
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

contract DeploySTokensV3Ftm is BaseDeploy, Script {
  function run() public {
    vm.startBroadcast();

    _deploy();

    vm.stopBroadcast();
  }
}

contract DeployPayloadV3Ftm is Script {
  function run() public {
    vm.startBroadcast();

    new V3OptSTokenPayload();

    vm.stopBroadcast();
  }
}
