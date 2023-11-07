// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface IDebtTokenBaseV2 {
  function initialize(uint8 decimals, string memory name, string memory symbol) {
    _setName(name);
    _setSymbol(symbol);
    _setDecimals(decimals);
  } external;
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