// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import {GovernanceV3Polygon} from 'aave-address-book/GovernanceV3Polygon.sol';
import {IPool, IPoolConfigurator} from 'aave-address-book/AaveV3.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/ProtocolV3TestBase.sol';
import {IERC20} from 'solidity-utils/contracts/oz-common/interfaces/IERC20.sol';
import {V3PolSTokenPayload, V3TokenPayload} from './V3PolSTokenPayload.sol';

contract TestV3 is ProtocolV3TestBase {
  V3TokenPayload payload;

  address constant STABLE_BORROWER = address(1);
  address constant UTILIZER = address(2);
  IPool constant POOL = AaveV3Polygon.POOL;
  IPoolConfigurator constant POOL_CONFIGURATOR = AaveV3Polygon.POOL_CONFIGURATOR;
  address constant EXECUTOR = GovernanceV3Polygon.EXECUTOR_LVL_1;
  address COLLATERAL_ASSET = AaveV3PolygonAssets.WBTC_UNDERLYING;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 49613918);
    payload = V3TokenPayload(address(new V3PolSTokenPayload()));
  }

  function _unfreezeToken(address underlying) internal {
    startHoax(EXECUTOR);
    POOL_CONFIGURATOR.setReserveFreeze(underlying, false);
  }

  function _removeSupplyCap(address underlying) internal {
    startHoax(EXECUTOR);
    POOL_CONFIGURATOR.setSupplyCap(underlying, 0);
  }


  function testRebalanceRate() public {
    ReserveConfig[] memory configs = _getReservesConfigs(POOL);
    V3TokenPayload.TokenToUpdate[] memory tokens = payload.getTokensToUpdate();
    // increase supply of asset
    for (uint256 i; i < tokens.length; i++) {
      ReserveConfig memory goodCollateral = _findReserveConfig(
        configs,
        COLLATERAL_ASSET
      );
      uint256 amount = 10_000_000_000e18;
      uint256 snapshot = vm.snapshot();

      _removeSupplyCap(goodCollateral.underlying);
      ReserveConfig memory config = _findReserveConfig(configs, tokens[i].underlyingAsset);

      // 0. prepare reserve
      _unfreezeToken(config.underlying);
      config.isFrozen = false;

      // 1. temporarily bump total supply
      uint256 totalATokenSupply = IERC20(config.aToken).totalSupply();
      _deposit(config, POOL, UTILIZER, totalATokenSupply* 3);

      // 2. borrow 20% stable
      _deposit(goodCollateral, POOL, STABLE_BORROWER, 1_000_000e6);
      this._borrow(config, POOL, STABLE_BORROWER, IERC20(config.underlying).balanceOf(config.aToken) / 5, true);

      // 3. wihdraw liquidity
      _withdraw(config, POOL, UTILIZER, IERC20(config.underlying).balanceOf(config.aToken));

      // 5. rebalance position
      vm.expectRevert();
      POOL.rebalanceStableBorrowRate(config.underlying, STABLE_BORROWER);
      vm.revertTo(snapshot);
    }
  }
}
