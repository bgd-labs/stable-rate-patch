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

import {V2EthConfiguratorUpdatePayload} from 'src/payloads/V2EthConfiguratorUpdatePayload.sol';
import {V2L2ConfiguratorUpdatePayload} from 'src/payloads/V2L2ConfiguratorUpdatePayload.sol';

library DeployConfiguratorEthLib {
  function deploy() internal returns (address) {
    EthPoolConfigurator poolConfigurator = new EthPoolConfigurator();
    poolConfigurator.initialize(
      IEthLendingPoolAddressesProvider(address(AaveV2Ethereum.POOL_ADDRESSES_PROVIDER))
    );

    EthAmmPoolConfigurator ammPoolConfigurator = new EthAmmPoolConfigurator();
    ammPoolConfigurator.initialize(
      IEthAmmLendingPoolAddressesProvider(address(AaveV2EthereumAMM.POOL_ADDRESSES_PROVIDER))
    );

    V2EthConfiguratorUpdatePayload payload = new V2EthConfiguratorUpdatePayload(
      address(AaveV2Ethereum.POOL_ADDRESSES_PROVIDER),
      address(poolConfigurator),
      address(AaveV2EthereumAMM.POOL_ADDRESSES_PROVIDER),
      address(ammPoolConfigurator)
    );

    console.log('Mainnet Pool Configurator Impl address', address(poolConfigurator));
    console.log('Mainnet AMM Pool Configurator Impl address', address(ammPoolConfigurator));
    console.log('Mainnet Payload address', address(payload));

    return address(payload);
  }
}

library DeployConfiguratorL2Lib {
  function deploy(address addressesProvider) internal returns (address) {
    // As the Pool Configurators are same for Eth Amm and v2 Avalanche and v2 Polygon we use the same code for them
    EthAmmPoolConfigurator poolConfigurator = new EthAmmPoolConfigurator();
    poolConfigurator.initialize(
      IEthAmmLendingPoolAddressesProvider(addressesProvider)
    );

    V2L2ConfiguratorUpdatePayload payload = new V2L2ConfiguratorUpdatePayload(
      addressesProvider,
      address(poolConfigurator)
    );

    console.log('L2 Pool Configurator Impl address', address(poolConfigurator));
    console.log('L2 Payload address', address(payload));

    return address(payload);
  }
}

contract DeployMainnet is Script {
  function run() external {
    vm.startBroadcast();
    DeployConfiguratorEthLib.deploy();
    vm.stopBroadcast();
  }
}

contract DeployPolygon is Script {
  function run() external {
    vm.startBroadcast();
    DeployConfiguratorL2Lib.deploy(address(AaveV2Polygon.POOL_ADDRESSES_PROVIDER));
    vm.stopBroadcast();
  }
}

contract DeployAvalanche is Script {
  function run() external {
    vm.startBroadcast();
    DeployConfiguratorL2Lib.deploy(address(AaveV2Avalanche.POOL_ADDRESSES_PROVIDER));
    vm.stopBroadcast();
  }
}
