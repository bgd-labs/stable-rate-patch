// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import 'forge-std/Test.sol';
import {AaveV2Avalanche} from 'aave-address-book/AaveV2Avalanche.sol';
import {LendingPoolConfigurator} from 'src/v2EthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol';

contract V2AvaPoolConfiguratorTest is Test {
  LendingPoolConfigurator public poolConfigurator;
  address constant GOV_V3_AVA_EXECUTOR_LVL_1 = 0x3C06dce358add17aAf230f2234bCCC4afd50d090;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), 37450260);
    poolConfigurator = new LendingPoolConfigurator();

    vm.startPrank(GOV_V3_AVA_EXECUTOR_LVL_1);
    AaveV2Avalanche.POOL_ADDRESSES_PROVIDER.setLendingPoolConfiguratorImpl(address(poolConfigurator));
    vm.stopPrank();
  }

}
