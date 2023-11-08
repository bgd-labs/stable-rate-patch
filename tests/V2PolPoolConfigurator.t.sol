// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import 'forge-std/Test.sol';
import {DeployPolygon} from 'scripts/DeployPoolConfigurator.s.sol';
import {V2L2ConfiguratorUpdatePayload} from 'src/payloads/V2L2ConfiguratorUpdatePayload.sol';
import {AaveV2Polygon, AaveV2PolygonAssets} from 'aave-address-book/AaveV2Polygon.sol';
import {LendingPoolConfigurator} from 'src/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol';
import {Errors} from 'src/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/protocol/libraries/helpers/Errors.sol';
import {IExecutor} from './utils/IExecutor.sol';

contract V2PolPoolConfiguratorTest is Test {
  V2L2ConfiguratorUpdatePayload public payload;

  address constant PAYLOADS_CONTROLLER = 0x401B5D0294E23637c18fcc38b1Bca814CDa2637C;
  address constant EXECUTOR_LVL_1 = 0xDf7d0e6454DB638881302729F5ba99936EaAB233;
  address constant EMERGENCY_ADMIN = 0x1450F2898D6bA2710C98BE9CAF3041330eD5ae58;
  address constant POOL_ADMIN = EXECUTOR_LVL_1;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 49650624);
    _deployAndExecutePayload();
  }

  function test_reverts_freezeReserve(address caller) public {
    vm.assume(caller != EMERGENCY_ADMIN && caller != POOL_ADMIN);

    vm.expectRevert(bytes(Errors.LPC_CALLER_NOT_POOL_OR_EMERGENCY_ADMIN));
    vm.startPrank(caller);
    AaveV2Polygon.POOL_CONFIGURATOR.freezeReserve(AaveV2PolygonAssets.USDC_UNDERLYING);
    vm.stopPrank();
  }

  function test_reverts_unfreezeReserve(address caller) public {
    vm.assume(caller != EMERGENCY_ADMIN && caller != POOL_ADMIN);

    vm.expectRevert(bytes(Errors.LPC_CALLER_NOT_POOL_OR_EMERGENCY_ADMIN));
    vm.startPrank(caller);
    AaveV2Polygon.POOL_CONFIGURATOR.unfreezeReserve(AaveV2PolygonAssets.USDC_UNDERLYING);
    vm.stopPrank();
  }

  function test_freezeReserve_emergencyAdmin() public {
    vm.startPrank(EMERGENCY_ADMIN);
    AaveV2Polygon.POOL_CONFIGURATOR.freezeReserve(AaveV2PolygonAssets.USDC_UNDERLYING);
    vm.stopPrank();

    (, , , , , , , , , bool isFrozen) = AaveV2Polygon
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveConfigurationData(AaveV2PolygonAssets.USDC_UNDERLYING);
    assertEq(isFrozen, true);
  }

  function test_freezeReserve_poolAdmin() public {
    vm.startPrank(POOL_ADMIN);
    AaveV2Polygon.POOL_CONFIGURATOR.freezeReserve(AaveV2PolygonAssets.USDC_UNDERLYING);
    vm.stopPrank();

    (, , , , , , , , , bool isFrozen) = AaveV2Polygon
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveConfigurationData(AaveV2PolygonAssets.USDC_UNDERLYING);
    assertEq(isFrozen, true);
  }

  function test_unfreezeReserve_emergencyAdmin() public {
    vm.startPrank(EMERGENCY_ADMIN);
    AaveV2Polygon.POOL_CONFIGURATOR.unfreezeReserve(AaveV2PolygonAssets.USDC_UNDERLYING);
    vm.stopPrank();

    (, , , , , , , , , bool isFrozen) = AaveV2Polygon
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveConfigurationData(AaveV2PolygonAssets.USDC_UNDERLYING);
    assertEq(isFrozen, false);
  }

  function test_unfreezeReserve_poolAdmin() public {
    vm.startPrank(POOL_ADMIN);
    AaveV2Polygon.POOL_CONFIGURATOR.unfreezeReserve(AaveV2PolygonAssets.USDC_UNDERLYING);
    vm.stopPrank();

    (, , , , , , , , , bool isFrozen) = AaveV2Polygon
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveConfigurationData(AaveV2PolygonAssets.USDC_UNDERLYING);
    assertEq(isFrozen, false);
  }

  function _deployAndExecutePayload() internal {
    DeployPolygon script = new DeployPolygon();
    script.run();

    payload = script.payload();
    hoax(PAYLOADS_CONTROLLER);
    IExecutor(EXECUTOR_LVL_1).executeTransaction(address(payload), 0, 'execute()', bytes(''), true);
  }
}
