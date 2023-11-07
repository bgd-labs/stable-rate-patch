// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;
pragma experimental ABIEncoderV2;

import 'forge-std/Script.sol';
import {AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {AaveV3Avalanche, AaveV3AvalancheAssets} from 'aave-address-book/AaveV3Avalanche.sol';
import {AaveV3Optimism, AaveV3OptimismAssets} from 'aave-address-book/AaveV3Optimism.sol';
import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import {IDebtTokenBaseV2, IDebtTokenBaseV3} from '../src/interfaces/IDebtTokenBase.sol';

contract InitSTokensV2Ethereum is Script {
  function run() public {
    vm.startBroadcast();

    // BAT
    IDebtTokenBaseV2(0x49B6645a9aa05f1Be24893136100467276399470).initialize(
      'Aave stable debt bearing BAT',
      'stableDebtBAT',
      AaveV2EthereumAssets.BAT_DECIMALS //18
    );

    // MANA
    IDebtTokenBaseV2(0xe0bf71fF662e8bbeb911ACEa765f4b8be052F59b).initialize(
      'Aave stable debt bearing MANA',
      'stableDebtMANA',
      AaveV2EthereumAssets.MANA_DECIMALS // 18
    );

    // WBTC
    IDebtTokenBaseV2(0x4f279f2046870F77cd9Ce63497f8A2D8689ef804).initialize(
      'Aave stable debt bearing WBTC',
      'stableDebtWBTC',
      AaveV2EthereumAssets.WBTC_DECIMALS // 8
    );

    // REN
    IDebtTokenBaseV2(0x6F4B277366e10F68003A0a65Ef8f118f3D60B67E).initialize(
      'Aave stable debt bearing REN',
      'stableDebtREN',
      AaveV2EthereumAssets.REN_DECIMALS // 18
    );

    // LINK
    IDebtTokenBaseV2(0x1B80694AF3D4e617c747423f992F532B8baE098b).initialize(
      'Aave stable debt bearing LINK',
      'stableDebtLINK',
      AaveV2EthereumAssets.LINK_DECIMALS // 18
    );

    // LUSD
    IDebtTokenBaseV2(0x1363602E58e25929A15bE194a3D505Fd6F8BE751).initialize(
      'Aave stable debt bearing LUSD',
      'stableDebtLUSD',
      AaveV2EthereumAssets.LUSD_DECIMALS // 18
    );

    // MKR
    IDebtTokenBaseV2(0xC4CFCE0b16199818Ad942a87902C9172ba005022).initialize(
      'Aave stable debt bearing MKR',
      'stableDebtMKR',
      AaveV2EthereumAssets.MKR_DECIMALS // 18
    );

    // USDC
    IDebtTokenBaseV2(0x8DFF7Fda82976452b6FB957F549944e7af7A3e6F).initialize(
      'Aave stable debt bearing USDC',
      'stableDebtUSDC',
      AaveV2EthereumAssets.USDC_DECIMALS // 6
    );

    // WETH
    IDebtTokenBaseV2(0xEd14b4E51B04d4d0211474a721F77C0817166c2f).initialize(
      'Aave stable debt bearing WETH',
      'stableDebtWETH',
      AaveV2EthereumAssets.WETH_DECIMALS // 18
    );

    // ZRX
    IDebtTokenBaseV2(0xffaCA447191d8196C8Cf96E5912b732063DE4307).initialize(
      'Aave stable debt bearing ZRX',
      'stableDebtZRX',
      AaveV2EthereumAssets.ZRX_DECIMALS // 18
    );

    // ENJ
    IDebtTokenBaseV2(0x0fB427f800C5E39E7d8029e19F515300d4bb22C2).initialize(
      'Aave stable debt bearing ENJ',
      'stableDebtENJ',
      AaveV2EthereumAssets.ENJ_DECIMALS // 18
    );

    // USDT
    IDebtTokenBaseV2(0xC61262D6ad449AC09B4087f46391Dd9A26b5888B).initialize(
      'Aave stable debt bearing USDT',
      'stableDebtUSDT',
      AaveV2EthereumAssets.USDT_DECIMALS // 6
    );

    // KNC
    IDebtTokenBaseV2(0x22a8FD718924ab2f9dd4D0326DD8ab99Ef21D0b3).initialize(
      'Aave stable debt bearing KNC',
      'stableDebtKNC',
      AaveV2EthereumAssets.KNC_DECIMALS // 18
    );

    vm.stopBroadcast();
  }
}

contract InitSTokensV3Arbitrum is Script {
  function run() public {
    vm.startBroadcast();

    // EURS
    IDebtTokenBaseV3(0xCB7113D3d572613BbFCeCf80d1341cFFE2A92C00).initialize(
      AaveV3Arbitrum.POOL,
      AaveV3ArbitrumAssets.AAVE_UNDERLYING,
      AaveV3Arbitrum.DEFAULT_INCENTIVES_CONTROLLER,
      AaveV3ArbitrumAssets.AAVE_DECIMALS, // 18
      'Aave Arbitrum Stable Debt AAVE',
      'stableDebtArbAAVE',
      bytes('')
    );

    vm.stopBroadcast();
  }
}

contract InitSTokensV3Avalanche is Script {
  function run() public {
    vm.startBroadcast();

    // EURS
    IDebtTokenBaseV3(0xccf12894957E637Bd69693B12F3ba12b539C2D11).initialize(
      AaveV3Avalanche.POOL,
      AaveV3AvalancheAssets.AAVEe_UNDERLYING,
      AaveV3Avalanche.DEFAULT_INCENTIVES_CONTROLLER,
      AaveV3AvalancheAssets.AAVEe_DECIMALS, // 18
      'Aave Avalanche Stable Debt AAVE',
      'stableDebtAvaAAVE',
      bytes('')
    );

    vm.stopBroadcast();
  }
}

contract InitSTokensV3Optimism is Script {
  function run() public {
    vm.startBroadcast();

    // EURS
    IDebtTokenBaseV3(0x69713dA5fDfacf77E80C31F9B928Ec0Fc3716384).initialize(
      AaveV3Optimism.POOL,
      AaveV3OptimismAssets.AAVE_UNDERLYING,
      AaveV3Optimism.DEFAULT_INCENTIVES_CONTROLLER,
      AaveV3OptimismAssets.AAVE_DECIMALS, // 18
      'Aave Optimism Stable Debt AAVE',
      'stableDebtOptAAVE',
      bytes('')
    );

    vm.stopBroadcast();
  }
}

contract InitSTokensV3Polygon is Script {
  function run() public {
    vm.startBroadcast();

    // EURS
    IDebtTokenBaseV3(0xF4294973B7E6F6C411dD8A388592E7c7D32F2486).initialize(
      AaveV3Polygon.POOL,
      AaveV3PolygonAssets.AAVE_UNDERLYING,
      AaveV3Polygon.DEFAULT_INCENTIVES_CONTROLLER,
      AaveV3PolygonAssets.AAVE_DECIMALS, // 18
      'Aave Polygon Stable Debt AAVE',
      'stableDebtPolAAVE',
      bytes('')
    );

    vm.stopBroadcast();
  }
}
