// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import 'forge-std/Test.sol';
import {DeployAvalanche} from 'scripts/DeployPoolConfigurator.s.sol';
import {V2L2ConfiguratorUpdatePayload} from 'src/payloads/V2L2ConfiguratorUpdatePayload.sol';
import {AaveV2Avalanche, AaveV2AvalancheAssets} from 'aave-address-book/AaveV2Avalanche.sol';
import {LendingPoolConfigurator} from 'src/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol';
import {Errors} from 'src/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/protocol/libraries/helpers/Errors.sol';
import {IExecutor} from './utils/IExecutor.sol';

contract V2AvaPoolConfiguratorTest is Test {
  V2L2ConfiguratorUpdatePayload public payload;

  address constant PAYLOADS_CONTROLLER = 0x1140CB7CAfAcC745771C2Ea31e7B5C653c5d0B80;
  address constant EXECUTOR_LVL_1 = 0x3C06dce358add17aAf230f2234bCCC4afd50d090;
  address constant EMERGENCY_ADMIN = 0xa35b76E4935449E33C56aB24b23fcd3246f13470;
  address constant POOL_ADMIN = EXECUTOR_LVL_1;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), 37450260);
    _deployAndExecutePayload();
  }

  function test_reverts_freezeReserve(address caller) public {
    vm.assume(caller != EMERGENCY_ADMIN && caller != POOL_ADMIN);

    vm.expectRevert(bytes(Errors.LPC_CALLER_NOT_POOL_OR_EMERGENCY_ADMIN));
    vm.startPrank(caller);
    AaveV2Avalanche.POOL_CONFIGURATOR.freezeReserve(AaveV2AvalancheAssets.USDCe_UNDERLYING);
    vm.stopPrank();
  }

  function test_reverts_unfreezeReserve(address caller) public {
    vm.assume(caller != EMERGENCY_ADMIN && caller != POOL_ADMIN);

    vm.expectRevert(bytes(Errors.LPC_CALLER_NOT_POOL_OR_EMERGENCY_ADMIN));
    vm.startPrank(caller);
    AaveV2Avalanche.POOL_CONFIGURATOR.unfreezeReserve(AaveV2AvalancheAssets.USDCe_UNDERLYING);
    vm.stopPrank();
  }

  function test_freezeReserve_emergencyAdmin() public {
    vm.startPrank(EMERGENCY_ADMIN);
    AaveV2Avalanche.POOL_CONFIGURATOR.freezeReserve(AaveV2AvalancheAssets.USDCe_UNDERLYING);
    vm.stopPrank();

    (, , , , , , , , , bool isFrozen) = AaveV2Avalanche
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveConfigurationData(AaveV2AvalancheAssets.USDCe_UNDERLYING);
    assertEq(isFrozen, true);
  }

  function test_freezeReserve_poolAdmin() public {
    vm.startPrank(POOL_ADMIN);
    AaveV2Avalanche.POOL_CONFIGURATOR.freezeReserve(AaveV2AvalancheAssets.USDCe_UNDERLYING);
    vm.stopPrank();

    (, , , , , , , , , bool isFrozen) = AaveV2Avalanche
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveConfigurationData(AaveV2AvalancheAssets.USDCe_UNDERLYING);
    assertEq(isFrozen, true);
  }

  function test_unfreezeReserve_emergencyAdmin() public {
    vm.startPrank(EMERGENCY_ADMIN);
    AaveV2Avalanche.POOL_CONFIGURATOR.unfreezeReserve(AaveV2AvalancheAssets.USDCe_UNDERLYING);
    vm.stopPrank();

    (, , , , , , , , , bool isFrozen) = AaveV2Avalanche
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveConfigurationData(AaveV2AvalancheAssets.USDCe_UNDERLYING);
    assertEq(isFrozen, false);
  }

  function test_unfreezeReserve_poolAdmin() public {
    vm.startPrank(POOL_ADMIN);
    AaveV2Avalanche.POOL_CONFIGURATOR.unfreezeReserve(AaveV2AvalancheAssets.USDCe_UNDERLYING);
    vm.stopPrank();

    (, , , , , , , , , bool isFrozen) = AaveV2Avalanche
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveConfigurationData(AaveV2AvalancheAssets.USDCe_UNDERLYING);
    assertEq(isFrozen, false);
  }

  function _deployAndExecutePayload() internal {
    DeployAvalanche script = new DeployAvalanche();
    script.run();

    payload = script.payload();
    hoax(PAYLOADS_CONTROLLER);
    IExecutor(EXECUTOR_LVL_1).executeTransaction(address(payload), 0, 'execute()', bytes(''), true);
  }
}
