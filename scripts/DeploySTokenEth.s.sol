// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;
pragma experimental ABIEncoderV2;

import "forge-std/Script.sol";
import {StableDebtToken} from '../src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {DataTypes} from '../src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/libraries/types/DataTypes.sol';
import {IERC20Detailed} from '../src/v2EthStableDebtToken/StableDebtToken/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';


contract BaseDeployEthereum {
  function _deploy(address underlyingAsset, string memory name, string memory symbol) internal {
    address[] memory reserves = AaveV2Ethereum.POOL.getReservesList();

    for (uint256 i = 0; i < reserves.length; i++) {
      DataTypes.ReserveData memory reserveData = AaveV2Ethereum.POOL.getReserveData(reserves[i]);

      (,,,,,,, bool stableBorrowRateEnabled,,) =
                  AaveV2Ethereum.AAVE_PROTOCOL_DATA_PROVIDER.getReserveConfigurationData(reserves[i]);
      (
        address aTokenAddress,
        address stableDebtTokenAddress,
        address variableDebtTokenAddress
      ) = AaveV2Ethereum.AAVE_PROTOCOL_DATA_PROVIDER.getReserveTokensAddresses(reserves[i]);

      if (!stableBorrowRateEnabled) {
        continue;
      }



      new StableDebtToken(
        address(AaveV2Ethereum.POOL),
        reserves[i],
        IERC20Detailed(stableDebtTokenAddress).name,
        IERC20Detailed(stableDebtTokenAddress).symbol,
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
