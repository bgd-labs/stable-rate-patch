// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IPool} from 'aave-address-book/AaveV3.sol';
import {IAaveIncentivesController} from './IAaveIncentivesController.sol';

interface IDebtTokenBaseV2 {
  function initialize(uint8 decimals, string memory name, string memory symbol) external;
}

interface IDebtTokenBaseV3 {
  function initialize(
    IPool initializingPool,
    address underlyingAsset,
    IAaveIncentivesController incentivesController,
    uint8 debtTokenDecimals,
    string memory debtTokenName,
    string memory debtTokenSymbol,
    bytes calldata params
  ) external;
}
