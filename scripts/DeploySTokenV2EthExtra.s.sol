// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;
pragma experimental ABIEncoderV2;

import 'forge-std/Script.sol';
import {StableDebtToken} from '../src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {DataTypes} from '../src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/types/DataTypes.sol';
import {IERC20Detailed} from '../src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';
import {V2EthSTokenPayloadExtra} from '../src/payloads/V2EthSTokenPayloadExtra.sol';

struct StableToken {
  address underlying;
  address stableToken;
  address newSTImpl;
}

contract BaseDeploy {
  function _deploy() internal returns (StableToken[] memory) {
    address[] memory reserves = new address[](3);
    reserves[0] = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // DAI
    reserves[1] = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984; // UNI
    reserves[2] = 0x0000000000085d4780B73119b644AE5ecd22b376; // TUSD

    StableToken[] memory deployedImpl = new StableToken[](3);

    for (uint256 i = 0; i < 3; i++) {
      (, , , , , , , bool stableBorrowRateEnabled, , ) = AaveV2Ethereum
        .AAVE_PROTOCOL_DATA_PROVIDER
        .getReserveConfigurationData(reserves[i]);
      (, address stableDebtTokenAddress, ) = AaveV2Ethereum
        .AAVE_PROTOCOL_DATA_PROVIDER
        .getReserveTokensAddresses(reserves[i]);

      StableDebtToken newStableDebtImpl = new StableDebtToken(
        address(AaveV2Ethereum.POOL),
        reserves[i],
        IERC20Detailed(stableDebtTokenAddress).name(),
        IERC20Detailed(stableDebtTokenAddress).symbol(),
        address(0) // we leave as address 0 because all the static tokens where deployed with 0 for incentives controller
      );

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

contract DeploySTokensV2Ethereum is BaseDeploy, Script {
  function run() public {
    vm.startBroadcast();

    _deploy();

    vm.stopBroadcast();
  }
}

contract DeployPayloadV2Eth is Script {
  function run() public {
    vm.startBroadcast();

    new V2EthSTokenPayloadExtra();

    vm.stopBroadcast();
  }
}
