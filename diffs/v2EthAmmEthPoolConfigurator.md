```diff
diff --git a/etherscan/flattened/v2AmmEthPoolConfigurator/PoolConfigurator.sol b/etherscan/flattened/v2EthPoolConfigurator/PoolConfigurator.sol
index 9ba6779..13bfc8d 100644
--- a/etherscan/flattened/v2AmmEthPoolConfigurator/PoolConfigurator.sol
+++ b/etherscan/flattened/v2EthPoolConfigurator/PoolConfigurator.sol
@@ -212,14 +212,14 @@ abstract contract VersionedInitializable {
   }
 
   /**
-   * @dev returns the revision number of the contract
-   * Needs to be defined in the inherited class as a constant.
-   **/
+  * @dev returns the revision number of the contract
+  * Needs to be defined in the inherited class as a constant.
+  **/ 
   function getRevision() internal pure virtual returns (uint256);
 
   /**
-   * @dev Returns true if and only if the function is running in the constructor
-   **/
+  * @dev Returns true if and only if the function is running in the constructor
+  **/ 
   function isConstructor() private view returns (bool) {
     // extcodesize checks the size of the code stored in an address, and
     // address returns the current address. Since the code is still not
@@ -257,7 +257,7 @@ abstract contract Proxy {
   /**
    * @return The Address of the implementation.
    */
-  function _implementation() internal view virtual returns (address);
+  function _implementation() internal virtual view returns (address);
 
   /**
    * @dev Delegates execution to an implementation contract.
@@ -385,14 +385,13 @@ contract BaseUpgradeabilityProxy is Proxy {
    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
    * validated in the constructor.
    */
-  bytes32 internal constant IMPLEMENTATION_SLOT =
-    0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
+  bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
 
   /**
    * @dev Returns the current implementation.
    * @return impl Address of the current implementation
    */
-  function _implementation() internal view override returns (address impl) {
+  function _implementation() internal override view returns (address impl) {
     bytes32 slot = IMPLEMENTATION_SLOT;
     //solium-disable-next-line
     assembly {
@@ -797,10 +796,7 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param bonus The new liquidation bonus
    **/
-  function setLiquidationBonus(DataTypes.ReserveConfigurationMap memory self, uint256 bonus)
-    internal
-    pure
-  {
+  function setLiquidationBonus(DataTypes.ReserveConfigurationMap memory self, uint256 bonus) internal pure {
     require(bonus <= MAX_VALID_LIQUIDATION_BONUS, Errors.RC_INVALID_LIQ_BONUS);
 
     self.data =
@@ -826,10 +822,7 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param decimals The decimals
    **/
-  function setDecimals(DataTypes.ReserveConfigurationMap memory self, uint256 decimals)
-    internal
-    pure
-  {
+  function setDecimals(DataTypes.ReserveConfigurationMap memory self, uint256 decimals) internal pure {
     require(decimals <= MAX_VALID_DECIMALS, Errors.RC_INVALID_DECIMALS);
 
     self.data = (self.data & DECIMALS_MASK) | (decimals << RESERVE_DECIMALS_START_BIT_POSITION);
@@ -840,11 +833,7 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The decimals of the asset
    **/
-  function getDecimals(DataTypes.ReserveConfigurationMap storage self)
-    internal
-    view
-    returns (uint256)
-  {
+  function getDecimals(DataTypes.ReserveConfigurationMap storage self) internal view returns (uint256) {
     return (self.data & ~DECIMALS_MASK) >> RESERVE_DECIMALS_START_BIT_POSITION;
   }
 
@@ -893,10 +882,7 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param enabled True if the borrowing needs to be enabled, false otherwise
    **/
-  function setBorrowingEnabled(DataTypes.ReserveConfigurationMap memory self, bool enabled)
-    internal
-    pure
-  {
+  function setBorrowingEnabled(DataTypes.ReserveConfigurationMap memory self, bool enabled) internal pure {
     self.data =
       (self.data & BORROWING_MASK) |
       (uint256(enabled ? 1 : 0) << BORROWING_ENABLED_START_BIT_POSITION);
@@ -907,11 +893,7 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The borrowing state
    **/
-  function getBorrowingEnabled(DataTypes.ReserveConfigurationMap storage self)
-    internal
-    view
-    returns (bool)
-  {
+  function getBorrowingEnabled(DataTypes.ReserveConfigurationMap storage self) internal view returns (bool) {
     return (self.data & ~BORROWING_MASK) != 0;
   }
 
@@ -920,10 +902,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param enabled True if the stable rate borrowing needs to be enabled, false otherwise
    **/
-  function setStableRateBorrowingEnabled(
-    DataTypes.ReserveConfigurationMap memory self,
-    bool enabled
-  ) internal pure {
+  function setStableRateBorrowingEnabled(DataTypes.ReserveConfigurationMap memory self, bool enabled)
+    internal
+    pure
+  {
     self.data =
       (self.data & STABLE_BORROWING_MASK) |
       (uint256(enabled ? 1 : 0) << STABLE_BORROWING_ENABLED_START_BIT_POSITION);
@@ -963,11 +945,7 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The reserve factor
    **/
-  function getReserveFactor(DataTypes.ReserveConfigurationMap storage self)
-    internal
-    view
-    returns (uint256)
-  {
+  function getReserveFactor(DataTypes.ReserveConfigurationMap storage self) internal view returns (uint256) {
     return (self.data & ~RESERVE_FACTOR_MASK) >> RESERVE_FACTOR_START_BIT_POSITION;
   }
 
@@ -1534,6 +1512,18 @@ interface ILendingPool {
   function paused() external view returns (bool);
 }
 
+/**
+ * @title ITokenConfiguration
+ * @author Aave
+ * @dev Common interface between aTokens and debt tokens to fetch the
+ * token configuration
+ **/
+interface ITokenConfiguration {
+  function UNDERLYING_ASSET_ADDRESS() external view returns (address);
+
+  function POOL() external view returns (address);
+}
+
 /**
  * @dev Interface of the ERC20 standard as defined in the EIP.
  */
@@ -1670,148 +1660,16 @@ library PercentageMath {
   }
 }
 
-interface IAaveIncentivesController {
-  function handleAction(
-    address user,
-    uint256 userBalance,
-    uint256 totalSupply
-  ) external;
-}
-
 /**
- * @title IInitializableDebtToken
- * @notice Interface for the initialize function common between debt tokens
+ * @title LendingPoolConfigurator contract
  * @author Aave
+ * @dev Implements the configuration methods for the Aave protocol
  **/
-interface IInitializableDebtToken {
-  /**
-   * @dev Emitted when a debt token is initialized
-   * @param underlyingAsset The address of the underlying asset
-   * @param pool The address of the associated lending pool
-   * @param incentivesController The address of the incentives controller for this aToken
-   * @param debtTokenDecimals the decimals of the debt token
-   * @param debtTokenName the name of the debt token
-   * @param debtTokenSymbol the symbol of the debt token
-   * @param params A set of encoded parameters for additional initialization
-   **/
-  event Initialized(
-    address indexed underlyingAsset,
-    address indexed pool,
-    address incentivesController,
-    uint8 debtTokenDecimals,
-    string debtTokenName,
-    string debtTokenSymbol,
-    bytes params
-  );
-
-  /**
-   * @dev Initializes the debt token.
-   * @param pool The address of the lending pool where this aToken will be used
-   * @param underlyingAsset The address of the underlying asset of this aToken (E.g. WETH for aWETH)
-   * @param incentivesController The smart contract managing potential incentives distribution
-   * @param debtTokenDecimals The decimals of the debtToken, same as the underlying asset's
-   * @param debtTokenName The name of the token
-   * @param debtTokenSymbol The symbol of the token
-   */
-  function initialize(
-    ILendingPool pool,
-    address underlyingAsset,
-    IAaveIncentivesController incentivesController,
-    uint8 debtTokenDecimals,
-    string memory debtTokenName,
-    string memory debtTokenSymbol,
-    bytes calldata params
-  ) external;
-}
-
-/**
- * @title IInitializableAToken
- * @notice Interface for the initialize function on AToken
- * @author Aave
- **/
-interface IInitializableAToken {
-  /**
-   * @dev Emitted when an aToken is initialized
-   * @param underlyingAsset The address of the underlying asset
-   * @param pool The address of the associated lending pool
-   * @param treasury The address of the treasury
-   * @param incentivesController The address of the incentives controller for this aToken
-   * @param aTokenDecimals the decimals of the underlying
-   * @param aTokenName the name of the aToken
-   * @param aTokenSymbol the symbol of the aToken
-   * @param params A set of encoded parameters for additional initialization
-   **/
-  event Initialized(
-    address indexed underlyingAsset,
-    address indexed pool,
-    address treasury,
-    address incentivesController,
-    uint8 aTokenDecimals,
-    string aTokenName,
-    string aTokenSymbol,
-    bytes params
-  );
-
-  /**
-   * @dev Initializes the aToken
-   * @param pool The address of the lending pool where this aToken will be used
-   * @param treasury The address of the Aave treasury, receiving the fees on this aToken
-   * @param underlyingAsset The address of the underlying asset of this aToken (E.g. WETH for aWETH)
-   * @param incentivesController The smart contract managing potential incentives distribution
-   * @param aTokenDecimals The decimals of the aToken, same as the underlying asset's
-   * @param aTokenName The name of the aToken
-   * @param aTokenSymbol The symbol of the aToken
-   */
-  function initialize(
-    ILendingPool pool,
-    address treasury,
-    address underlyingAsset,
-    IAaveIncentivesController incentivesController,
-    uint8 aTokenDecimals,
-    string calldata aTokenName,
-    string calldata aTokenSymbol,
-    bytes calldata params
-  ) external;
-}
-
-interface ILendingPoolConfigurator {
-  struct InitReserveInput {
-    address aTokenImpl;
-    address stableDebtTokenImpl;
-    address variableDebtTokenImpl;
-    uint8 underlyingAssetDecimals;
-    address interestRateStrategyAddress;
-    address underlyingAsset;
-    address treasury;
-    address incentivesController;
-    string underlyingAssetName;
-    string aTokenName;
-    string aTokenSymbol;
-    string variableDebtTokenName;
-    string variableDebtTokenSymbol;
-    string stableDebtTokenName;
-    string stableDebtTokenSymbol;
-    bytes params;
-  }
-
-  struct UpdateATokenInput {
-    address asset;
-    address treasury;
-    address incentivesController;
-    string name;
-    string symbol;
-    address implementation;
-    bytes params;
-  }
 
-  struct UpdateDebtTokenInput {
-    address asset;
-    address incentivesController;
-    string name;
-    string symbol;
-    address implementation;
-    bytes params;
-  }
+contract LendingPoolConfigurator is VersionedInitializable {
+  using SafeMath for uint256;
+  using PercentageMath for uint256;
+  using ReserveConfiguration for DataTypes.ReserveConfigurationMap;
 
   /**
    * @dev Emitted when a reserve is initialized.
@@ -1948,18 +1806,6 @@ interface ILendingPoolConfigurator {
     address indexed proxy,
     address indexed implementation
   );
-}
-
-/**
- * @title LendingPoolConfigurator contract
- * @author Aave
- * @dev Implements the configuration methods for the Aave protocol
- **/
-
-contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigurator {
-  using SafeMath for uint256;
-  using PercentageMath for uint256;
-  using ReserveConfiguration for DataTypes.ReserveConfigurationMap;
 
   ILendingPoolAddressesProvider internal addressesProvider;
   ILendingPool internal pool;
@@ -1989,189 +1835,114 @@ contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigur
   }
 
   /**
-   * @dev Initializes reserves in batch
+   * @dev Initializes a reserve
+   * @param aTokenImpl  The address of the aToken contract implementation
+   * @param stableDebtTokenImpl The address of the stable debt token contract
+   * @param variableDebtTokenImpl The address of the variable debt token contract
+   * @param underlyingAssetDecimals The decimals of the reserve underlying asset
+   * @param interestRateStrategyAddress The address of the interest rate strategy contract for this reserve
    **/
-  function batchInitReserve(InitReserveInput[] calldata input) external onlyPoolAdmin {
-    ILendingPool cachedPool = pool;
-    for (uint256 i = 0; i < input.length; i++) {
-      _initReserve(cachedPool, input[i]);
-    }
-  }
+  function initReserve(
+    address aTokenImpl,
+    address stableDebtTokenImpl,
+    address variableDebtTokenImpl,
+    uint8 underlyingAssetDecimals,
+    address interestRateStrategyAddress
+  ) public onlyPoolAdmin {
+    address asset = ITokenConfiguration(aTokenImpl).UNDERLYING_ASSET_ADDRESS();
 
-  function _initReserve(ILendingPool pool, InitReserveInput calldata input) internal {
-    address aTokenProxyAddress =
-      _initTokenWithProxy(
-        input.aTokenImpl,
-        abi.encodeWithSelector(
-          IInitializableAToken.initialize.selector,
-          pool,
-          input.treasury,
-          input.underlyingAsset,
-          IAaveIncentivesController(input.incentivesController),
-          input.underlyingAssetDecimals,
-          input.aTokenName,
-          input.aTokenSymbol,
-          input.params
-        )
-      );
+    require(
+      address(pool) == ITokenConfiguration(aTokenImpl).POOL(),
+      Errors.LPC_INVALID_ATOKEN_POOL_ADDRESS
+    );
+    require(
+      address(pool) == ITokenConfiguration(stableDebtTokenImpl).POOL(),
+      Errors.LPC_INVALID_STABLE_DEBT_TOKEN_POOL_ADDRESS
+    );
+    require(
+      address(pool) == ITokenConfiguration(variableDebtTokenImpl).POOL(),
+      Errors.LPC_INVALID_VARIABLE_DEBT_TOKEN_POOL_ADDRESS
+    );
+    require(
+      asset == ITokenConfiguration(stableDebtTokenImpl).UNDERLYING_ASSET_ADDRESS(),
+      Errors.LPC_INVALID_STABLE_DEBT_TOKEN_UNDERLYING_ADDRESS
+    );
+    require(
+      asset == ITokenConfiguration(variableDebtTokenImpl).UNDERLYING_ASSET_ADDRESS(),
+      Errors.LPC_INVALID_VARIABLE_DEBT_TOKEN_UNDERLYING_ADDRESS
+    );
+
+    address aTokenProxyAddress = _initTokenWithProxy(aTokenImpl, underlyingAssetDecimals);
 
     address stableDebtTokenProxyAddress =
-      _initTokenWithProxy(
-        input.stableDebtTokenImpl,
-        abi.encodeWithSelector(
-          IInitializableDebtToken.initialize.selector,
-          pool,
-          input.underlyingAsset,
-          IAaveIncentivesController(input.incentivesController),
-          input.underlyingAssetDecimals,
-          input.stableDebtTokenName,
-          input.stableDebtTokenSymbol,
-          input.params
-        )
-      );
+      _initTokenWithProxy(stableDebtTokenImpl, underlyingAssetDecimals);
 
     address variableDebtTokenProxyAddress =
-      _initTokenWithProxy(
-        input.variableDebtTokenImpl,
-        abi.encodeWithSelector(
-          IInitializableDebtToken.initialize.selector,
-          pool,
-          input.underlyingAsset,
-          IAaveIncentivesController(input.incentivesController),
-          input.underlyingAssetDecimals,
-          input.variableDebtTokenName,
-          input.variableDebtTokenSymbol,
-          input.params
-        )
-      );
+      _initTokenWithProxy(variableDebtTokenImpl, underlyingAssetDecimals);
 
     pool.initReserve(
-      input.underlyingAsset,
+      asset,
       aTokenProxyAddress,
       stableDebtTokenProxyAddress,
       variableDebtTokenProxyAddress,
-      input.interestRateStrategyAddress
+      interestRateStrategyAddress
     );
 
-    DataTypes.ReserveConfigurationMap memory currentConfig =
-      pool.getConfiguration(input.underlyingAsset);
+    DataTypes.ReserveConfigurationMap memory currentConfig = pool.getConfiguration(asset);
 
-    currentConfig.setDecimals(input.underlyingAssetDecimals);
+    currentConfig.setDecimals(underlyingAssetDecimals);
 
     currentConfig.setActive(true);
     currentConfig.setFrozen(false);
 
-    pool.setConfiguration(input.underlyingAsset, currentConfig.data);
+    pool.setConfiguration(asset, currentConfig.data);
 
     emit ReserveInitialized(
-      input.underlyingAsset,
+      asset,
       aTokenProxyAddress,
       stableDebtTokenProxyAddress,
       variableDebtTokenProxyAddress,
-      input.interestRateStrategyAddress
+      interestRateStrategyAddress
     );
   }
 
   /**
    * @dev Updates the aToken implementation for the reserve
+   * @param asset The address of the underlying asset of the reserve to be updated
+   * @param implementation The address of the new aToken implementation
    **/
-  function updateAToken(UpdateATokenInput calldata input) external onlyPoolAdmin {
-    ILendingPool cachedPool = pool;
+  function updateAToken(address asset, address implementation) external onlyPoolAdmin {
+    DataTypes.ReserveData memory reserveData = pool.getReserveData(asset);
 
-    DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(input.asset);
+    _upgradeTokenImplementation(asset, reserveData.aTokenAddress, implementation);
 
-    (, , , uint256 decimals, ) = cachedPool.getConfiguration(input.asset).getParamsMemory();
-
-    bytes memory encodedCall = abi.encodeWithSelector(
-        IInitializableAToken.initialize.selector,
-        cachedPool,
-        input.treasury,
-        input.asset,
-        input.incentivesController,
-        decimals,
-        input.name,
-        input.symbol,
-        input.params
-      );
-
-    _upgradeTokenImplementation(
-      reserveData.aTokenAddress,
-      input.implementation,
-      encodedCall
-    );
-
-    emit ATokenUpgraded(input.asset, reserveData.aTokenAddress, input.implementation);
+    emit ATokenUpgraded(asset, reserveData.aTokenAddress, implementation);
   }
 
   /**
    * @dev Updates the stable debt token implementation for the reserve
+   * @param asset The address of the underlying asset of the reserve to be updated
+   * @param implementation The address of the new aToken implementation
    **/
-  function updateStableDebtToken(UpdateDebtTokenInput calldata input) external onlyPoolAdmin {
-    ILendingPool cachedPool = pool;
+  function updateStableDebtToken(address asset, address implementation) external onlyPoolAdmin {
+    DataTypes.ReserveData memory reserveData = pool.getReserveData(asset);
 
-    DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(input.asset);
+    _upgradeTokenImplementation(asset, reserveData.stableDebtTokenAddress, implementation);
 
-    (, , , uint256 decimals, ) = cachedPool.getConfiguration(input.asset).getParamsMemory();
-
-    bytes memory encodedCall = abi.encodeWithSelector(
-        IInitializableDebtToken.initialize.selector,
-        cachedPool,
-        input.asset,
-        input.incentivesController,
-        decimals,
-        input.name,
-        input.symbol,
-        input.params
-      );
-
-    _upgradeTokenImplementation(
-      reserveData.stableDebtTokenAddress,
-      input.implementation,
-      encodedCall
-    );
-
-    emit StableDebtTokenUpgraded(
-      input.asset,
-      reserveData.stableDebtTokenAddress,
-      input.implementation
-    );
+    emit StableDebtTokenUpgraded(asset, reserveData.stableDebtTokenAddress, implementation);
   }
 
   /**
    * @dev Updates the variable debt token implementation for the asset
+   * @param asset The address of the underlying asset of the reserve to be updated
+   * @param implementation The address of the new aToken implementation
    **/
-  function updateVariableDebtToken(UpdateDebtTokenInput calldata input)
-    external
-    onlyPoolAdmin
-  {
-    ILendingPool cachedPool = pool;
+  function updateVariableDebtToken(address asset, address implementation) external onlyPoolAdmin {
+    DataTypes.ReserveData memory reserveData = pool.getReserveData(asset);
 
-    DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(input.asset);
+    _upgradeTokenImplementation(asset, reserveData.variableDebtTokenAddress, implementation);
 
-    (, , , uint256 decimals, ) = cachedPool.getConfiguration(input.asset).getParamsMemory();
-
-    bytes memory encodedCall = abi.encodeWithSelector(
-        IInitializableDebtToken.initialize.selector,
-        cachedPool,
-        input.asset,
-        input.incentivesController,
-        decimals,
-        input.name,
-        input.symbol,
-        input.params
-      );
-
-    _upgradeTokenImplementation(
-      reserveData.variableDebtTokenAddress,
-      input.implementation,
-      encodedCall
-    );
-
-    emit VariableDebtTokenUpgraded(
-      input.asset,
-      reserveData.variableDebtTokenAddress,
-      input.implementation
-    );
+    emit VariableDebtTokenUpgraded(asset, reserveData.variableDebtTokenAddress, implementation);
   }
 
   /**
@@ -2382,27 +2153,44 @@ contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigur
     pool.setPause(val);
   }
 
-  function _initTokenWithProxy(address implementation, bytes memory initParams)
-    internal
-    returns (address)
-  {
+  function _initTokenWithProxy(address implementation, uint8 decimals) internal returns (address) {
     InitializableImmutableAdminUpgradeabilityProxy proxy =
       new InitializableImmutableAdminUpgradeabilityProxy(address(this));
 
-    proxy.initialize(implementation, initParams);
+    bytes memory params =
+      abi.encodeWithSignature(
+        'initialize(uint8,string,string)',
+        decimals,
+        IERC20Detailed(implementation).name(),
+        IERC20Detailed(implementation).symbol()
+      );
+
+    proxy.initialize(implementation, params);
 
     return address(proxy);
   }
 
   function _upgradeTokenImplementation(
+    address asset,
     address proxyAddress,
-    address implementation,
-    bytes memory initParams
+    address implementation
   ) internal {
     InitializableImmutableAdminUpgradeabilityProxy proxy =
       InitializableImmutableAdminUpgradeabilityProxy(payable(proxyAddress));
 
-    proxy.upgradeToAndCall(implementation, initParams);
+    DataTypes.ReserveConfigurationMap memory configuration = pool.getConfiguration(asset);
+
+    (, , , uint256 decimals, ) = configuration.getParamsMemory();
+
+    bytes memory params =
+      abi.encodeWithSignature(
+        'initialize(uint8,string,string)',
+        uint8(decimals),
+        IERC20Detailed(implementation).name(),
+        IERC20Detailed(implementation).symbol()
+      );
+
+    proxy.upgradeToAndCall(implementation, params);
   }
 
   function _checkNoLiquidity(address asset) internal view {
```
