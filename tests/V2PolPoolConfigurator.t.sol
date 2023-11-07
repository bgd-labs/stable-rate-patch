// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import 'forge-std/Test.sol';
import {AaveV2Polygon} from 'aave-address-book/AaveV2Polygon.sol';
import {LendingPoolConfigurator} from 'src/v2EthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol';

contract V2PolPoolConfiguratorTest is Test {
  LendingPoolConfigurator public poolConfigurator;
  address constant GOV_V3_POL_EXECUTOR_LVL_1 = 0xDf7d0e6454DB638881302729F5ba99936EaAB233;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 49650624);
    poolConfigurator = new LendingPoolConfigurator();

    vm.startPrank(GOV_V3_POL_EXECUTOR_LVL_1);
    AaveV2Polygon.POOL_ADDRESSES_PROVIDER.setLendingPoolConfiguratorImpl(address(poolConfigurator));
    vm.stopPrank();
  }

}
