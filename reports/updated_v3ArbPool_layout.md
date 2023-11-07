|Name|Type|Slot|Offset|Bytes|Contract|
|-|-|-|-|-|-|
| lastInitializedRevision         | uint256                                                   | 0    | 0      | 32    |L2Pool.sol:L2Pool|
| initializing                    | bool                                                      | 1    | 0      | 1     |L2Pool.sol:L2Pool|
| ______gap                       | uint256[50]                                               | 2    | 0      | 1600  |L2Pool.sol:L2Pool|
| _reserves                       | mapping(address => struct DataTypes.ReserveData)          | 52   | 0      | 32    |L2Pool.sol:L2Pool|
| _usersConfig                    | mapping(address => struct DataTypes.UserConfigurationMap) | 53   | 0      | 32    |L2Pool.sol:L2Pool|
| _reservesList                   | mapping(uint256 => address)                               | 54   | 0      | 32    |L2Pool.sol:L2Pool|
| _eModeCategories                | mapping(uint8 => struct DataTypes.EModeCategory)          | 55   | 0      | 32    |L2Pool.sol:L2Pool|
| _usersEModeCategory             | mapping(address => uint8)                                 | 56   | 0      | 32    |L2Pool.sol:L2Pool|
| _bridgeProtocolFee              | uint256                                                   | 57   | 0      | 32    |L2Pool.sol:L2Pool|
| _flashLoanPremiumTotal          | uint128                                                   | 58   | 0      | 16    |L2Pool.sol:L2Pool|
| _flashLoanPremiumToProtocol     | uint128                                                   | 58   | 16     | 16    |L2Pool.sol:L2Pool|
| _maxStableRateBorrowSizePercent | uint64                                                    | 59   | 0      | 8     |L2Pool.sol:L2Pool|
| _reservesCount                  | uint16                                                    | 59   | 8      | 2     |L2Pool.sol:L2Pool|