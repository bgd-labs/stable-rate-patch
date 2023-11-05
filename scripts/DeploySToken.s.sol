// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.8.0;

import "forge-std/Script.sol";
import {StableDebtToken} from '../src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {DataTypes as EthV2DataTypes} from '../src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/types/DataTypes.sol';
import {IERC20Detailed as EthV2IERC20} from '../src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';



contract BaseDeployEthereum {
  function _deploy(address underlyingAsset, string memory name, string memory symbol) internal {
    address[] memory reserves = lendingPool.getReservesList();

    for (uint256 i = 0; i < reserves.length; i++) {
      EthV2DataTypes.ReserveData memory reserveData = lendingPool.getReserveData(reserves[i]);
      (
        ,
        ,
        ,
        bool stableBorrowRateEnabled
      ) = reserveData.configuration.getFlagsMemory();

      if (!stableBorrowRateEnabled) {
        continue;
      }

      new StableDebtToken(
        address(AaveV2Ethereum.POOL),
        reserves[i],
        EthV2IERC20(reserves[i]).name,
        EthV2IERC20(reserves[i]).symbol,
        AaveV2Ethereum.DEFAULT_INCENTIVES_CONTROLLER
      );
    }
  }
}


contract DeploySTokensEthereum is BaseDeployEthereum, Script {
  function run() public {
    vm.startBroadcast();

    _deploy();

    vm.stopBroadcast();
  }
}
