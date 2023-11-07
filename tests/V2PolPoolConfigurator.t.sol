// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import 'forge-std/Test.sol';
import {AaveV2Polygon, AaveV2PolygonAssets} from 'aave-address-book/AaveV2Polygon.sol';
import {LendingPoolConfigurator} from 'src/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol';
import {Errors} from 'src/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/protocol/libraries/helpers/Errors.sol';

contract V2PolPoolConfiguratorTest is Test {
  LendingPoolConfigurator public poolConfigurator;
  address constant GOV_V3_POL_EXECUTOR_LVL_1 = 0xDf7d0e6454DB638881302729F5ba99936EaAB233;
  address constant EMERGENCY_ADMIN = 0x1450F2898D6bA2710C98BE9CAF3041330eD5ae58;
  address constant POOL_ADMIN = GOV_V3_POL_EXECUTOR_LVL_1;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 49650624);
    poolConfigurator = new LendingPoolConfigurator();

    vm.startPrank(GOV_V3_POL_EXECUTOR_LVL_1);
    AaveV2Polygon.POOL_ADDRESSES_PROVIDER.setLendingPoolConfiguratorImpl(address(poolConfigurator));
    vm.stopPrank();
  }

  function test_reverts_freezeReserve(address caller) public {
    vm.assume(caller != EMERGENCY_ADMIN && caller != POOL_ADMIN);

    vm.expectRevert(bytes(Errors.CALLER_NOT_POOL_OR_EMERGENCY_ADMIN));
    vm.startPrank(caller);
    AaveV2Polygon.POOL_CONFIGURATOR.freezeReserve(AaveV2PolygonAssets.USDC_UNDERLYING);
    vm.stopPrank();
  }

  function test_reverts_unfreezeReserve(address caller) public {
    vm.assume(caller != EMERGENCY_ADMIN && caller != POOL_ADMIN);

    vm.expectRevert(bytes(Errors.CALLER_NOT_POOL_OR_EMERGENCY_ADMIN));
    vm.startPrank(caller);
    AaveV2Polygon.POOL_CONFIGURATOR.unfreezeReserve(AaveV2PolygonAssets.USDC_UNDERLYING);
    vm.stopPrank();
  }

  function test_freezeReserve_emergencyAdmin() public {
    vm.startPrank(EMERGENCY_ADMIN);
    AaveV2Polygon.POOL_CONFIGURATOR.freezeReserve(AaveV2PolygonAssets.USDC_UNDERLYING);
    vm.stopPrank();

    (,,,,,,,,, bool isFrozen) = AaveV2Polygon.AAVE_PROTOCOL_DATA_PROVIDER.getReserveConfigurationData(AaveV2PolygonAssets.USDC_UNDERLYING);
    assertEq(isFrozen, true);
  }

  function test_freezeReserve_poolAdmin() public {
    vm.startPrank(POOL_ADMIN);
    AaveV2Polygon.POOL_CONFIGURATOR.freezeReserve(AaveV2PolygonAssets.USDC_UNDERLYING);
    vm.stopPrank();

    (,,,,,,,,, bool isFrozen) = AaveV2Polygon.AAVE_PROTOCOL_DATA_PROVIDER.getReserveConfigurationData(AaveV2PolygonAssets.USDC_UNDERLYING);
    assertEq(isFrozen, true);
  }

  function test_unfreezeReserve_emergencyAdmin() public {
    vm.startPrank(EMERGENCY_ADMIN);
    AaveV2Polygon.POOL_CONFIGURATOR.unfreezeReserve(AaveV2PolygonAssets.USDC_UNDERLYING);
    vm.stopPrank();

    (,,,,,,,,, bool isFrozen) = AaveV2Polygon.AAVE_PROTOCOL_DATA_PROVIDER.getReserveConfigurationData(AaveV2PolygonAssets.USDC_UNDERLYING);
    assertEq(isFrozen, false);
  }

  function test_unfreezeReserve_poolAdmin() public {
    vm.startPrank(POOL_ADMIN);
    AaveV2Polygon.POOL_CONFIGURATOR.unfreezeReserve(AaveV2PolygonAssets.USDC_UNDERLYING);
    vm.stopPrank();

    (,,,,,,,,, bool isFrozen) = AaveV2Polygon.AAVE_PROTOCOL_DATA_PROVIDER.getReserveConfigurationData(AaveV2PolygonAssets.USDC_UNDERLYING);
    assertEq(isFrozen, false);
  }

}
