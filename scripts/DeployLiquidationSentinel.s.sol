// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;

import 'forge-std/Script.sol';
import {ILendingPoolAddressesProvider} from 'aave-address-book/AaveV2.sol';

import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {AaveV2Polygon} from 'aave-address-book/AaveV2Polygon.sol';
import {AaveV2Avalanche} from 'aave-address-book/AaveV2Avalanche.sol';

import {LendingPoolCollateralManager} from '../src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol';
import {LiquidationsGraceSentinel} from '../src/LiquidationsGraceSentinel.sol';
import {V2LiquidationSentinelPayload} from '../src/payloads/V2LiquidationSentinelPayload.sol';

library LiquidationSentinelDeployer {
  function deployProposal(
    address guardian,
    ILendingPoolAddressesProvider addressesProvider
  ) internal returns (address) {
    LiquidationsGraceSentinel sentinel = new LiquidationsGraceSentinel();
    sentinel.transferOwnership(guardian);
    LendingPoolCollateralManager newCollateralManager = new LendingPoolCollateralManager(
      address(sentinel)
    );
    return
      address(new V2LiquidationSentinelPayload(address(newCollateralManager), addressesProvider));
  }

  function deployProposalEth() internal returns (address) {
    return deployProposal(AaveV2Ethereum.EMERGENCY_ADMIN, AaveV2Ethereum.POOL_ADDRESSES_PROVIDER);
  }

  function deployProposalAva() internal returns (address) {
    return deployProposal(AaveV2Avalanche.EMERGENCY_ADMIN, AaveV2Avalanche.POOL_ADDRESSES_PROVIDER);
  }

  function deployProposalPol() internal returns (address) {
    return deployProposal(AaveV2Polygon.EMERGENCY_ADMIN, AaveV2Polygon.POOL_ADDRESSES_PROVIDER);
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
