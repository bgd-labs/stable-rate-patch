// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12;
pragma experimental ABIEncoderV2;

import 'forge-std/Test.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';
import {LendingPoolCollateralManager} from '../src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol';

/**
 * @dev Test for LiquidationsGraceSentinel activation
 * command: make test-contract filter=LiquidationsGraceSentinelTest
 */
contract LiquidationsGraceSentinelTest is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18507320);
  }

  function testLiquidationsGraceSentinel() public {
    vm.prank(GovernanceV3Ethereum.EXECUTOR_LVL_1);

    LendingPoolCollateralManager newCollateralManager = new LendingPoolCollateralManager(
      address(0)
    );

    POOL_ADDRESSES_PROVIDER.setLendingPoolCollateralManager(address(newCollateralManager));
  }
}