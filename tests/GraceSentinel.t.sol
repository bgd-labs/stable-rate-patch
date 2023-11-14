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

interface IPC {
  function executePayload(uint40 payloadId) external;
}

contract GraceSentinelTest is Test {  
  uint40 public constant PAYLOAD_ID = uint40(7);
  address public constant PAYLOAD = 0x6C43cd7DC9f8d6F9892b4757941F910E3c7f2244;
  address public constant PAYLOADS_CONTROLLER = 0xdAbad81aF85554E9ae636395611C58F7eC1aAEc5;
ILiquidationsGraceSentinel sentinel;
  function setUp() public {

    vm.createSelectFork(vm.rpcUrl('mainnet'), 18557315);


    // Unpausing v2 Ethereum, as that is the current state
    hoax(AaveV2Ethereum.EMERGENCY_ADMIN);
    AaveV2Ethereum.POOL_CONFIGURATOR.setPoolPause(false);

    // move time to post execution
    skip(1 days + 10);
    // execute payload
    hoax(address(23520), 123 ether);
    IPC(PAYLOADS_CONTROLLER).executePayload(PAYLOAD_ID);



    address collateralManager = V2EthLiquidationSentinelPayload(PAYLOAD)
      .NEW_COLLATERAL_MANAGER();
    sentinel = ILendingPoolCollateralManager(collateralManager)
      .LIQUIDATIONS_GRACE_SENTINEL();
  }
  
  function test_LiqNotPossibleBeforeGracePeriod(uint24 gracePeriod) public {

    uint40 queuedAt = uint40(1699784479);
    
    address holderWbtcDebt = 0xB87736C9c2DDBBAb1d6B59955A2d5aFb8713C2DB;
//    address holderWbtcDebt = 0x6Af11ed2008131C091bA3171bD0bB3B5248316bc;
//    address holderWbtcDebt = 0x43A938d7aA8cFCa1734770d5b1FCe3b661D89cdD;

    address[] memory assetsInGrace = new address[](1);
    assetsInGrace[0] = AaveV2EthereumAssets.WETH_UNDERLYING;

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
      _setGracePeriod(sentinel, assetsInGrace,  initialTs + gracePeriod);
  
      // liquidations was not allowed during grace period
      vm.expectRevert(bytes(Errors.LPCM_ON_GRACE_PERIOD));
      AaveV2Ethereum.POOL.liquidationCall(
        AaveV2EthereumAssets.WETH_UNDERLYING,
        AaveV2EthereumAssets.WBTC_UNDERLYING,
        holderWbtcDebt,
        type(uint256).max,
        false
      );
  
      // and allowed again when grace period end
      skip(initialTs + gracePeriod + 100);
      AaveV2Ethereum.POOL.liquidationCall(
        AaveV2EthereumAssets.WETH_UNDERLYING,
        AaveV2EthereumAssets.WBTC_UNDERLYING,
        holderWbtcDebt,
        type(uint256).max,
        false
      );
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
