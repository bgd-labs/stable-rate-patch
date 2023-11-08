// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.0;

import {Script} from 'forge-std/Script.sol';
import {console} from 'forge-std/console.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {AaveV2Polygon} from 'aave-address-book/AaveV2Polygon.sol';
import {AaveV2Avalanche} from 'aave-address-book/AaveV2Avalanche.sol';
import {LendingPoolConfigurator as EthPoolConfigurator, ILendingPoolAddressesProvider as IEthLendingPoolAddressesProvider} from 'src/v2EthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol';
import {LendingPoolConfigurator as PolPoolConfigurator, ILendingPoolAddressesProvider as IPolLendingPoolAddressesProvider} from 'src/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol';
import {LendingPoolConfigurator as AvaPoolConfigurator, ILendingPoolAddressesProvider as IAvaLendingPoolAddressesProvider} from 'src/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol';

import {V2PoolConfiguratorUpdatePayload} from 'src/payloads/V2PoolConfiguratorUpdatePayload.sol';

contract DeployMainnet is Script {
  EthPoolConfigurator public poolConfigurator;
  V2PoolConfiguratorUpdatePayload public payload;

  function run() external {
    vm.startBroadcast();
    poolConfigurator = new EthPoolConfigurator();
    poolConfigurator.initialize(
      IEthLendingPoolAddressesProvider(address(AaveV2Ethereum.POOL_ADDRESSES_PROVIDER))
    );

    payload = new V2PoolConfiguratorUpdatePayload(
      address(AaveV2Ethereum.POOL_ADDRESSES_PROVIDER),
      address(poolConfigurator)
    );
    vm.stopBroadcast();

    console.log('Mainnet Pool Configurator Impl address', address(poolConfigurator));
    console.log('Mainnet Payload address', address(payload));
  }
}

contract DeployPolygon is Script {
  PolPoolConfigurator public poolConfigurator;
  V2PoolConfiguratorUpdatePayload public payload;

  function run() external {
    vm.startBroadcast();
    poolConfigurator = new PolPoolConfigurator();
    poolConfigurator.initialize(
      IPolLendingPoolAddressesProvider(address(AaveV2Polygon.POOL_ADDRESSES_PROVIDER))
    );

    payload = new V2PoolConfiguratorUpdatePayload(
      address(AaveV2Polygon.POOL_ADDRESSES_PROVIDER),
      address(poolConfigurator)
    );
    vm.stopBroadcast();

    console.log('Polygon Pool Configurator Impl address', address(poolConfigurator));
    console.log('Polygon Payload address', address(payload));
  }
}

contract DeployAvalanche is Script {
  AvaPoolConfigurator public poolConfigurator;
  V2PoolConfiguratorUpdatePayload public payload;

  function run() external {
    vm.startBroadcast();
    poolConfigurator = new AvaPoolConfigurator();
    poolConfigurator.initialize(
      IAvaLendingPoolAddressesProvider(address(AaveV2Avalanche.POOL_ADDRESSES_PROVIDER))
    );

    payload = new V2PoolConfiguratorUpdatePayload(
      address(AaveV2Avalanche.POOL_ADDRESSES_PROVIDER),
      address(poolConfigurator)
    );
    vm.stopBroadcast();

    console.log('Avalanche Pool Configurator Impl address', address(poolConfigurator));
    console.log('Avalanche Payload address', address(payload));
  }
}
