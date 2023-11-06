// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;

import 'forge-std/Test.sol';
import {BaseDeploy, StableToken} from '../scripts/DeploySTokenV2Eth.s.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {DataTypes} from 'aave-address-book/AaveV2.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';
import {IERC20Detailed} from '../src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';

struct TokenToUpdate {
  address underlyingAsset;
  address newSTokenImpl;
}

contract V2EthSTokenTest is BaseDeploy, Test {
  address constant USER_1 = address(1249182);
  address constant USER_2 = address(3568);

  address COLLATERAL_TOKEN = AaveV2EthereumAssets.DAI_UNDERLYING;

  address EXECUTOR = 0x5300A1a15135EA4dc7aD5a167152C01EFc9b192A;

  address payload;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18511827);

    // unpause pool
    hoax(MiscEthereum.PROTOCOL_GUARDIAN);
    AaveV2Ethereum.POOL_CONFIGURATOR.setPoolPause(false);
  }

  function testTokensWorkBeforePayload() public {
    StableToken[] memory newTokenImpl = _deploy();
    for (uint256 i = 0; i < newTokenImpl.length; i++) {
      if (newTokenImpl[i].newSTImpl != address(0)) {
        (, address stableDebtTokenAddress, ) = AaveV2Ethereum
          .AAVE_PROTOCOL_DATA_PROVIDER
          .getReserveTokensAddresses(newTokenImpl[i].underlying);

        _unfreezeTokens(newTokenImpl[i].underlying);
        _enableBorrowingToken(newTokenImpl[i].underlying);

        // test token
        console.log(IERC20Detailed(stableDebtTokenAddress).symbol());
        _generateStableDebt(newTokenImpl[i].underlying, USER_1);
        _rebalance(USER_2, USER_1, newTokenImpl[i].underlying);
      }
    }
  }

//  function testTokensDontWorkAfterPayload() public {
//    StableToken[] memory newTokenImpl = _deploy();
//    TokenToUpdate[] memory tokensToUpdate = new TokenToUpdate[](newTokenImpl.length);
//
//    for (uint256 i = 0; i < newTokenImpl.length; i++) {
//      if (newTokenImpl[i].newSTImpl != address(0)) {
//        hoax(EXECUTOR); // executor lvl 1
//        AaveV2Ethereum.POOL_CONFIGURATOR.updateStableDebtToken(
//          newTokenImpl[i].underlying,
//          newTokenImpl[i].newSTImpl
//        );
//
//        // test token
//      }
//    }
//  }


  function _enableBorrowingToken(address underlying) internal {
    hoax(EXECUTOR);
    AaveV2Ethereum.POOL_CONFIGURATOR.enableBorrowingOnReserve(underlying, true);
  }

  function _unfreezeTokens(address underlying) internal {
    hoax(EXECUTOR);
    AaveV2Ethereum.POOL_CONFIGURATOR.unfreezeReserve(underlying);
  }

  function _dealUnderlying(address user, address underlying) internal {
    if (
      underlying == AaveV2EthereumAssets.USDC_UNDERLYING ||
      underlying == AaveV2EthereumAssets.USDT_UNDERLYING
    ) {
      deal(underlying, user, 1_000_000_000e6);
    } else if (underlying == AaveV2EthereumAssets.WBTC_UNDERLYING) {
      deal(underlying, user, 1_000_000_000e8);

    }else {
      deal(underlying, user, 1_000_000_000 ether);
    }
  }

  // generate revalancing for asset
  function _generateStableDebt(address stableUnderlying, address debtor) internal {
    // debtor supplies collateral
    _dealUnderlying(debtor, COLLATERAL_TOKEN);

    vm.startPrank(debtor);

    IERC20Detailed(COLLATERAL_TOKEN).approve(address(AaveV2Ethereum.POOL), type(uint256).max);
    AaveV2Ethereum.POOL.deposit(COLLATERAL_TOKEN, IERC20Detailed(COLLATERAL_TOKEN).balanceOf(debtor), debtor, 0);

    // debtor takes stable debt
    if (
      stableUnderlying == AaveV2EthereumAssets.USDC_UNDERLYING ||
      stableUnderlying == AaveV2EthereumAssets.USDT_UNDERLYING
    ) {
      AaveV2Ethereum.POOL.borrow(stableUnderlying, 100e6, 1, 0, debtor);
    } else if (stableUnderlying == AaveV2EthereumAssets.WBTC_UNDERLYING) {
      AaveV2Ethereum.POOL.borrow(stableUnderlying, 100e8, 1, 0, debtor);

    }else {
      AaveV2Ethereum.POOL.borrow(stableUnderlying, 100 ether, 1, 0, debtor);
    }

    vm.stopPrank();
  }

  function _rebalance(address newBorrower, address debtor, address underlying) internal {
    (address aTokenAddress, , ) = AaveV2Ethereum
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveTokensAddresses(underlying);

    // get available liquidity
    uint256 availableLiquidity = IERC20Detailed(underlying).balanceOf(aTokenAddress);

    // new borrower borrows to move utilization to max
    _dealUnderlying(newBorrower, COLLATERAL_TOKEN);

    vm.startPrank(newBorrower);
    IERC20Detailed(COLLATERAL_TOKEN).approve(address(AaveV2Ethereum.POOL), type(uint256).max);
    AaveV2Ethereum.POOL.deposit(COLLATERAL_TOKEN, IERC20Detailed(COLLATERAL_TOKEN).balanceOf(newBorrower), newBorrower, 0);
    AaveV2Ethereum.POOL.borrow(underlying, availableLiquidity, 1, 0, newBorrower);

    vm.stopPrank();

    AaveV2Ethereum.POOL.rebalanceStableBorrowRate(underlying, debtor);
  }

  function _updateImplementation(address stableToken, address newImpl) internal {}
}
