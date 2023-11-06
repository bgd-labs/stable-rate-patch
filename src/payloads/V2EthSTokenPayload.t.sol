// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
pragma experimental ABIEncoderV2;
import {console2} from 'forge-std/console2.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';
import {ILendingPool, ILendingPoolConfigurator} from 'aave-address-book/AaveV2.sol';
import {ProtocolV2TestBase, ReserveConfig} from 'aave-helpers/ProtocolV2TestBase.sol';
import {IERC20} from 'solidity-utils/contracts/oz-common/interfaces/IERC20.sol';
import {V2EthSTokenPayload} from './V2EthSTokenPayload.sol';

contract TestV2 is ProtocolV2TestBase {
  V2EthSTokenPayload payload;

  address constant STABLE_BORROWER = address(1);
  address constant UTILIZER = address(2);
  ILendingPool constant POOL = AaveV2Ethereum.POOL;
  ILendingPoolConfigurator constant POOL_CONFIGURATOR = AaveV2Ethereum.POOL_CONFIGURATOR;
  address constant EXECUTOR = GovernanceV3Ethereum.EXECUTOR_LVL_1;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18511827);
    payload = new V2EthSTokenPayload();
    _unPause();
  }

  function _unPause() internal {
    hoax(0xCA76Ebd8617a03126B6FB84F9b1c1A0fB71C2633);
    POOL_CONFIGURATOR.setPoolPause(false);
  }

  function _unfreezeToken(address underlying) internal {
    hoax(EXECUTOR);
    POOL_CONFIGURATOR.unfreezeReserve(underlying);
  }

  function _enableBorrowingToken(address underlying) internal {
    hoax(EXECUTOR);
    POOL_CONFIGURATOR.enableBorrowingOnReserve(underlying, true);
  }

  function _updateImplementation(address underlying, address newImpl) internal {
    hoax(EXECUTOR); // executor lvl 1
    POOL_CONFIGURATOR.updateStableDebtToken(underlying, newImpl);
  }

  function testE2e() public {
    _rebalanceStableRates(false);
    // V2TokenPayload.TokenToUpdate[] memory tokens = payload.getTokensToUpdate();
    // for(uint256 i; i<tokens.length; i++) {
    //   // StableToken[] memory newTokenImpl = _deploy();
    //   // _updateImplementation(tokens[underlying], newImpl);
    // }
    _rebalanceStableRates(true);
  }

  function _rebalanceStableRates(bool shouldRevert) internal {
    ReserveConfig[] memory configs = _getReservesConfigs(POOL);
    V2EthSTokenPayload.TokenToUpdate[] memory tokens = payload.getTokensToUpdate();
    // increase supply of asset
    for (uint256 i; i < tokens.length; i++) {
      ReserveConfig memory goodCollateral = _findReserveConfig(
        configs,
        AaveV2EthereumAssets.DAI_UNDERLYING
      );
      uint256 amount = 10_000_000_000e18;
      uint256 snapshot = vm.snapshot();
      ReserveConfig memory config = _findReserveConfig(configs, tokens[i].underlyingAsset);

      // 0. prepare reserve
      _unfreezeToken(config.underlying);
      _enableBorrowingToken(config.underlying);
      config.isFrozen = false;

      // 1. temporarily bump total supply
      uint256 totalATokenSupply = IERC20(config.aToken).totalSupply();
      _deposit(config, POOL, UTILIZER, totalATokenSupply * 10);

      // 2. borrow 20% stable
      _deposit(goodCollateral, POOL, STABLE_BORROWER, amount);
      this._borrow(
        config,
        POOL,
        STABLE_BORROWER,
        IERC20(config.underlying).balanceOf(config.aToken) / 5,
        true
      );

      // 3. wihdraw liquidity
      _withdraw(config, POOL, UTILIZER, IERC20(config.underlying).balanceOf(config.aToken));

      // 4. rebalance position
      if(shouldRevert) vm.expectRevert(bytes('STABLE_BORROWING_DEPRECATED'));
      POOL.rebalanceStableBorrowRate(config.underlying, STABLE_BORROWER);
      vm.revertTo(snapshot);
    }
  }
}
