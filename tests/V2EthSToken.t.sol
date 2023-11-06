// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;

import "forge-std/Test.sol";
import {BaseDeploy} from "../scripts/DeploySTokenV2Eth.s.sol";
pragma experimental ABIEncoderV2;

import {StableDebtToken} from '../src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';
import {DataTypes} from '../src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/types/DataTypes.sol';
import {IERC20Detailed} from '../src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';
import {V2EthSTokenPayload} from "../src/payloads/V2EthSTokenPayload.sol";

contract V2EthSTokenTest is BaseDeploy, Test {
  address[] newTokenImpl;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18511827);
    newTokenImpl = _deploy();

    // unpause pool
    hoax(MiscEthereum.PROTOCOL_GUARDIAN);
    AaveV2Ethereum.setPoolPause(false);
  }

  function testNewTokensImpl() public {
    for(uint256 i = 0; i < newTokenImpl.length; i++) {
      if (newTokenImpl[i] != address(0)) {
        
      }
    }

  }

  // generate revalancing for asset
}
