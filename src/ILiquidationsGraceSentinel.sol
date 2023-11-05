// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.6.12;

interface ILiquidationsGraceSentinel {
  /**
   * @dev Emitted when a new grace period is set
   * @param aToken The address of an Aave aToken
   * @param until Timestamp until the grace period will be activated
   **/
  event GracePeriodSet(address indexed aToken, uint40 until);

  /**
   * @dev Returns until when a grace period is enabled
   * @param aToken Aave aToken address
   **/
  function gracePeriodUntil(address aToken) external view returns (uint40);

  /// @notice Function to set grace period to one or multiple Aave aTokens
  /// @param aTokens Aave aToken addresses
  /// @param until Timestamp when the liquidations' grace period will end
  function setGracePeriods(address[] calldata aTokens, uint40[] calldata until) external;
}
