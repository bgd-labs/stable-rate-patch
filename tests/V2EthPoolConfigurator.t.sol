// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import 'forge-std/Test.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {LendingPoolConfigurator} from 'src/v2EthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol';

contract V2PolPoolConfiguratorTest is Test {
  LendingPoolConfigurator public poolConfigurator;
  address constant GOV_V3_ETH_EXECUTOR_LVL_1 = 0x5300A1a15135EA4dc7aD5a167152C01EFc9b192A;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18519554);
    poolConfigurator = new LendingPoolConfigurator();

    vm.startPrank(GOV_V3_ETH_EXECUTOR_LVL_1);
    AaveV2Ethereum.POOL_ADDRESSES_PROVIDER.setLendingPoolConfiguratorImpl(address(poolConfigurator));
    vm.stopPrank();
  }

}
