// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import 'forge-std/Test.sol';
import {Errors} from 'src/v2AmmEthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/libraries/helpers/Errors.sol';
import {ILendingPoolConfigurator, IAaveProtocolDataProvider} from 'aave-address-book/AaveV2.sol';

abstract contract V2PoolConfiguratorTestBase is Test {
  address immutable PAYLOADS_CONTROLLER;
  address immutable EXECUTOR_LVL_1;
  address immutable EMERGENCY_ADMIN;
  address immutable POOL_ADMIN;
  address immutable POOL_CONFIGURATOR;
  address immutable UNDERLYING_ASSET_FROZEN;
  address immutable UNDERLYING_ASSET_NOT_FROZEN;
  address immutable DATA_PROVIDER;
  address immutable ADDRESSES_PROVIDER;

  constructor(
    address payloadsController,
    address executorLvl1,
    address emergencyAdmin,
    address poolConfigurator,
    address addressesProvider,
    address dataProvider,
    address underlyingAssetFrozen,
    address underlyingAssetNotfrozen
  ) public {
    PAYLOADS_CONTROLLER = payloadsController;
    EXECUTOR_LVL_1 = executorLvl1;
    POOL_ADMIN = executorLvl1;
    EMERGENCY_ADMIN = emergencyAdmin;
    POOL_CONFIGURATOR = poolConfigurator;
    ADDRESSES_PROVIDER = addressesProvider;
    UNDERLYING_ASSET_FROZEN = underlyingAssetFrozen;
    UNDERLYING_ASSET_NOT_FROZEN = underlyingAssetNotfrozen;
    DATA_PROVIDER = dataProvider;
  }

  function test_reverts_freezeReserve(address caller) public {
    vm.assume(caller != EMERGENCY_ADMIN && caller != POOL_ADMIN && caller != ADDRESSES_PROVIDER);

    vm.expectRevert(bytes(Errors.LPC_CALLER_NOT_POOL_OR_EMERGENCY_ADMIN));
    vm.startPrank(caller);
    ILendingPoolConfigurator(POOL_CONFIGURATOR).freezeReserve(UNDERLYING_ASSET_NOT_FROZEN);
    vm.stopPrank();
  }

  function test_reverts_unfreezeReserve(address caller) public {
    vm.assume(caller != EMERGENCY_ADMIN && caller != POOL_ADMIN && caller != ADDRESSES_PROVIDER);

    vm.expectRevert(bytes(Errors.LPC_CALLER_NOT_POOL_OR_EMERGENCY_ADMIN));
    vm.startPrank(caller);
    ILendingPoolConfigurator(POOL_CONFIGURATOR).unfreezeReserve(UNDERLYING_ASSET_NOT_FROZEN);
    vm.stopPrank();
  }

  function test_freezeReserve_emergencyAdmin() public {
    (, , , , , , , , , bool isFrozenBefore) = IAaveProtocolDataProvider(DATA_PROVIDER)
      .getReserveConfigurationData(UNDERLYING_ASSET_NOT_FROZEN);
    assertEq(isFrozenBefore, false);

    vm.startPrank(EMERGENCY_ADMIN);
    ILendingPoolConfigurator(POOL_CONFIGURATOR).freezeReserve(UNDERLYING_ASSET_NOT_FROZEN);
    vm.stopPrank();

    (, , , , , , , , , bool isFrozenAfter) = IAaveProtocolDataProvider(DATA_PROVIDER)
      .getReserveConfigurationData(UNDERLYING_ASSET_NOT_FROZEN);
    assertEq(isFrozenAfter, true);
  }

  function test_freezeReserve_poolAdmin() public {
    (, , , , , , , , , bool isFrozenBefore) = IAaveProtocolDataProvider(DATA_PROVIDER)
      .getReserveConfigurationData(UNDERLYING_ASSET_NOT_FROZEN);
    assertEq(isFrozenBefore, false);

    vm.startPrank(POOL_ADMIN);
    ILendingPoolConfigurator(POOL_CONFIGURATOR).freezeReserve(UNDERLYING_ASSET_NOT_FROZEN);
    vm.stopPrank();

    (, , , , , , , , , bool isFrozenAfter) = IAaveProtocolDataProvider(DATA_PROVIDER)
      .getReserveConfigurationData(UNDERLYING_ASSET_NOT_FROZEN);
    assertEq(isFrozenAfter, true);
  }

  function test_unfreezeReserve_emergencyAdmin() public {
    (, , , , , , , , , bool isFrozenBefore) = IAaveProtocolDataProvider(DATA_PROVIDER)
      .getReserveConfigurationData(UNDERLYING_ASSET_FROZEN);
    assertEq(isFrozenBefore, true);

    vm.startPrank(EMERGENCY_ADMIN);
    ILendingPoolConfigurator(POOL_CONFIGURATOR).unfreezeReserve(UNDERLYING_ASSET_FROZEN);
    vm.stopPrank();

    (, , , , , , , , , bool isFrozenAfter) = IAaveProtocolDataProvider(DATA_PROVIDER)
      .getReserveConfigurationData(UNDERLYING_ASSET_FROZEN);
    assertEq(isFrozenAfter, false);
  }

  function test_unfreezeReserve_poolAdmin() public {
    (, , , , , , , , , bool isFrozenBefore) = IAaveProtocolDataProvider(DATA_PROVIDER)
      .getReserveConfigurationData(UNDERLYING_ASSET_FROZEN);
    assertEq(isFrozenBefore, true);

    vm.startPrank(POOL_ADMIN);
    ILendingPoolConfigurator(POOL_CONFIGURATOR).unfreezeReserve(UNDERLYING_ASSET_FROZEN);
    vm.stopPrank();

    (, , , , , , , , , bool isFrozen) = IAaveProtocolDataProvider(DATA_PROVIDER)
      .getReserveConfigurationData(UNDERLYING_ASSET_FROZEN);
    assertEq(isFrozen, false);
  }
}
