// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import {Script} from 'forge-std/Script.sol';
import {console} from 'forge-std/console.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {AaveV2EthereumAMM} from 'aave-address-book/AaveV2EthereumAMM.sol';
import {AaveV2Polygon} from 'aave-address-book/AaveV2Polygon.sol';
import {AaveV2Avalanche} from 'aave-address-book/AaveV2Avalanche.sol';
import {LendingPoolConfigurator as EthPoolConfigurator, ILendingPoolAddressesProvider as IEthLendingPoolAddressesProvider} from 'src/v2EthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol';
import {LendingPoolConfigurator as EthAmmPoolConfigurator, ILendingPoolAddressesProvider as IEthAmmLendingPoolAddressesProvider} from 'src/v2AmmEthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol';
import {LendingPoolConfigurator as PolPoolConfigurator, ILendingPoolAddressesProvider as IPolLendingPoolAddressesProvider} from 'src/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol';
import {LendingPoolConfigurator as AvaPoolConfigurator, ILendingPoolAddressesProvider as IAvaLendingPoolAddressesProvider} from 'src/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol';

import {V2EthConfiguratorUpdatePayload} from 'src/payloads/V2EthConfiguratorUpdatePayload.sol';
import {V2L2ConfiguratorUpdatePayload} from 'src/payloads/V2L2ConfiguratorUpdatePayload.sol';

contract DeployMainnet is Script {
  EthPoolConfigurator public poolConfigurator;
  EthAmmPoolConfigurator public ammPoolConfigurator;
  V2EthConfiguratorUpdatePayload public payload;

  function run() external {
    vm.startBroadcast();
    poolConfigurator = new EthPoolConfigurator();
    poolConfigurator.initialize(
      IEthLendingPoolAddressesProvider(address(AaveV2Ethereum.POOL_ADDRESSES_PROVIDER))
    );

    ammPoolConfigurator = new EthAmmPoolConfigurator();
    ammPoolConfigurator.initialize(
      IEthAmmLendingPoolAddressesProvider(address(AaveV2EthereumAMM.POOL_ADDRESSES_PROVIDER))
    );

    payload = new V2EthConfiguratorUpdatePayload(
      address(AaveV2Ethereum.POOL_ADDRESSES_PROVIDER),
      address(poolConfigurator),
      address(AaveV2EthereumAMM.POOL_ADDRESSES_PROVIDER),
      address(ammPoolConfigurator)
    );
    vm.stopBroadcast();

    console.log('Mainnet Pool Configurator Impl address', address(poolConfigurator));
    console.log('Mainnet Payload address', address(payload));
  }
}

contract DeployPolygon is Script {
  PolPoolConfigurator public poolConfigurator;
  V2L2ConfiguratorUpdatePayload public payload;

  function run() external {
    vm.startBroadcast();
    poolConfigurator = new PolPoolConfigurator();
    poolConfigurator.initialize(
      IPolLendingPoolAddressesProvider(address(AaveV2Polygon.POOL_ADDRESSES_PROVIDER))
    );

    payload = new V2L2ConfiguratorUpdatePayload(
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
  V2L2ConfiguratorUpdatePayload public payload;

  function run() external {
    vm.startBroadcast();
    poolConfigurator = new AvaPoolConfigurator();
    poolConfigurator.initialize(
      IAvaLendingPoolAddressesProvider(address(AaveV2Avalanche.POOL_ADDRESSES_PROVIDER))
    );

    payload = new V2L2ConfiguratorUpdatePayload(
      address(AaveV2Avalanche.POOL_ADDRESSES_PROVIDER),
      address(poolConfigurator)
    );
    vm.stopBroadcast();

    console.log('Avalanche Pool Configurator Impl address', address(poolConfigurator));
    console.log('Avalanche Payload address', address(payload));
  }
}
