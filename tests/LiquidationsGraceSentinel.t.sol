// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12;
pragma experimental ABIEncoderV2;

import 'forge-std/Test.sol';
import {IERC20} from 'forge-std/interfaces/IERC20.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {ILiquidationsGraceSentinel} from '../src/ILiquidationsGraceSentinel.sol';
import {LiquidationSentinelDeployer, V2EthLiquidationSentinelPayload} from '../scripts/DeployLiquidationSentinel.s.sol';
import {ILendingPoolCollateralManager} from '../src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol';
import {LiquidationsGraceSentinel} from '../src/LiquidationsGraceSentinel.sol';
import {Errors} from '../src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/libraries/helpers/Errors.sol';
import {IExecutor} from './utils/IExecutor.sol';

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
  address public constant PAYLOADS_CONTROLLER = 0xdAbad81aF85554E9ae636395611C58F7eC1aAEc5;

  address public constant PAYLOAD = 0x6C43cd7DC9f8d6F9892b4757941F910E3c7f2244;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18520228);

    // Unpausing v2 Ethereum, as that is the current state
    hoax(AaveV2Ethereum.EMERGENCY_ADMIN);
    AaveV2Ethereum.POOL_CONFIGURATOR.setPoolPause(false);
  }

  function testLiquidationWithGraceCollateralActive(uint24 gracePeriod) public {
    address[] memory assetsInGrace = new address[](1);
    assetsInGrace[0] = AaveV2EthereumAssets.WETH_UNDERLYING;
    _testGracePeriod(gracePeriod, assetsInGrace);
  }

  function testLiquidationWithGraceDebtActive(uint24 gracePeriod) public {
    address[] memory assetsInGrace = new address[](1);
    assetsInGrace[0] = AaveV2EthereumAssets.WBTC_UNDERLYING;
    _testGracePeriod(gracePeriod, assetsInGrace);
  }

  function testLiquidationWithGraceDebtAndCollateralActive(uint24 gracePeriod) public {
    address[] memory assetsInGrace = new address[](2);
    assetsInGrace[0] = AaveV2EthereumAssets.WETH_UNDERLYING;
    assetsInGrace[0] = AaveV2EthereumAssets.WBTC_UNDERLYING;
    _testGracePeriod(gracePeriod, assetsInGrace);
  }

  function testCollateralManagerAndSentinelUpdatedAndOwnedByGuardian() public {
    ILiquidationsGraceSentinel sentinel = _executePayload();
    address collateralManager = address(
      AaveV2Ethereum.POOL_ADDRESSES_PROVIDER.getLendingPoolCollateralManager()
    );
    assertEq(
      address(sentinel),
      address(ILendingPoolCollateralManager(collateralManager).LIQUIDATIONS_GRACE_SENTINEL())
    );
    assertEq(LiquidationsGraceSentinel(address(sentinel)).owner(), AaveV2Ethereum.EMERGENCY_ADMIN);
  }

  function _executePayload() internal returns (ILiquidationsGraceSentinel) {
    address payloadToExecute = PAYLOAD;
    if (payloadToExecute == address(0)) {
      payloadToExecute = LiquidationSentinelDeployer.deployProposalEth();
      console2.log('payload deployed: ', payloadToExecute);
    }

    address collateralManager = V2EthLiquidationSentinelPayload(payloadToExecute)
      .NEW_COLLATERAL_MANAGER();
    ILiquidationsGraceSentinel sentinel = ILendingPoolCollateralManager(collateralManager)
      .LIQUIDATIONS_GRACE_SENTINEL();
    console2.log('collateral manager is:', collateralManager);
    console2.log(
      'sentinel is:',
      address(ILendingPoolCollateralManager(collateralManager).LIQUIDATIONS_GRACE_SENTINEL())
    );

    hoax(PAYLOADS_CONTROLLER);
    IExecutor(EXECUTOR_LVL_1).executeTransaction(payloadToExecute, 0, 'execute()', bytes(''), true);
    return sentinel;
  }

  function _testGracePeriod(uint24 gracePeriod, address[] memory assetsInGrace) internal {
    ILiquidationsGraceSentinel sentinel = _executePayload();

    _forcePrice(EXECUTOR_LVL_1, AaveV2EthereumAssets.WBTC_UNDERLYING, 25053082074480230550);

    address holderWbtcDebt = 0x1111567E0954E74f6bA7c4732D534e75B81DC42E;

    deal(AaveV2EthereumAssets.WBTC_UNDERLYING, address(this), 2000 * 1e8);

    IERC20(AaveV2EthereumAssets.WBTC_UNDERLYING).approve(
      address(AaveV2Ethereum.POOL),
      type(uint256).max
    );
    // check that liquidations was allowed before grace period activation
    uint256 snapshot = vm.snapshot();
    AaveV2Ethereum.POOL.liquidationCall(
      AaveV2EthereumAssets.WETH_UNDERLYING,
      AaveV2EthereumAssets.WBTC_UNDERLYING,
      holderWbtcDebt,
      type(uint256).max,
      false
    );
    vm.revertTo(snapshot);

    uint40 initialTs = uint40(block.timestamp);
    hoax(AaveV2Ethereum.EMERGENCY_ADMIN);
    _setGracePeriod(sentinel, assetsInGrace, initialTs + gracePeriod);

    // liquidations was not allowed during grace period
    vm.expectRevert(bytes(Errors.LPCM_ON_GRACE_PERIOD));
    AaveV2Ethereum.POOL.liquidationCall(
      AaveV2EthereumAssets.WETH_UNDERLYING,
      AaveV2EthereumAssets.WBTC_UNDERLYING,
      holderWbtcDebt,
      type(uint256).max,
      false
    );

    vm.warp(initialTs + gracePeriod);
    vm.expectRevert(bytes(Errors.LPCM_ON_GRACE_PERIOD));
    AaveV2Ethereum.POOL.liquidationCall(
      AaveV2EthereumAssets.WETH_UNDERLYING,
      AaveV2EthereumAssets.WBTC_UNDERLYING,
      holderWbtcDebt,
      type(uint256).max,
      false
    );

    // and allowed again when grace period end
    vm.warp(initialTs + gracePeriod + 1);
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
    address[] memory assets,
    uint40 timestamp
  ) internal {
    uint40[] memory until = new uint40[](assets.length);
    for (uint256 i = 0; i < assets.length; i++) until[i] = timestamp;
    sentinel.setGracePeriods(assets, until);
  }
}
