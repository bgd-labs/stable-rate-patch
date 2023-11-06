// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;

import 'forge-std/Test.sol';
import {BaseDeploy,StableToken} from '../scripts/DeploySTokenV2Eth.s.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {DataTypes} from 'aave-address-book/AaveV2.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';
import {IERC20Detailed} from '../src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';


contract V2EthSTokenTest is BaseDeploy, Test {
  address constant USER_1 = address(1249182);
  address constant USER_2 = address(3568);

  address COLLATERAL_TOKEN = AaveV2EthereumAssets.DAI_UNDERLYING;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18511827);

    // unpause pool
    hoax(MiscEthereum.PROTOCOL_GUARDIAN);
    AaveV2Ethereum.POOL_CONFIGURATOR.setPoolPause(false);
  }

  function testNewTokensImpl() public {

    StableToken[] memory newTokenImpl = _deploy();
    for (uint256 i = 0; i < newTokenImpl.length; i++) {
      if (newTokenImpl[i].newSTImpl != address(0)) {}
    }
  }

  function _dealUnderlying(address user, address underlying) internal {
    deal(underlying, user, 10_000_000_000 ether);
  }

  // generate revalancing for asset
  function _generateStableDebt(address stableUnderlying, address debtor) internal {
    // debtor supplies collateral
    _dealUnderlying(debtor, COLLATERAL_TOKEN);
    hoax(debtor);
    AaveV2Ethereum.POOL.deposit(COLLATERAL_TOKEN, 1_000_000 ether, debtor, 0);

    // debtor takes stable debt
    hoax(debtor);
    AaveV2Ethereum.POOL.borrow(stableUnderlying, 100_000 ether, 1, 0, debtor);
  }

  function _rebalance(address newBorrower, address debtor, address underlying) internal {
    (address aTokenAddress, , ) = AaveV2Ethereum
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveTokensAddresses(underlying);

    // get available liquidity
    uint256 availableLiquidity = IERC20Detailed(underlying).balanceOf(
      aTokenAddress
    );

    // new borrower borrows to move utilization to max
    _dealUnderlying(newBorrower, COLLATERAL_TOKEN);
    hoax(newBorrower);
    AaveV2Ethereum.POOL.deposit(COLLATERAL_TOKEN, type(uint256).max, newBorrower, 0);

    hoax(newBorrower);
    AaveV2Ethereum.POOL.borrow(underlying, availableLiquidity, 2, 0, newBorrower);

    AaveV2Ethereum.POOL.rebalanceStableBorrowRate(underlying, debtor);

  }

  function _updateImplementation(address stableToken, address newImpl) internal {}
}
