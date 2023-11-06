// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {AaveV3Optimism, AaveV3OptimismAssets} from 'aave-address-book/AaveV3Optimism.sol';
import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import "forge-std/Script.sol";

/**
 * @title Emergency Action
 * @author BGD Labs
 */
contract EmergencyActionArbitrum {
  function execute() external {
    AaveV3Arbitrum.POOL_CONFIGURATOR.setReservePause(AaveV3ArbitrumAssets.USDT_UNDERLYING, true);
    AaveV3Arbitrum.POOL_CONFIGURATOR.setReservePause(AaveV3ArbitrumAssets.USDC_UNDERLYING, true);
    AaveV3Arbitrum.POOL_CONFIGURATOR.setReservePause(AaveV3ArbitrumAssets.DAI_UNDERLYING, true);
    AaveV3Arbitrum.POOL_CONFIGURATOR.setReservePause(AaveV3ArbitrumAssets.EURS_UNDERLYING, true);
  }
}

/**
 * @title Emergency Action
 * @author BGD Labs
 */
contract EmergencyActionOptimism {
  function execute() external {
    AaveV3Optimism.POOL_CONFIGURATOR.setReservePause(AaveV3OptimismAssets.USDT_UNDERLYING, true);
    AaveV3Optimism.POOL_CONFIGURATOR.setReservePause(AaveV3OptimismAssets.USDC_UNDERLYING, true);
    AaveV3Optimism.POOL_CONFIGURATOR.setReservePause(AaveV3OptimismAssets.DAI_UNDERLYING, true);
  }
}

/**
 * @title Emergency Action
 * @author BGD Labs
 */
contract EmergencyActionPolygon {
  function execute() external {
    AaveV3Polygon.POOL_CONFIGURATOR.setReservePause(AaveV3PolygonAssets.USDT_UNDERLYING, true);
    AaveV3Polygon.POOL_CONFIGURATOR.setReservePause(AaveV3PolygonAssets.USDC_UNDERLYING, true);
    AaveV3Polygon.POOL_CONFIGURATOR.setReservePause(AaveV3PolygonAssets.DAI_UNDERLYING, true);
    AaveV3Polygon.POOL_CONFIGURATOR.setReservePause(AaveV3PolygonAssets.EURS_UNDERLYING, true);
  }
}

contract DeployArb is Script {
  function run() public {
    vm.startBroadcast();

    new EmergencyActionArbitrum();

    vm.stopBroadcast();
  }
}

contract DeployPol is Script {
  function run() public {
    vm.startBroadcast();

    new EmergencyActionPolygon();

    vm.stopBroadcast();
  }
}

contract DeployOpt is Script {
  function run() public {
    vm.startBroadcast();

    new EmergencyActionOptimism();

    vm.stopBroadcast();
  }
}
