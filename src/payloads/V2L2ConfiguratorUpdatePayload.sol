// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12;

import {ILendingPoolAddressesProvider} from 'aave-address-book/AaveV2.sol';

contract V2L2ConfiguratorUpdatePayload {
  address public immutable NEW_POOL_CONFIGURATOR_IMPL;
  address public immutable POOL_ADDRESSES_PROVIDER;

  constructor(address poolAddressesProvider, address poolConfiguratorImpl) public {
    POOL_ADDRESSES_PROVIDER = poolAddressesProvider;
    NEW_POOL_CONFIGURATOR_IMPL = poolConfiguratorImpl;
  }

  function execute() public {
    ILendingPoolAddressesProvider(POOL_ADDRESSES_PROVIDER).setLendingPoolConfiguratorImpl(NEW_POOL_CONFIGURATOR_IMPL);
  }
}
