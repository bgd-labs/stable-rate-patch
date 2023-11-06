// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;
pragma experimental ABIEncoderV2;

import 'forge-std/Test.sol';
import {BaseDeploy, StableToken} from '../scripts/DeploySTokenV2Eth.s.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {DataTypes} from 'aave-address-book/AaveV2.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';
import {IERC20Detailed} from '../src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';
import {SafeERC20, IERC20} from '../src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/dependencies/openzeppelin/contracts/SafeERC20.sol';

struct TokenToUpdate {
  address underlyingAsset;
  address newSTokenImpl;
}

contract V2EthSTokenTest is BaseDeploy, Test {
  address constant USER_1 = address(1249182);
  address constant USER_2 = address(3568);
  address constant USER_3 = address(13057);

  address COLLATERAL_TOKEN = AaveV2EthereumAssets.DAI_UNDERLYING;

  address EXECUTOR = 0x5300A1a15135EA4dc7aD5a167152C01EFc9b192A;

  address payload;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18511827);

    // unpause pool
    hoax(MiscEthereum.PROTOCOL_GUARDIAN);
    AaveV2Ethereum.POOL_CONFIGURATOR.setPoolPause(false);
  }

  //    function testRebalanceBeforePayload() public {
  //      StableToken[] memory newTokenImpl = _deploy();
  //      for (uint256 i = 0; i < newTokenImpl.length; i++) {
  //      uint256 i = 0;
  //        if (newTokenImpl[i].newSTImpl != address(0)) {
  //          (address aToken, address stableDebtTokenAddress, ) = AaveV2Ethereum
  //            .AAVE_PROTOCOL_DATA_PROVIDER
  //            .getReserveTokensAddresses(newTokenImpl[i].underlying);
  //
  //          _unfreezeTokens(newTokenImpl[i].underlying);
  //          _enableBorrowingToken(newTokenImpl[i].underlying);
  //
  //          // test token
  //          console.log(IERC20Detailed(stableDebtTokenAddress).symbol());
  //
  //          _supplyTokens(newTokenImpl[i].underlying, USER_3);
  //          _generateStableDebt(newTokenImpl[i].underlying, USER_1, aToken); // user 1 borrows stable
  //          _generateStableDebt(newTokenImpl[i].underlying, USER_1, aToken); // user 1 borrows stable
  //          _generateStableDebt(newTokenImpl[i].underlying, USER_1, aToken); // user 1 borrows stable
  //          _withdrawToken(newTokenImpl[i].underlying, USER_3, aToken);
  //          AaveV2Ethereum.POOL.rebalanceStableBorrowRate(newTokenImpl[i].underlying, USER_1);
  //        }
  //      }
  //    }

    function testRebalanceAfterPayload() public {
      StableToken[] memory newTokenImpl = _deploy();
      TokenToUpdate[] memory tokensToUpdate = new TokenToUpdate[](newTokenImpl.length);

      for (uint256 i = 0; i < newTokenImpl.length; i++) {

        if (newTokenImpl[i].newSTImpl != address(0)
        ) {
          DataTypes.ReserveData memory data = AaveV2Ethereum.POOL.getReserveData(newTokenImpl[i].underlying);

          (address aToken, address stableDebtTokenAddress, ) = AaveV2Ethereum
            .AAVE_PROTOCOL_DATA_PROVIDER
            .getReserveTokensAddresses(newTokenImpl[i].underlying);

          _unfreezeTokens(newTokenImpl[i].underlying);
          _enableBorrowingToken(newTokenImpl[i].underlying);

          _supplyTokens(newTokenImpl[i].underlying, USER_3);
          _generateStableDebt(newTokenImpl[i].underlying, USER_1, aToken); // user 1 borrows stable
          _generateStableDebt(newTokenImpl[i].underlying, USER_1, aToken); // user 1 borrows stable
          _generateStableDebt(newTokenImpl[i].underlying, USER_1, aToken); // user 1 borrows stable
          _withdrawToken(newTokenImpl[i].underlying, USER_3, aToken);

          _updateImplementation(newTokenImpl[i].underlying, newTokenImpl[i].newSTImpl);

          vm.mockCall(
            data.interestRateStrategyAddress,
            abi.encodeWithSignature('getMaxVariableBorrowRate()'),
            abi.encode(100000)
          );
          vm.expectRevert(bytes('STABLE_BORROWING_DEPRECATED'));
          AaveV2Ethereum.POOL.rebalanceStableBorrowRate(newTokenImpl[i].underlying, USER_1);
        }
      }
    }

//    function testBorrowAfterPayload() public {
//      StableToken[] memory newTokenImpl = _deploy();
//      TokenToUpdate[] memory tokensToUpdate = new TokenToUpdate[](newTokenImpl.length);
//
//      for (uint256 i = 0; i < newTokenImpl.length; i++) {
//        if (newTokenImpl[i].newSTImpl != address(0)) {
//          (address aToken, address stableDebtTokenAddress, ) = AaveV2Ethereum
//            .AAVE_PROTOCOL_DATA_PROVIDER
//            .getReserveTokensAddresses(newTokenImpl[i].underlying);
//
//          _unfreezeTokens(newTokenImpl[i].underlying);
//          _enableBorrowingToken(newTokenImpl[i].underlying);
//
//          _supplyTokens(newTokenImpl[i].underlying, USER_3);
//
//          _updateImplementation(newTokenImpl[i].underlying, newTokenImpl[i].newSTImpl);
//
//          // debtor supplies collateral
//          _supplyTokens(COLLATERAL_TOKEN, USER_1);
//
//          vm.startPrank(USER_1);
//          // get available liquidity
//          uint256 availableLiquidity = IERC20Detailed(newTokenImpl[i].underlying).balanceOf(aToken);
//          vm.expectRevert(bytes('STABLE_BORROWING_DEPRECATED'));
//          AaveV2Ethereum.POOL.borrow(newTokenImpl[i].underlying, 5, 1, 0, USER_1);
//
//          vm.stopPrank();
//
//        }
//      }
//    }

//  function testSwapAfterPayload() public {
//    StableToken[] memory newTokenImpl = _deploy();
//
//    for (uint256 i = 0; i < newTokenImpl.length; i++) {
//      if (newTokenImpl[i].newSTImpl == address(0)) {continue;}
//        (address aToken, address stableDebtTokenAddress, ) = AaveV2Ethereum
//          .AAVE_PROTOCOL_DATA_PROVIDER
//          .getReserveTokensAddresses(newTokenImpl[i].underlying);
//
//        _unfreezeTokens(newTokenImpl[i].underlying);
//        _enableBorrowingToken(newTokenImpl[i].underlying);
//
//        _supplyTokens(newTokenImpl[i].underlying, USER_3);
//
//        _supplyTokens(COLLATERAL_TOKEN, USER_1);
//
//        hoax(USER_1);
//        AaveV2Ethereum.POOL.borrow(newTokenImpl[i].underlying, 10, 2, 0, USER_1);
//
//        _updateImplementation(newTokenImpl[i].underlying, newTokenImpl[i].newSTImpl);
//
//        hoax(USER_1);
//        vm.expectRevert(bytes('STABLE_BORROWING_DEPRECATED'));
//        AaveV2Ethereum.POOL.swapBorrowRateMode(newTokenImpl[i].underlying, 2);
//
//    }
//  }

  function _withdrawToken(address underlying, address user, address aToken) internal {
    vm.startPrank(user);

    uint256 availableLiquidity = IERC20Detailed(underlying).balanceOf(aToken);
    AaveV2Ethereum.POOL.withdraw(underlying, availableLiquidity, user);

    vm.stopPrank();
  }

  function _supplyTokens(address underlying, address user) internal {
    _dealUnderlying(user, underlying);

    vm.startPrank(user);
    SafeERC20.safeApprove(IERC20(underlying), address(AaveV2Ethereum.POOL), type(uint256).max);
    AaveV2Ethereum.POOL.deposit(underlying, IERC20Detailed(underlying).balanceOf(user), user, 0);
    vm.stopPrank();
  }

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
      deal(underlying, user, 1_000_000e8);
    } else {
      deal(underlying, user, 1_000_000_000 ether);
    }
  }

  // generate revalancing for asset
  function _generateStableDebt(address stableUnderlying, address debtor, address aToken) internal {
    // debtor supplies collateral
    _supplyTokens(COLLATERAL_TOKEN, debtor);

    vm.startPrank(debtor);
    // get available liquidity
    uint256 availableLiquidity = IERC20Detailed(stableUnderlying).balanceOf(aToken);
    AaveV2Ethereum.POOL.borrow(stableUnderlying, availableLiquidity / 5, 1, 0, debtor);

    vm.stopPrank();
  }

  function _updateImplementation(address underlying, address newImpl) internal {
    hoax(EXECUTOR); // executor lvl 1
    AaveV2Ethereum.POOL_CONFIGURATOR.updateStableDebtToken(underlying, newImpl);
  }
}
