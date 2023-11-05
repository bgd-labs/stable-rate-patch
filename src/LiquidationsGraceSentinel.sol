// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.6.12;

import {ILiquidationsGraceSentinel} from './ILiquidationsGraceSentinel.sol';
import {Ownable} from './Ownable.sol';

/// @title LiquidationsGraceSentinel
/// @author BGD Labs
/// @notice Registry to allow a temporary stop liquidations on Aave, for users
///   to have enough time to protect their positions, after a pause
/// - Being an emergency mechanism, it is designed to be controlled by an entity like the Aave Guardian
contract LiquidationsGraceSentinel is Ownable, ILiquidationsGraceSentinel {
  mapping(address => uint40) public override gracePeriodUntil;

  /// @notice Function to set grace period to one or multiple Aave aTokens
  /// @dev To enable a grace period, a timestamp in the future should be set,
  ///      To disable a grace period, any timestamp in the past works, like 0
  /// @param aTokens aToken addresses
  /// @param until Timestamp when the liquidations' grace period will end
  function setGracePeriods(
    address[] calldata aTokens,
    uint40[] calldata until
  ) external override onlyOwner {
    require(aTokens.length == until.length, 'INCONSISTENT_PARAMS_LENGTH');
    for (uint256 i = 0; i < aTokens.length; i++) {
      gracePeriodUntil[aTokens[i]] = until[i];
      emit GracePeriodSet(aTokens[i], until[i]);
    }
  }
}
