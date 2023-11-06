|Name|Type|Slot|Offset|Bytes|Contract|
|-|-|-|-|-|-|
| _balances               | mapping(address => uint256)                     | 0    | 0      | 32    |StableDebtToken.sol:StableDebtToken|
| _allowances             | mapping(address => mapping(address => uint256)) | 1    | 0      | 32    |StableDebtToken.sol:StableDebtToken|
| _totalSupply            | uint256                                         | 2    | 0      | 32    |StableDebtToken.sol:StableDebtToken|
| _name                   | string                                          | 3    | 0      | 32    |StableDebtToken.sol:StableDebtToken|
| _symbol                 | string                                          | 4    | 0      | 32    |StableDebtToken.sol:StableDebtToken|
| _decimals               | uint8                                           | 5    | 0      | 1     |StableDebtToken.sol:StableDebtToken|
| lastInitializedRevision | uint256                                         | 6    | 0      | 32    |StableDebtToken.sol:StableDebtToken|
| initializing            | bool                                            | 7    | 0      | 1     |StableDebtToken.sol:StableDebtToken|
| ______gap               | uint256[50]                                     | 8    | 0      | 1600  |StableDebtToken.sol:StableDebtToken|
| _borrowAllowances       | mapping(address => mapping(address => uint256)) | 58   | 0      | 32    |StableDebtToken.sol:StableDebtToken|
| _avgStableRate          | uint256                                         | 59   | 0      | 32    |StableDebtToken.sol:StableDebtToken|
| _timestamps             | mapping(address => uint40)                      | 60   | 0      | 32    |StableDebtToken.sol:StableDebtToken|
| _usersStableRate        | mapping(address => uint256)                     | 61   | 0      | 32    |StableDebtToken.sol:StableDebtToken|
| _totalSupplyTimestamp   | uint40                                          | 62   | 0      | 5     |StableDebtToken.sol:StableDebtToken|