// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12;

import {ILendingPoolAddressesProvider} from 'aave-address-book/AaveV2.sol';

contract V2EthConfiguratorUpdatePayload {
  address public immutable NEW_V2_POOL_CONFIGURATOR_IMPL;
  address public immutable V2_POOL_ADDRESSES_PROVIDER;

  address public immutable NEW_V2_AMM_POOL_CONFIGURATOR_IMPL;
  address public immutable V2_AMM_POOL_ADDRESSES_PROVIDER;

  constructor(
    address v2PoolAddressesProvider,
    address v2PoolConfiguratorImpl,
    address v2AmmPoolAddressesProvider,
    address v2AmmPoolConfiguratorImpl
  ) public {
    V2_POOL_ADDRESSES_PROVIDER = v2PoolAddressesProvider;
    NEW_V2_POOL_CONFIGURATOR_IMPL = v2PoolConfiguratorImpl;

    V2_AMM_POOL_ADDRESSES_PROVIDER = v2AmmPoolAddressesProvider;
    NEW_V2_AMM_POOL_CONFIGURATOR_IMPL = v2AmmPoolConfiguratorImpl;
  }

  function execute() public {
    ILendingPoolAddressesProvider(V2_POOL_ADDRESSES_PROVIDER).setLendingPoolConfiguratorImpl(
      NEW_V2_POOL_CONFIGURATOR_IMPL
    );
    ILendingPoolAddressesProvider(V2_AMM_POOL_ADDRESSES_PROVIDER).setLendingPoolConfiguratorImpl(
      NEW_V2_AMM_POOL_CONFIGURATOR_IMPL
    );
  }
}
