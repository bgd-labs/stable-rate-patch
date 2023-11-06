//// SPDX-License-Identifier: agpl-3.0
//pragma solidity ^0.8.0;
//
//import 'forge-std/Test.sol';
//import {BaseDeploy, StableDebtToken} from '../scripts/DeploySTokenV3Pol.s.sol';
//import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
//import {DataTypes} from 'aave-address-book/AaveV3.sol';
//import {MiscPolygon} from 'aave-address-book/MiscPolygon.sol';
//import {GovernanceV3Polygon} from  'aave-address-book/GovernanceV3Polygon.sol';
//import {IERC20Detailed} from '../src/v3PolStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';
//
//  struct TokenToUpdate {
//    address underlyingAsset;
//    address newSTokenImpl;
//  }
//
//contract V2EthSTokenTest is BaseDeploy, Test {
//  address constant USER_1 = address(1249182);
//  address constant USER_3 = address(13057);
//
//  address COLLATERAL_TOKEN = AaveV3PolygonAssets.DAI_UNDERLYING;
//
//  address EXECUTOR = GovernanceV3Polygon.EXECUTOR_LVL1;
//
//
//  function setUp() public {
//    vm.createSelectFork(vm.rpcUrl('polygon'), 49619935);
//
//    // unpause pool
//    hoax(MiscEthereum.PROTOCOL_GUARDIAN);
//    AaveV3Polygon.POOL_CONFIGURATOR.setPoolPause(false);
//  }
//
//
//  function testRebalanceBeforePayload() public {
//    StableDebtToken[] memory newTokenImpl = _deploy();
//
//    for (uint256 i = 0; i < newTokenImpl.length; i++) {
//      if (newTokenImpl[i].newSTImpl != address(0)
//      ) {
//        (address aToken, , ) = AaveV3Polygon
//          .AAVE_PROTOCOL_DATA_PROVIDER
//          .getReserveTokensAddresses(newTokenImpl[i].underlying);
//
//        _unfreezeTokens(newTokenImpl[i].underlying);
//        _enableBorrowingToken(newTokenImpl[i].underlying);
//
//        uint256 totalLiquidity = IERC20Detailed(newTokenImpl[i].underlying).totalSupply();
//        deal(newTokenImpl[i].underlying, USER_3, totalLiquidity * 11);
//
//
//        vm.startPrank(USER_3);
//        SafeERC20.safeApprove(IERC20(newTokenImpl[i].underlying), address(AaveV3Polygon.POOL), type(uint256).max);
//        AaveV3Polygon.POOL.deposit(newTokenImpl[i].underlying, totalLiquidity * 2, USER_3, 0);
//        vm.stopPrank();
//
//
//        _generateStableDebt(newTokenImpl[i].underlying, USER_1, aToken); // user 1 borrows stable
//        _withdrawToken(newTokenImpl[i].underlying, USER_3, aToken);
//
//
//        AaveV3Polygon.POOL.rebalanceStableBorrowRate(newTokenImpl[i].underlying, USER_1);
//      }
//    }
//  }
//
//  function testRebalanceAfterPayload() public {
//    StableDebtToken[] memory newTokenImpl = _deploy();
//
//    for (uint256 i = 0; i < newTokenImpl.length; i++) {
//      if (newTokenImpl[i].newSTImpl != address(0)
//      ) {
//        (address aToken, , ) = AaveV3Polygon
//          .AAVE_PROTOCOL_DATA_PROVIDER
//          .getReserveTokensAddresses(newTokenImpl[i].underlying);
//
//        _unfreezeTokens(newTokenImpl[i].underlying);
//        _enableBorrowingToken(newTokenImpl[i].underlying);
//
//        uint256 totalLiquidity = IERC20Detailed(newTokenImpl[i].underlying).totalSupply();
//        deal(newTokenImpl[i].underlying, USER_3, totalLiquidity * 11);
//
//
//        vm.startPrank(USER_3);
//        SafeERC20.safeApprove(IERC20(newTokenImpl[i].underlying), address(AaveV3Polygon.POOL), type(uint256).max);
//        AaveV3Polygon.POOL.deposit(newTokenImpl[i].underlying, totalLiquidity * 2, USER_3, 0);
//        vm.stopPrank();
//
//
//        _generateStableDebt(newTokenImpl[i].underlying, USER_1, aToken); // user 1 borrows stable
//        _withdrawToken(newTokenImpl[i].underlying, USER_3, aToken);
//
//        _updateImplementation(newTokenImpl[i].underlying, newTokenImpl[i].newSTImpl);
//
//        vm.expectRevert(bytes('STABLE_BORROWING_DEPRECATED'));
//        AaveV3Polygon.POOL.rebalanceStableBorrowRate(newTokenImpl[i].underlying, USER_1);
//      }
//    }
//  }
//
//  function testBorrowAfterPayload() public {
//    StableDebtToken[] memory newTokenImpl = _deploy();
//    TokenToUpdate[] memory tokensToUpdate = new TokenToUpdate[](newTokenImpl.length);
//
//    for (uint256 i = 0; i < newTokenImpl.length; i++) {
//      if (newTokenImpl[i].newSTImpl != address(0)) {
//        (address aToken, address stableDebtTokenAddress, ) = AaveV3Polygon
//          .AAVE_PROTOCOL_DATA_PROVIDER
//          .getReserveTokensAddresses(newTokenImpl[i].underlying);
//
//        _unfreezeTokens(newTokenImpl[i].underlying);
//        _enableBorrowingToken(newTokenImpl[i].underlying);
//
//        _supplyTokens(newTokenImpl[i].underlying, USER_3);
//
//        _updateImplementation(newTokenImpl[i].underlying, newTokenImpl[i].newSTImpl);
//
//        // debtor supplies collateral
//        _supplyTokens(COLLATERAL_TOKEN, USER_1);
//
//        vm.startPrank(USER_1);
//        // get available liquidity
//        uint256 availableLiquidity = IERC20Detailed(newTokenImpl[i].underlying).balanceOf(aToken);
//        vm.expectRevert(bytes('STABLE_BORROWING_DEPRECATED'));
//        AaveV3Polygon.POOL.borrow(newTokenImpl[i].underlying, 5, 1, 0, USER_1);
//
//        vm.stopPrank();
//
//      }
//    }
//  }
//
//  function testSwapAfterPayload() public {
//    StableDebtToken[] memory newTokenImpl = _deploy();
//
//    for (uint256 i = 0; i < newTokenImpl.length; i++) {
//      if (newTokenImpl[i].newSTImpl == address(0)) {continue;}
//      (address aToken, address stableDebtTokenAddress, ) = AaveV3Polygon
//        .AAVE_PROTOCOL_DATA_PROVIDER
//        .getReserveTokensAddresses(newTokenImpl[i].underlying);
//
//      _unfreezeTokens(newTokenImpl[i].underlying);
//      _enableBorrowingToken(newTokenImpl[i].underlying);
//
//      _supplyTokens(newTokenImpl[i].underlying, USER_3);
//
//      _supplyTokens(COLLATERAL_TOKEN, USER_1);
//
//      hoax(USER_1);
//      AaveV3Polygon.POOL.borrow(newTokenImpl[i].underlying, 10, 2, 0, USER_1);
//
//      _updateImplementation(newTokenImpl[i].underlying, newTokenImpl[i].newSTImpl);
//
//      hoax(USER_1);
//      vm.expectRevert(bytes('STABLE_BORROWING_DEPRECATED'));
//      AaveV3Polygon.POOL.swapBorrowRateMode(newTokenImpl[i].underlying, 2);
//
//    }
//  }
//
//  function _withdrawToken(address underlying, address user, address aToken) internal {
//    vm.startPrank(user);
//
//    uint256 availableLiquidity = IERC20Detailed(underlying).balanceOf(aToken);
//    AaveV3Polygon.POOL.withdraw(underlying, availableLiquidity, user);
//
//    vm.stopPrank();
//  }
//
//  function _supplyTokens(address underlying, address user) internal {
//    _dealUnderlying(user, underlying);
//
//    vm.startPrank(user);
//    SafeERC20.safeApprove(IERC20(underlying), address(AaveV3Polygon.POOL), type(uint256).max);
//    AaveV3Polygon.POOL.deposit(underlying, IERC20Detailed(underlying).balanceOf(user), user, 0);
//    vm.stopPrank();
//  }
//
//  function _enableBorrowingToken(address underlying) internal {
//    hoax(EXECUTOR);
//    AaveV3Polygon.POOL_CONFIGURATOR.enableBorrowingOnReserve(underlying, true);
//  }
//
//  function _unfreezeTokens(address underlying) internal {
//    hoax(EXECUTOR);
//    AaveV3Polygon.POOL_CONFIGURATOR.unfreezeReserve(underlying);
//  }
//
//  function _dealUnderlying(address user, address underlying) internal {
//    if (
//      underlying == AaveV3PolygonAssets.USDC_UNDERLYING ||
//      underlying == AaveV3PolygonAssets.USDT_UNDERLYING
//    ) {
//      deal(underlying, user, 1_000_000_000e6);
//    } else if (underlying == AaveV3PolygonAssets.WBTC_UNDERLYING) {
//      deal(underlying, user, 10_000_000_000e8);
//    } else {
//      deal(underlying, user, 10_000_000_000 ether);
//    }
//  }
//
//  // generate revalancing for asset
//  function _generateStableDebt(address stableUnderlying, address debtor, address aToken) internal {
//    vm.startPrank(debtor);
//
//    deal(COLLATERAL_TOKEN, debtor, 100_000_000_000 ether);
//    SafeERC20.safeApprove(IERC20(COLLATERAL_TOKEN), address(AaveV3Polygon.POOL), type(uint256).max);
//    AaveV3Polygon.POOL.supply(COLLATERAL_TOKEN, IERC20Detailed(COLLATERAL_TOKEN).balanceOf(debtor), debtor, 0);
//
//    // get available liquidity
//    uint256 availableLiquidity = IERC20Detailed(stableUnderlying).balanceOf(aToken);
//    AaveV3Polygon.POOL.borrow(stableUnderlying, availableLiquidity / 5, 1, 0, debtor);
//
//    vm.stopPrank();
//  }
//
//  function _updateImplementation(address underlying, address newImpl, address currentStableProxy) internal {
//    ConfiguratorInputTypes.UpdateDebtTokenInput memory input = ConfiguratorInputTypes
//      .UpdateDebtTokenInput({
//      asset: underlying,
//      incentivesController: IGetIncentivesController(currentStableProxy)
//    .getIncentivesController(),
//      name: IERC20Detailed(currentStableProxy).name(),
//      symbol: IERC20Detailed(currentStableProxy).symbol(),
//      implementation: newImpl,
//      params: bytes('')
//    });
//
//    hoax(EXECUTOR); // executor lvl 1
//    POOL_CONFIGURATOR.updateStableDebtToken(input);
//  }
//}
