// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;

import 'forge-std/Script.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {AaveV2Polygon} from 'aave-address-book/AaveV2Polygon.sol';
import {AaveV2Avalanche} from 'aave-address-book/AaveV2Avalanche.sol';

import {LendingPoolCollateralManager} from '../src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol';
import {LiquidationsGraceSentinel} from '../src/LiquidationsGraceSentinel.sol';
import {V2EthLiquidationSentinelPayload} from '../src/payloads/V2EthLiquidationSentinelPayload.sol';
import {V2PolLiquidationSentinelPayload} from '../src/payloads/V2PolLiquidationSentinelPayload.sol';
import {V2AvaLiquidationSentinelPayload} from '../src/payloads/V2AvaLiquidationSentinelPayload.sol';

library LiquidationSentinelDeployer {
  function deployProposalEth() internal returns (address) {
    LiquidationsGraceSentinel sentinel = new LiquidationsGraceSentinel();
    sentinel.transferOwnership(AaveV2Ethereum.EMERGENCY_ADMIN);
    LendingPoolCollateralManager newCollateralManager = new LendingPoolCollateralManager(
      address(sentinel)
    );
    return address(new V2EthLiquidationSentinelPayload(address(newCollateralManager)));
  }

  function deployProposalAva() internal returns (address) {
    LiquidationsGraceSentinel sentinel = new LiquidationsGraceSentinel();
    sentinel.transferOwnership(AaveV2Avalanche.EMERGENCY_ADMIN);
    LendingPoolCollateralManager newCollateralManager = new LendingPoolCollateralManager(
      address(sentinel)
    );
    return address(new V2AvaLiquidationSentinelPayload(address(newCollateralManager)));
  }

  function deployProposalPol() internal returns (address) {
    LiquidationsGraceSentinel sentinel = new LiquidationsGraceSentinel();
    sentinel.transferOwnership(AaveV2Polygon.EMERGENCY_ADMIN);
    LendingPoolCollateralManager newCollateralManager = new LendingPoolCollateralManager(
      address(sentinel)
    );
    return address(new V2PolLiquidationSentinelPayload(address(newCollateralManager)));
  }
}

contract DeployLiquidationSentinelEth is Script {
  function run() public {
    vm.startBroadcast();
    LiquidationSentinelDeployer.deployProposalEth();
    vm.stopBroadcast();
  }
}

contract DeployLiquidationSentinelPol is Script {
  function run() public {
    vm.startBroadcast();
    LiquidationSentinelDeployer.deployProposalPol();
    vm.stopBroadcast();
  }
}

contract DeployLiquidationSentinelAva is Script {
  function run() public {
    vm.startBroadcast();
    LiquidationSentinelDeployer.deployProposalAva();
    vm.stopBroadcast();
  }
}
