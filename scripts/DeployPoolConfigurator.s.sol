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

import {ConfiguratorUpdatePayload} from 'src/payloads/ConfiguratorUpdatePayload.sol';

library DeployConfiguratorLib {
  function deploy(address addressesProvider) internal returns (address) {
    address poolConfigurator;

    if (addressesProvider == address(AaveV2Ethereum.POOL_ADDRESSES_PROVIDER)) {
      poolConfigurator = address(new EthPoolConfigurator());
      EthPoolConfigurator(poolConfigurator).initialize(
        IEthLendingPoolAddressesProvider(addressesProvider)
      );
    } else {
      // As the Pool Configurators are same for Eth Amm, v2 Avalanche and v2 Polygon we use the same code for them
      poolConfigurator = address(new EthAmmPoolConfigurator());
      EthAmmPoolConfigurator(poolConfigurator).initialize(
        IEthAmmLendingPoolAddressesProvider(addressesProvider)
      );
    }

    ConfiguratorUpdatePayload payload = new ConfiguratorUpdatePayload(
      addressesProvider,
      address(poolConfigurator)
    );

    console.log('Pool Configurator Impl address', address(poolConfigurator));
    console.log('Payload address', address(payload));

    return address(payload);
  }
}

contract DeployMainnet is Script {
  function run() external {
    vm.startBroadcast();
    DeployConfiguratorLib.deploy(address(AaveV2Ethereum.POOL_ADDRESSES_PROVIDER));
    vm.stopBroadcast();
  }
}

contract DeployMainnetAMM is Script {
  function run() external {
    vm.startBroadcast();
    DeployConfiguratorLib.deploy(address(AaveV2EthereumAMM.POOL_ADDRESSES_PROVIDER));
    vm.stopBroadcast();
  }
}

contract DeployPolygon is Script {
  function run() external {
    vm.startBroadcast();
    DeployConfiguratorLib.deploy(address(AaveV2Polygon.POOL_ADDRESSES_PROVIDER));
    vm.stopBroadcast();
  }
}

contract DeployAvalanche is Script {
  function run() external {
    vm.startBroadcast();
    DeployConfiguratorLib.deploy(address(AaveV2Avalanche.POOL_ADDRESSES_PROVIDER));
    vm.stopBroadcast();
  }
}
