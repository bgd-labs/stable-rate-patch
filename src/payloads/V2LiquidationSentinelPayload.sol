// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;

import {ILendingPoolAddressesProvider} from 'aave-address-book/AaveV2.sol';

contract V2LiquidationSentinelPayload {
  address public immutable NEW_COLLATERAL_MANAGER;
  ILendingPoolAddressesProvider public immutable POOL_ADDRESSES_PROVIDER;

  constructor(address collateralManager, ILendingPoolAddressesProvider addressesProvider) public {
    NEW_COLLATERAL_MANAGER = collateralManager;
    POOL_ADDRESSES_PROVIDER = addressesProvider;
  }

  function execute() public {
    POOL_ADDRESSES_PROVIDER.setLendingPoolCollateralManager(NEW_COLLATERAL_MANAGER);
  }
}
