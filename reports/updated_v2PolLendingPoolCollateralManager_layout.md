|Name|Type|Slot|Offset|Bytes|Contract|
|-|-|-|-|-|-|
| lastInitializedRevision         | uint256                                                   | 0    | 0      | 32    |LendingPoolCollateralManager.sol:LendingPoolCollateralManager|
| initializing                    | bool                                                      | 1    | 0      | 1     |LendingPoolCollateralManager.sol:LendingPoolCollateralManager|
| ______gap                       | uint256[50]                                               | 2    | 0      | 1600  |LendingPoolCollateralManager.sol:LendingPoolCollateralManager|
| _addressesProvider              | contract ILendingPoolAddressesProvider                    | 52   | 0      | 20    |LendingPoolCollateralManager.sol:LendingPoolCollateralManager|
| _reserves                       | mapping(address => struct DataTypes.ReserveData)          | 53   | 0      | 32    |LendingPoolCollateralManager.sol:LendingPoolCollateralManager|
| _usersConfig                    | mapping(address => struct DataTypes.UserConfigurationMap) | 54   | 0      | 32    |LendingPoolCollateralManager.sol:LendingPoolCollateralManager|
| _reservesList                   | mapping(uint256 => address)                               | 55   | 0      | 32    |LendingPoolCollateralManager.sol:LendingPoolCollateralManager|
| _reservesCount                  | uint256                                                   | 56   | 0      | 32    |LendingPoolCollateralManager.sol:LendingPoolCollateralManager|
| _paused                         | bool                                                      | 57   | 0      | 1     |LendingPoolCollateralManager.sol:LendingPoolCollateralManager|
| _maxStableRateBorrowSizePercent | uint256                                                   | 58   | 0      | 32    |LendingPoolCollateralManager.sol:LendingPoolCollateralManager|
| _flashLoanPremiumTotal          | uint256                                                   | 59   | 0      | 32    |LendingPoolCollateralManager.sol:LendingPoolCollateralManager|
| _maxNumberOfReserves            | uint256                                                   | 60   | 0      | 32    |LendingPoolCollateralManager.sol:LendingPoolCollateralManager|