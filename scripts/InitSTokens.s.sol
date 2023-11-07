// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import 'forge-std/Script.sol';
import {AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {AaveV3Avalanche, AaveV3AvalancheAssets} from 'aave-address-book/AaveV3Avalanche.sol';
import {AaveV3Optimism, AaveV3OptimismAssets} from 'aave-address-book/AaveV3Optimism.sol';
import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import {IDebtTokenBaseV2, IDebtTokenBaseV3} from '../src/interfaces/IDebtTokenBase.sol';
import {IAaveIncentivesController} from '../src/interfaces/IAaveIncentivesController.sol';
import {IERC20Detailed} from '../src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';

import {V2EthSTokenPayload} from '../src/payloads/V2EthSTokenPayload.sol';
import {V3ArbSTokenPayload} from '../src/payloads/V3ArbSTokenPayload.sol';
import {V3AvaxSTokenPayload} from '../src/payloads/V3AvaxSTokenPayload.sol';
import {V3PolSTokenPayload} from '../src/payloads/V3PolSTokenPayload.sol';
import {V3OptSTokenPayload} from '../src/payloads/V3OptSTokenPayload.sol';

contract InitSTokensV2Ethereum is V2EthSTokenPayload, Script {
  function run() public {
    vm.startBroadcast();
    TokenToUpdate[] memory tokensToUpdate = getTokensToUpdate();

    for (uint256 i = 0; i < tokensToUpdate.length; i++) {
      IERC20Detailed tokenToUpdate = IERC20Detailed(tokensToUpdate[i].underlyingAsset);
      IDebtTokenBaseV2(tokensToUpdate[i].newSTokenImpl).initialize(
        tokenToUpdate.decimals(),
        string(abi.encodePacked('Aave stable debt bearing ', tokenToUpdate.symbol())),
        string(abi.encodePacked('stableDebt', tokenToUpdate.symbol()))
      );
    }
    vm.stopBroadcast();
  }
}

abstract contract InitSTokensV3 is Script {
  function getAssets() public view virtual returns (V3ArbSTokenPayload.TokenToUpdate[] memory);

  function run() public {
    vm.startBroadcast();
    V3ArbSTokenPayload.TokenToUpdate[] memory assets = getAssets();
    for (uint256 i = 0; i < assets.length; i++) {
      IDebtTokenBaseV3(assets[i].newSTokenImpl).initialize(
        AaveV3Arbitrum.POOL,
        address(0),
        IAaveIncentivesController(address(0)),
        0,
        'STABLE_DEBT_TOKEN_IMPL',
        'STABLE_DEBT_TOKEN_IMPL',
        bytes('')
      );
    }
    vm.stopBroadcast();
  }
}

contract InitSTokensV3Arbitrum is InitSTokensV3, V3ArbSTokenPayload {
  function getAssets() public view override returns (TokenToUpdate[] memory) {
    return getTokensToUpdate();
  }
}

contract InitSTokensV3Optimism is InitSTokensV3, V3OptSTokenPayload {
  function getAssets() public view override returns (TokenToUpdate[] memory) {
    return getTokensToUpdate();
  }
}

contract InitSTokensV3Polygon is InitSTokensV3, V3PolSTokenPayload {
  function getAssets() public view override returns (TokenToUpdate[] memory) {
    return getTokensToUpdate();
  }
}

contract InitSTokensV3Avalanche is InitSTokensV3, V3AvaxSTokenPayload {
  function getAssets() public view override returns (TokenToUpdate[] memory) {
    return getTokensToUpdate();
  }
}
