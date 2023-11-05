// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12;
pragma experimental ABIEncoderV2;

import 'forge-std/Test.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {LendingPoolCollateralManager} from '../src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol';
import {LiquidationsGraceSentinel} from '../src/LiquidationsGraceSentinel.sol';
import {Ownable} from '../src/Ownable.sol';

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
  }

  function testLiquidationsGraceSentinel() public {
    vm.startPrank(EXECUTOR_LVL_1);

    LiquidationsGraceSentinel sentinel = new LiquidationsGraceSentinel();
    Ownable(sentinel).transferOwnership(GUARDIAN);

    LendingPoolCollateralManager newCollateralManager = new LendingPoolCollateralManager(
      address(sentinel)
    );

    AaveV2Ethereum.POOL_ADDRESSES_PROVIDER.setLendingPoolCollateralManager(
      address(newCollateralManager)
    );

    MockPriceProvider mockPriceProvider = new MockPriceProvider(18653082074480230550);

    vm.stopPrank();
  }
}