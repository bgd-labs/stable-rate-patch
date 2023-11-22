// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import {V2PoolConfiguratorTestBase} from './V2PoolConfiguratorTestBase.t.sol';
import {DeployConfiguratorLib} from 'scripts/DeployPoolConfigurator.s.sol';
import {ConfiguratorUpdatePayload} from 'src/payloads/ConfiguratorUpdatePayload.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {AaveV2EthereumAMM, AaveV2EthereumAMMAssets} from 'aave-address-book/AaveV2EthereumAMM.sol';
import {AaveV2Avalanche, AaveV2AvalancheAssets} from 'aave-address-book/AaveV2Avalanche.sol';
import {AaveV2Polygon, AaveV2PolygonAssets} from 'aave-address-book/AaveV2Polygon.sol';
import {IExecutor} from './utils/IExecutor.sol';

contract V2EthPoolConfiguratorTest is V2PoolConfiguratorTestBase {
  constructor()
    public
    V2PoolConfiguratorTestBase(
      0xdAbad81aF85554E9ae636395611C58F7eC1aAEc5, // PAYLOADS_CONTROLLER
      0x5300A1a15135EA4dc7aD5a167152C01EFc9b192A, // EXECUTOR_LVL_1
      0xCA76Ebd8617a03126B6FB84F9b1c1A0fB71C2633, // EMERGENCY_ADMIN
      address(AaveV2Ethereum.POOL_CONFIGURATOR),
      address(AaveV2Ethereum.AAVE_PROTOCOL_DATA_PROVIDER),
      AaveV2EthereumAssets.LINK_UNDERLYING, // FROZEN ASSET
      AaveV2EthereumAssets.USDC_UNDERLYING // NOT FROZEN ASSET
    )
  {}

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18519554);
    _deployAndExecutePayload();
  }

  function _deployAndExecutePayload() internal {
    address payload = DeployConfiguratorLib.deploy(address(AaveV2Ethereum.POOL_ADDRESSES_PROVIDER));
    hoax(PAYLOADS_CONTROLLER);
    IExecutor(EXECUTOR_LVL_1).executeTransaction(address(payload), 0, 'execute()', bytes(''), true);
  }
}

contract V2AmmEthPoolConfiguratorTest is V2PoolConfiguratorTestBase {
  constructor()
    public
    V2PoolConfiguratorTestBase(
      0xdAbad81aF85554E9ae636395611C58F7eC1aAEc5, // PAYLOADS_CONTROLLER
      0x5300A1a15135EA4dc7aD5a167152C01EFc9b192A, // EXECUTOR_LVL_1
      0xB9062896ec3A615a4e4444DF183F0531a77218AE, // EMERGENCY_ADMIN
      address(AaveV2EthereumAMM.POOL_CONFIGURATOR),
      0xc443AD9DDE3cecfB9dfC5736578f447aFE3590ba, // DATA_PROVIDER
      AaveV2EthereumAMMAssets.DAI_UNDERLYING, // FROZEN ASSET
      AaveV2EthereumAMMAssets.USDC_UNDERLYING // NOT FROZEN ASSET
    )
  {}

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18519554);

    // un-freeze USDC manually to test, as all assets are freezed in amm market
    vm.startPrank(0x5300A1a15135EA4dc7aD5a167152C01EFc9b192A);
    AaveV2EthereumAMM.POOL_CONFIGURATOR.unfreezeReserve(AaveV2EthereumAMMAssets.USDC_UNDERLYING);
    vm.stopPrank();

    _deployAndExecutePayload();
  }

  function _deployAndExecutePayload() internal {
    address payload = DeployConfiguratorLib.deploy(address(AaveV2EthereumAMM.POOL_ADDRESSES_PROVIDER));
    hoax(PAYLOADS_CONTROLLER);
    IExecutor(EXECUTOR_LVL_1).executeTransaction(address(payload), 0, 'execute()', bytes(''), true);
  }
}

contract V2PolPoolConfiguratorTest is V2PoolConfiguratorTestBase {
  constructor()
    public
    V2PoolConfiguratorTestBase(
      0x401B5D0294E23637c18fcc38b1Bca814CDa2637C, // PAYLOADS_CONTROLLER
      0xDf7d0e6454DB638881302729F5ba99936EaAB233, // EXECUTOR_LVL_1
      0x1450F2898D6bA2710C98BE9CAF3041330eD5ae58, // EMERGENCY_ADMIN
      address(AaveV2Polygon.POOL_CONFIGURATOR),
      address(AaveV2Polygon.AAVE_PROTOCOL_DATA_PROVIDER),
      AaveV2PolygonAssets.LINK_UNDERLYING, // FROZEN ASSET
      AaveV2PolygonAssets.USDC_UNDERLYING // NOT FROZEN ASSET
    )
  {}

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 49650624);
    _deployAndExecutePayload();
  }

  function _deployAndExecutePayload() internal {
    address payload = DeployConfiguratorLib.deploy(address(AaveV2Polygon.POOL_ADDRESSES_PROVIDER));
    hoax(PAYLOADS_CONTROLLER);
    IExecutor(EXECUTOR_LVL_1).executeTransaction(address(payload), 0, 'execute()', bytes(''), true);
  }
}

contract V2AvaPoolConfiguratorTest is V2PoolConfiguratorTestBase {
  constructor()
    public
    V2PoolConfiguratorTestBase(
      0x1140CB7CAfAcC745771C2Ea31e7B5C653c5d0B80, // PAYLOADS_CONTROLLER
      0x3C06dce358add17aAf230f2234bCCC4afd50d090, // EXECUTOR_LVL_1
      0xa35b76E4935449E33C56aB24b23fcd3246f13470, // EMERGENCY_ADMIN
      address(AaveV2Avalanche.POOL_CONFIGURATOR),
      address(AaveV2Avalanche.AAVE_PROTOCOL_DATA_PROVIDER),
      AaveV2AvalancheAssets.USDCe_UNDERLYING, // FROZEN ASSET
      AaveV2AvalancheAssets.WETHe_UNDERLYING // NOT FROZEN ASSET
    )
  {}

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), 37450260);

    // freeze USDC manually to test, as all assets are un-freezed in v2 ava market
    vm.startPrank(0x3C06dce358add17aAf230f2234bCCC4afd50d090);
    AaveV2Avalanche.POOL_CONFIGURATOR.freezeReserve(AaveV2AvalancheAssets.USDCe_UNDERLYING);
    vm.stopPrank();

    _deployAndExecutePayload();
  }

  function _deployAndExecutePayload() internal {
    address payload = DeployConfiguratorLib.deploy(address(AaveV2Avalanche.POOL_ADDRESSES_PROVIDER));
    hoax(PAYLOADS_CONTROLLER);
    IExecutor(EXECUTOR_LVL_1).executeTransaction(address(payload), 0, 'execute()', bytes(''), true);
  }
}
