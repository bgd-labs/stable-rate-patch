// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {BaseDeploy, StableDebtToken, StableToken} from '../scripts/DeploySTokenV3Opt.s.sol';
import {AaveV3Optimism, AaveV3OptimismAssets} from 'aave-address-book/AaveV3Optimism.sol';
import {DataTypes} from 'aave-address-book/AaveV3.sol';
import {MiscOptimism} from 'aave-address-book/MiscOptimism.sol';
import {GovernanceV3Optimism} from 'aave-address-book/GovernanceV3Optimism.sol';
import {IERC20} from 'solidity-utils/contracts/oz-common/interfaces/IERC20.sol';
import {ConfiguratorInputTypes, IPoolConfigurator} from 'aave-address-book/AaveV3.sol';
import {IERC20Detailed} from '../src/v3OptStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';

import {IExecutor} from './utils/IExecutor.sol';

interface IGetIncentivesController {
  function getIncentivesController() external returns (address);
}

contract V3OptSTokenTest is BaseDeploy, Test {
  address constant USER_1 = address(1249182);
  address constant USER_3 = address(13057);

  address COLLATERAL_TOKEN = AaveV3OptimismAssets.WETH_UNDERLYING;

  address EXECUTOR = GovernanceV3Optimism.EXECUTOR_LVL_1;

  address PAYLOADS_CONTROLLER = 0x0E1a3Af1f9cC76A62eD31eDedca291E63632e7c4;

  address payload = 0x4B02E9A575DFf2783568cE3DFD354736388D813d;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('optimism'), 111852513);

    // unpause pool
    hoax(MiscOptimism.PROTOCOL_GUARDIAN);
    AaveV3Optimism.POOL_CONFIGURATOR.setPoolPause(false);
  }

  function testRebalanceBeforePayload() public {
    StableToken[] memory newTokenImpl = _deploy();

    for (uint256 i = 0; i < newTokenImpl.length; i++) {
      if (newTokenImpl[i].newSTImpl != address(0)) {
        (address aToken, , ) = AaveV3Optimism.AAVE_PROTOCOL_DATA_PROVIDER.getReserveTokensAddresses(
          newTokenImpl[i].underlying
        );

        _removeSupplyCap(COLLATERAL_TOKEN);
        _removeBorrowCap(newTokenImpl[i].underlying);
        _removeSupplyCap(newTokenImpl[i].underlying);
        _unfreezeTokens(newTokenImpl[i].underlying);
        _enableBorrowingToken(newTokenImpl[i].underlying);

        uint256 totalLiquidity = IERC20Detailed(newTokenImpl[i].underlying).totalSupply();
        deal(newTokenImpl[i].underlying, USER_3, totalLiquidity * 11);

        vm.startPrank(USER_3);
        IERC20(newTokenImpl[i].underlying).approve(address(AaveV3Optimism.POOL), 0);
        IERC20(newTokenImpl[i].underlying).approve(address(AaveV3Optimism.POOL), type(uint256).max);
        AaveV3Optimism.POOL.deposit(newTokenImpl[i].underlying, totalLiquidity * 2, USER_3, 0);
        vm.stopPrank();

        _generateStableDebt(newTokenImpl[i].underlying, USER_1, aToken); // user 1 borrows stable
        _withdrawToken(newTokenImpl[i].underlying, USER_3, aToken);

        AaveV3Optimism.POOL.rebalanceStableBorrowRate(newTokenImpl[i].underlying, USER_1);
      }
    }
  }

  function testRebalanceAfterPayload() public {
    StableToken[] memory newTokenImpl = _deploy();

    for (uint256 i = 0; i < newTokenImpl.length; i++) {
      if (newTokenImpl[i].newSTImpl != address(0)) {
        uint256 snapshot = vm.snapshot();

        (address aToken, , ) = AaveV3Optimism.AAVE_PROTOCOL_DATA_PROVIDER.getReserveTokensAddresses(
          newTokenImpl[i].underlying
        );

        _removeSupplyCap(COLLATERAL_TOKEN);
        _removeBorrowCap(newTokenImpl[i].underlying);
        _removeSupplyCap(newTokenImpl[i].underlying);
        _unfreezeTokens(newTokenImpl[i].underlying);
        _enableBorrowingToken(newTokenImpl[i].underlying);

        uint256 totalLiquidity = IERC20Detailed(newTokenImpl[i].underlying).totalSupply();
        deal(newTokenImpl[i].underlying, USER_3, totalLiquidity * 11);

        vm.startPrank(USER_3);
        IERC20(newTokenImpl[i].underlying).approve(address(AaveV3Optimism.POOL), 0);
        IERC20(newTokenImpl[i].underlying).approve(address(AaveV3Optimism.POOL), type(uint256).max);
        AaveV3Optimism.POOL.deposit(newTokenImpl[i].underlying, totalLiquidity * 2, USER_3, 0);
        vm.stopPrank();

        _generateStableDebt(newTokenImpl[i].underlying, USER_1, aToken); // user 1 borrows stable
        _withdrawToken(newTokenImpl[i].underlying, USER_3, aToken);

        hoax(PAYLOADS_CONTROLLER);
        IExecutor(EXECUTOR).executeTransaction(payload, 0, 'execute()', bytes(''), true);

        vm.expectRevert(bytes('STABLE_BORROWING_DEPRECATED'));
        AaveV3Optimism.POOL.rebalanceStableBorrowRate(newTokenImpl[i].underlying, USER_1);
        vm.revertTo(snapshot);
      }
    }
  }

  function testBorrowAfterPayload() public {
    StableToken[] memory newTokenImpl = _deploy();

    for (uint256 i = 0; i < newTokenImpl.length; i++) {
      if (newTokenImpl[i].newSTImpl != address(0)) {
        uint256 snapshot = vm.snapshot();

        (address aToken, address stableDebtTokenAddress, ) = AaveV3Optimism
          .AAVE_PROTOCOL_DATA_PROVIDER
          .getReserveTokensAddresses(newTokenImpl[i].underlying);

        _removeSupplyCap(COLLATERAL_TOKEN);
        _removeBorrowCap(newTokenImpl[i].underlying);
        _removeSupplyCap(newTokenImpl[i].underlying);
        _unfreezeTokens(newTokenImpl[i].underlying);
        _enableBorrowingToken(newTokenImpl[i].underlying);

        _supplyTokens(newTokenImpl[i].underlying, USER_3);

        hoax(PAYLOADS_CONTROLLER);
        IExecutor(EXECUTOR).executeTransaction(payload, 0, 'execute()', bytes(''), true);

        // debtor supplies collateral
        _supplyTokens(COLLATERAL_TOKEN, USER_1);

        vm.startPrank(USER_1);
        // get available liquidity
        uint256 availableLiquidity = IERC20Detailed(newTokenImpl[i].underlying).balanceOf(aToken);
        vm.expectRevert(bytes('STABLE_BORROWING_DEPRECATED'));
        AaveV3Optimism.POOL.borrow(newTokenImpl[i].underlying, 5, 1, 0, USER_1);

        vm.stopPrank();
        vm.revertTo(snapshot);
      }
    }
  }

  function testSwapAfterPayload() public {
    StableToken[] memory newTokenImpl = _deploy();

    for (uint256 i = 0; i < newTokenImpl.length; i++) {
      if (newTokenImpl[i].newSTImpl == address(0)) {
        continue;
      }
      uint256 snapshot = vm.snapshot();

      (address aToken, address stableDebtTokenAddress, ) = AaveV3Optimism
        .AAVE_PROTOCOL_DATA_PROVIDER
        .getReserveTokensAddresses(newTokenImpl[i].underlying);

      _removeSupplyCap(COLLATERAL_TOKEN);
      _removeBorrowCap(newTokenImpl[i].underlying);
      _removeSupplyCap(newTokenImpl[i].underlying);
      _unfreezeTokens(newTokenImpl[i].underlying);
      _enableBorrowingToken(newTokenImpl[i].underlying);

      _supplyTokens(newTokenImpl[i].underlying, USER_3);

      _supplyTokens(COLLATERAL_TOKEN, USER_1);

      hoax(USER_1);
      AaveV3Optimism.POOL.borrow(newTokenImpl[i].underlying, 10, 2, 0, USER_1);

      hoax(PAYLOADS_CONTROLLER);
      IExecutor(EXECUTOR).executeTransaction(payload, 0, 'execute()', bytes(''), true);

      hoax(USER_1);
      vm.expectRevert(bytes('STABLE_BORROWING_DEPRECATED'));
      AaveV3Optimism.POOL.swapBorrowRateMode(newTokenImpl[i].underlying, 2);
      vm.revertTo(snapshot);
    }
  }

  function _withdrawToken(address underlying, address user, address aToken) internal {
    vm.startPrank(user);

    uint256 availableLiquidity = IERC20Detailed(underlying).balanceOf(aToken);
    AaveV3Optimism.POOL.withdraw(underlying, availableLiquidity, user);

    vm.stopPrank();
  }

  function _supplyTokens(address underlying, address user) internal {
    _dealUnderlying(user, underlying);

    vm.startPrank(user);
    IERC20(underlying).approve(address(AaveV3Optimism.POOL), 0);
    IERC20(underlying).approve(address(AaveV3Optimism.POOL), type(uint256).max);
    AaveV3Optimism.POOL.deposit(underlying, IERC20Detailed(underlying).balanceOf(user), user, 0);
    vm.stopPrank();
  }

  function _enableBorrowingToken(address underlying) internal {
    hoax(EXECUTOR);
    AaveV3Optimism.POOL_CONFIGURATOR.setReserveBorrowing(underlying, true);
    hoax(EXECUTOR);
    AaveV3Optimism.POOL_CONFIGURATOR.setReserveStableRateBorrowing(underlying, true);
  }

  function _unfreezeTokens(address underlying) internal {
    vm.startPrank(EXECUTOR);
    AaveV3Optimism.POOL_CONFIGURATOR.setReserveFreeze(underlying, false);
    vm.stopPrank();
  }

  function _dealUnderlying(address user, address underlying) internal {
    if (
      underlying == AaveV3OptimismAssets.USDC_UNDERLYING ||
      underlying == AaveV3OptimismAssets.USDT_UNDERLYING
    ) {
      deal(underlying, user, 1_000_000_000e6);
    } else if (underlying == AaveV3OptimismAssets.WBTC_UNDERLYING) {
      deal(underlying, user, 10_000_000_000e8);
    } else {
      deal(underlying, user, 10_000_000_000 ether);
    }
  }

  // generate revalancing for asset
  function _generateStableDebt(address stableUnderlying, address debtor, address aToken) internal {
    vm.startPrank(debtor);

    deal(COLLATERAL_TOKEN, debtor, 100_000_000_000 ether);
    IERC20(COLLATERAL_TOKEN).approve(address(AaveV3Optimism.POOL), 0);
    IERC20(COLLATERAL_TOKEN).approve(address(AaveV3Optimism.POOL), type(uint256).max);
    AaveV3Optimism.POOL.supply(
      COLLATERAL_TOKEN,
      IERC20Detailed(COLLATERAL_TOKEN).balanceOf(debtor),
      debtor,
      0
    );

    // get available liquidity
    uint256 availableLiquidity = IERC20Detailed(stableUnderlying).balanceOf(aToken);
    AaveV3Optimism.POOL.borrow(stableUnderlying, availableLiquidity / 5, 1, 0, debtor);

    vm.stopPrank();
  }

  function _updateImplementation(
    address underlying,
    address newImpl,
    address currentStableProxy
  ) internal {
    ConfiguratorInputTypes.UpdateDebtTokenInput memory input = ConfiguratorInputTypes
      .UpdateDebtTokenInput({
        asset: underlying,
        incentivesController: IGetIncentivesController(currentStableProxy)
          .getIncentivesController(),
        name: IERC20Detailed(currentStableProxy).name(),
        symbol: IERC20Detailed(currentStableProxy).symbol(),
        implementation: newImpl,
        params: bytes('')
      });

    hoax(EXECUTOR); // executor lvl 1
    AaveV3Optimism.POOL_CONFIGURATOR.updateStableDebtToken(input);
  }

  function _removeSupplyCap(address underlying) internal {
    startHoax(EXECUTOR);
    AaveV3Optimism.POOL_CONFIGURATOR.setSupplyCap(underlying, 0);
  }

  function _removeBorrowCap(address underlying) internal {
    startHoax(EXECUTOR);
    AaveV3Optimism.POOL_CONFIGURATOR.setBorrowCap(underlying, 0);
  }
}
