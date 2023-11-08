// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import 'forge-std/Test.sol';
import {DeployMainnet} from 'scripts/DeployPoolConfigurator.s.sol';
import {V2PoolConfiguratorUpdatePayload} from 'src/payloads/V2PoolConfiguratorUpdatePayload.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {LendingPoolConfigurator} from 'src/v2EthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol';
import {Errors} from 'src/v2EthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/libraries/helpers/Errors.sol';
import {IExecutor} from './utils/IExecutor.sol';

contract V2EthPoolConfiguratorTest is Test {
  V2PoolConfiguratorUpdatePayload public payload;

  address constant PAYLOADS_CONTROLLER = 0xdAbad81aF85554E9ae636395611C58F7eC1aAEc5;
  address constant EXECUTOR_LVL_1 = 0x5300A1a15135EA4dc7aD5a167152C01EFc9b192A;
  address constant EMERGENCY_ADMIN = 0xCA76Ebd8617a03126B6FB84F9b1c1A0fB71C2633;
  address constant POOL_ADMIN = EXECUTOR_LVL_1;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18519554);
    _deployAndExecutePayload();
  }

  function test_reverts_freezeReserve(address caller) public {
    vm.assume(caller != EMERGENCY_ADMIN && caller != POOL_ADMIN);

    vm.expectRevert(bytes(Errors.CALLER_NOT_POOL_OR_EMERGENCY_ADMIN));
    vm.startPrank(caller);
    AaveV2Ethereum.POOL_CONFIGURATOR.freezeReserve(AaveV2EthereumAssets.USDC_UNDERLYING);
    vm.stopPrank();
  }

  function test_reverts_unfreezeReserve(address caller) public {
    vm.assume(caller != EMERGENCY_ADMIN && caller != POOL_ADMIN);

    vm.expectRevert(bytes(Errors.CALLER_NOT_POOL_OR_EMERGENCY_ADMIN));
    vm.startPrank(caller);
    AaveV2Ethereum.POOL_CONFIGURATOR.unfreezeReserve(AaveV2EthereumAssets.USDC_UNDERLYING);
    vm.stopPrank();
  }

  function test_freezeReserve_emergencyAdmin() public {
    vm.startPrank(EMERGENCY_ADMIN);
    AaveV2Ethereum.POOL_CONFIGURATOR.freezeReserve(AaveV2EthereumAssets.USDC_UNDERLYING);
    vm.stopPrank();

    (, , , , , , , , , bool isFrozen) = AaveV2Ethereum
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveConfigurationData(AaveV2EthereumAssets.USDC_UNDERLYING);
    assertEq(isFrozen, true);
  }

  function test_freezeReserve_poolAdmin() public {
    vm.startPrank(POOL_ADMIN);
    AaveV2Ethereum.POOL_CONFIGURATOR.freezeReserve(AaveV2EthereumAssets.USDC_UNDERLYING);
    vm.stopPrank();

    (, , , , , , , , , bool isFrozen) = AaveV2Ethereum
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveConfigurationData(AaveV2EthereumAssets.USDC_UNDERLYING);
    assertEq(isFrozen, true);
  }

  function test_unfreezeReserve_emergencyAdmin() public {
    vm.startPrank(EMERGENCY_ADMIN);
    AaveV2Ethereum.POOL_CONFIGURATOR.unfreezeReserve(AaveV2EthereumAssets.USDC_UNDERLYING);
    vm.stopPrank();

    (, , , , , , , , , bool isFrozen) = AaveV2Ethereum
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveConfigurationData(AaveV2EthereumAssets.USDC_UNDERLYING);
    assertEq(isFrozen, false);
  }

  function test_unfreezeReserve_poolAdmin() public {
    vm.startPrank(POOL_ADMIN);
    AaveV2Ethereum.POOL_CONFIGURATOR.unfreezeReserve(AaveV2EthereumAssets.USDC_UNDERLYING);
    vm.stopPrank();

    (, , , , , , , , , bool isFrozen) = AaveV2Ethereum
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveConfigurationData(AaveV2EthereumAssets.USDC_UNDERLYING);
    assertEq(isFrozen, false);
  }

  function _deployAndExecutePayload() internal {
    DeployMainnet script = new DeployMainnet();
    script.run();

    payload = script.payload();
    hoax(PAYLOADS_CONTROLLER);
    IExecutor(EXECUTOR_LVL_1).executeTransaction(address(payload), 0, 'execute()', bytes(''), true);
  }
}
