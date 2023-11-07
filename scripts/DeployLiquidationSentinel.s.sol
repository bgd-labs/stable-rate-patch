// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;

import 'forge-std/Script.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';

import {LendingPoolCollateralManager} from '../src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol';
import {LiquidationsGraceSentinel} from '../src/LiquidationsGraceSentinel.sol';
import {V2EthLiquidationSentinelPayload} from '../src/payloads/V2EthLiquidationSentinelPayload.sol';

library LiquidationSentinelDeployer {
  function deployProposal() internal returns (address) {
    LiquidationsGraceSentinel sentinel = new LiquidationsGraceSentinel();
    sentinel.transferOwnership(AaveV2Ethereum.EMERGENCY_ADMIN);
    LendingPoolCollateralManager newCollateralManager = new LendingPoolCollateralManager(
      address(sentinel)
    );
    return address(new V2EthLiquidationSentinelPayload(address(newCollateralManager)));
  }
}

contract DeployLiquidationSentinel is Script {
  function run() public {
    vm.startBroadcast();
    LiquidationSentinelDeployer.deployProposal();
    vm.stopBroadcast();
  }
}
