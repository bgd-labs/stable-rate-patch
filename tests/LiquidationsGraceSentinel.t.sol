// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12;
pragma experimental ABIEncoderV2;

import 'forge-std/Test.sol';
import {IERC20} from 'forge-std/interfaces/IERC20.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {ILiquidationsGraceSentinel} from '../src/ILiquidationsGraceSentinel.sol';
import {LendingPoolCollateralManager} from '../src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol';
import {LiquidationsGraceSentinel} from '../src/LiquidationsGraceSentinel.sol';
import {Ownable} from '../src/Ownable.sol';
import {Errors} from '../src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Errors.sol';

contract MockPriceProvider {
  int256 public immutable PRICE;

  constructor(int256 price) public {
    PRICE = price;
  }

  function latestAnswer() external view returns (int256) {
    return PRICE;
  }
}

/**
 * @dev Test for LiquidationsGraceSentinel activation
 * command: make test-contract filter=LiquidationsGraceSentinelTest
 */
contract LiquidationsGraceSentinelTest is Test {
  address public constant EXECUTOR_LVL_1 = 0x5300A1a15135EA4dc7aD5a167152C01EFc9b192A;
  address public constant GUARDIAN = 0xCA76Ebd8617a03126B6FB84F9b1c1A0fB71C2633;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18507320);

    // Unpausing v2 Ethereum, as that is the current state
    vm.startPrank(GUARDIAN);
    AaveV2Ethereum.POOL_CONFIGURATOR.setPoolPause(false);
    vm.stopPrank();
  }

  function testNoLiquidationsWithGraceActive() public {
    vm.startPrank(EXECUTOR_LVL_1);

    LiquidationsGraceSentinel sentinel = new LiquidationsGraceSentinel();
    Ownable(sentinel).transferOwnership(GUARDIAN);

    LendingPoolCollateralManager newCollateralManager = new LendingPoolCollateralManager(
      address(sentinel)
    );

    AaveV2Ethereum.POOL_ADDRESSES_PROVIDER.setLendingPoolCollateralManager(
      address(newCollateralManager)
    );

    vm.stopPrank();

    _forcePrice(EXECUTOR_LVL_1, AaveV2EthereumAssets.WBTC_UNDERLYING, 25053082074480230550);

    address holderWbtcDebt = 0x1111567E0954E74f6bA7c4732D534e75B81DC42E;

    deal(AaveV2EthereumAssets.WBTC_UNDERLYING, address(this), 2000 * 1e8);

    IERC20(AaveV2EthereumAssets.WBTC_UNDERLYING).approve(
      address(AaveV2Ethereum.POOL),
      type(uint256).max
    );

    _setGracePeriod(
      sentinel,
      GUARDIAN,
      AaveV2EthereumAssets.WBTC_UNDERLYING,
      uint40(block.timestamp) + 20
    );

    vm.expectRevert(bytes(Errors.LPCM_ON_GRACE_PERIOD));
    AaveV2Ethereum.POOL.liquidationCall(
      AaveV2EthereumAssets.WETH_UNDERLYING,
      AaveV2EthereumAssets.WBTC_UNDERLYING,
      holderWbtcDebt,
      type(uint256).max,
      false
    );
  }

  function _forcePrice(address oracleAdmin, address asset, int256 price) internal {
    MockPriceProvider mockPriceProvider = new MockPriceProvider(price);

    vm.startPrank(oracleAdmin);
    address[] memory assets = new address[](1);
    assets[0] = asset;
    address[] memory sources = new address[](1);
    sources[0] = address(mockPriceProvider);
    AaveV2Ethereum.ORACLE.setAssetSources(assets, sources);
    vm.stopPrank();
  }

  function _setGracePeriod(
    ILiquidationsGraceSentinel sentinel,
    address sentinelAdmin,
    address asset,
    uint40 timestamp
  ) internal {
    vm.startPrank(sentinelAdmin);
    address[] memory assets = new address[](1);
    assets[0] = asset;
    uint40[] memory until = new uint40[](1);
    until[0] = timestamp;
    sentinel.setGracePeriods(assets, until);
    vm.stopPrank();
  }
}
