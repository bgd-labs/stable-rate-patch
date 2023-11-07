```diff
diff --git a/etherscan/v2EthPoolConfigurator/flattened/PoolConfigurator.sol b/etherscan/v2PolPoolConfigurator/flattened/PoolConfigurator.sol
index 43097d4..1a96fa8 100644
--- a/etherscan/v2EthPoolConfigurator/flattened/PoolConfigurator.sol
+++ b/etherscan/v2PolPoolConfigurator/flattened/PoolConfigurator.sol
@@ -1476,18 +1476,6 @@ interface ILendingPool {
   function paused() external view returns (bool);
 }
 
-/**
- * @title ITokenConfiguration
- * @author Aave
- * @dev Common interface between aTokens and debt tokens to fetch the
- * token configuration
- **/
-interface ITokenConfiguration {
-  function UNDERLYING_ASSET_ADDRESS() external view returns (address);
-
-  function POOL() external view returns (address);
-}
-
 /**
  * @dev Interface of the ERC20 standard as defined in the EIP.
  */
@@ -1620,16 +1608,144 @@ library PercentageMath {
   }
 }
 
+interface IAaveIncentivesController {
+  function handleAction(address user, uint256 userBalance, uint256 totalSupply) external;
+}
+
 /**
- * @title LendingPoolConfigurator contract
+ * @title IInitializableDebtToken
+ * @notice Interface for the initialize function common between debt tokens
  * @author Aave
- * @dev Implements the configuration methods for the Aave protocol
  **/
+interface IInitializableDebtToken {
+  /**
+   * @dev Emitted when a debt token is initialized
+   * @param underlyingAsset The address of the underlying asset
+   * @param pool The address of the associated lending pool
+   * @param incentivesController The address of the incentives controller for this aToken
+   * @param debtTokenDecimals the decimals of the debt token
+   * @param debtTokenName the name of the debt token
+   * @param debtTokenSymbol the symbol of the debt token
+   * @param params A set of encoded parameters for additional initialization
+   **/
+  event Initialized(
+    address indexed underlyingAsset,
+    address indexed pool,
+    address incentivesController,
+    uint8 debtTokenDecimals,
+    string debtTokenName,
+    string debtTokenSymbol,
+    bytes params
+  );
+
+  /**
+   * @dev Initializes the debt token.
+   * @param pool The address of the lending pool where this aToken will be used
+   * @param underlyingAsset The address of the underlying asset of this aToken (E.g. WETH for aWETH)
+   * @param incentivesController The smart contract managing potential incentives distribution
+   * @param debtTokenDecimals The decimals of the debtToken, same as the underlying asset's
+   * @param debtTokenName The name of the token
+   * @param debtTokenSymbol The symbol of the token
+   */
+  function initialize(
+    ILendingPool pool,
+    address underlyingAsset,
+    IAaveIncentivesController incentivesController,
+    uint8 debtTokenDecimals,
+    string memory debtTokenName,
+    string memory debtTokenSymbol,
+    bytes calldata params
+  ) external;
+}
+
+/**
+ * @title IInitializableAToken
+ * @notice Interface for the initialize function on AToken
+ * @author Aave
+ **/
+interface IInitializableAToken {
+  /**
+   * @dev Emitted when an aToken is initialized
+   * @param underlyingAsset The address of the underlying asset
+   * @param pool The address of the associated lending pool
+   * @param treasury The address of the treasury
+   * @param incentivesController The address of the incentives controller for this aToken
+   * @param aTokenDecimals the decimals of the underlying
+   * @param aTokenName the name of the aToken
+   * @param aTokenSymbol the symbol of the aToken
+   * @param params A set of encoded parameters for additional initialization
+   **/
+  event Initialized(
+    address indexed underlyingAsset,
+    address indexed pool,
+    address treasury,
+    address incentivesController,
+    uint8 aTokenDecimals,
+    string aTokenName,
+    string aTokenSymbol,
+    bytes params
+  );
+
+  /**
+   * @dev Initializes the aToken
+   * @param pool The address of the lending pool where this aToken will be used
+   * @param treasury The address of the Aave treasury, receiving the fees on this aToken
+   * @param underlyingAsset The address of the underlying asset of this aToken (E.g. WETH for aWETH)
+   * @param incentivesController The smart contract managing potential incentives distribution
+   * @param aTokenDecimals The decimals of the aToken, same as the underlying asset's
+   * @param aTokenName The name of the aToken
+   * @param aTokenSymbol The symbol of the aToken
+   */
+  function initialize(
+    ILendingPool pool,
+    address treasury,
+    address underlyingAsset,
+    IAaveIncentivesController incentivesController,
+    uint8 aTokenDecimals,
+    string calldata aTokenName,
+    string calldata aTokenSymbol,
+    bytes calldata params
+  ) external;
+}
+
+interface ILendingPoolConfigurator {
+  struct InitReserveInput {
+    address aTokenImpl;
+    address stableDebtTokenImpl;
+    address variableDebtTokenImpl;
+    uint8 underlyingAssetDecimals;
+    address interestRateStrategyAddress;
+    address underlyingAsset;
+    address treasury;
+    address incentivesController;
+    string underlyingAssetName;
+    string aTokenName;
+    string aTokenSymbol;
+    string variableDebtTokenName;
+    string variableDebtTokenSymbol;
+    string stableDebtTokenName;
+    string stableDebtTokenSymbol;
+    bytes params;
+  }
+
+  struct UpdateATokenInput {
+    address asset;
+    address treasury;
+    address incentivesController;
+    string name;
+    string symbol;
+    address implementation;
+    bytes params;
+  }
 
-contract LendingPoolConfigurator is VersionedInitializable {
-  using SafeMath for uint256;
-  using PercentageMath for uint256;
-  using ReserveConfiguration for DataTypes.ReserveConfigurationMap;
+  struct UpdateDebtTokenInput {
+    address asset;
+    address incentivesController;
+    string name;
+    string symbol;
+    address implementation;
+    bytes params;
+  }
 
   /**
    * @dev Emitted when a reserve is initialized.
@@ -1766,6 +1882,18 @@ contract LendingPoolConfigurator is VersionedInitializable {
     address indexed proxy,
     address indexed implementation
   );
+}
+
+/**
+ * @title LendingPoolConfigurator contract
+ * @author Aave
+ * @dev Implements the configuration methods for the Aave protocol
+ **/
+
+contract LendingPoolConfigurator is VersionedInitializable, ILendingPoolConfigurator {
+  using SafeMath for uint256;
+  using PercentageMath for uint256;
+  using ReserveConfiguration for DataTypes.ReserveConfigurationMap;
 
   ILendingPoolAddressesProvider internal addressesProvider;
   ILendingPool internal pool;
@@ -1795,118 +1923,180 @@ contract LendingPoolConfigurator is VersionedInitializable {
   }
 
   /**
-   * @dev Initializes a reserve
-   * @param aTokenImpl  The address of the aToken contract implementation
-   * @param stableDebtTokenImpl The address of the stable debt token contract
-   * @param variableDebtTokenImpl The address of the variable debt token contract
-   * @param underlyingAssetDecimals The decimals of the reserve underlying asset
-   * @param interestRateStrategyAddress The address of the interest rate strategy contract for this reserve
+   * @dev Initializes reserves in batch
    **/
-  function initReserve(
-    address aTokenImpl,
-    address stableDebtTokenImpl,
-    address variableDebtTokenImpl,
-    uint8 underlyingAssetDecimals,
-    address interestRateStrategyAddress
-  ) public onlyPoolAdmin {
-    address asset = ITokenConfiguration(aTokenImpl).UNDERLYING_ASSET_ADDRESS();
+  function batchInitReserve(InitReserveInput[] calldata input) external onlyPoolAdmin {
+    ILendingPool cachedPool = pool;
+    for (uint256 i = 0; i < input.length; i++) {
+      _initReserve(cachedPool, input[i]);
+    }
+  }
 
-    require(
-      address(pool) == ITokenConfiguration(aTokenImpl).POOL(),
-      Errors.LPC_INVALID_ATOKEN_POOL_ADDRESS
+  function _initReserve(ILendingPool pool, InitReserveInput calldata input) internal {
+    address aTokenProxyAddress = _initTokenWithProxy(
+      input.aTokenImpl,
+      abi.encodeWithSelector(
+        IInitializableAToken.initialize.selector,
+        pool,
+        input.treasury,
+        input.underlyingAsset,
+        IAaveIncentivesController(input.incentivesController),
+        input.underlyingAssetDecimals,
+        input.aTokenName,
+        input.aTokenSymbol,
+        input.params
+      )
     );
-    require(
-      address(pool) == ITokenConfiguration(stableDebtTokenImpl).POOL(),
-      Errors.LPC_INVALID_STABLE_DEBT_TOKEN_POOL_ADDRESS
-    );
-    require(
-      address(pool) == ITokenConfiguration(variableDebtTokenImpl).POOL(),
-      Errors.LPC_INVALID_VARIABLE_DEBT_TOKEN_POOL_ADDRESS
-    );
-    require(
-      asset == ITokenConfiguration(stableDebtTokenImpl).UNDERLYING_ASSET_ADDRESS(),
-      Errors.LPC_INVALID_STABLE_DEBT_TOKEN_UNDERLYING_ADDRESS
-    );
-    require(
-      asset == ITokenConfiguration(variableDebtTokenImpl).UNDERLYING_ASSET_ADDRESS(),
-      Errors.LPC_INVALID_VARIABLE_DEBT_TOKEN_UNDERLYING_ADDRESS
-    );
-
-    address aTokenProxyAddress = _initTokenWithProxy(aTokenImpl, underlyingAssetDecimals);
 
     address stableDebtTokenProxyAddress = _initTokenWithProxy(
-      stableDebtTokenImpl,
-      underlyingAssetDecimals
+      input.stableDebtTokenImpl,
+      abi.encodeWithSelector(
+        IInitializableDebtToken.initialize.selector,
+        pool,
+        input.underlyingAsset,
+        IAaveIncentivesController(input.incentivesController),
+        input.underlyingAssetDecimals,
+        input.stableDebtTokenName,
+        input.stableDebtTokenSymbol,
+        input.params
+      )
     );
 
     address variableDebtTokenProxyAddress = _initTokenWithProxy(
-      variableDebtTokenImpl,
-      underlyingAssetDecimals
+      input.variableDebtTokenImpl,
+      abi.encodeWithSelector(
+        IInitializableDebtToken.initialize.selector,
+        pool,
+        input.underlyingAsset,
+        IAaveIncentivesController(input.incentivesController),
+        input.underlyingAssetDecimals,
+        input.variableDebtTokenName,
+        input.variableDebtTokenSymbol,
+        input.params
+      )
     );
 
     pool.initReserve(
-      asset,
+      input.underlyingAsset,
       aTokenProxyAddress,
       stableDebtTokenProxyAddress,
       variableDebtTokenProxyAddress,
-      interestRateStrategyAddress
+      input.interestRateStrategyAddress
     );
 
-    DataTypes.ReserveConfigurationMap memory currentConfig = pool.getConfiguration(asset);
+    DataTypes.ReserveConfigurationMap memory currentConfig = pool.getConfiguration(
+      input.underlyingAsset
+    );
 
-    currentConfig.setDecimals(underlyingAssetDecimals);
+    currentConfig.setDecimals(input.underlyingAssetDecimals);
 
     currentConfig.setActive(true);
     currentConfig.setFrozen(false);
 
-    pool.setConfiguration(asset, currentConfig.data);
+    pool.setConfiguration(input.underlyingAsset, currentConfig.data);
 
     emit ReserveInitialized(
-      asset,
+      input.underlyingAsset,
       aTokenProxyAddress,
       stableDebtTokenProxyAddress,
       variableDebtTokenProxyAddress,
-      interestRateStrategyAddress
+      input.interestRateStrategyAddress
     );
   }
 
   /**
    * @dev Updates the aToken implementation for the reserve
-   * @param asset The address of the underlying asset of the reserve to be updated
-   * @param implementation The address of the new aToken implementation
    **/
-  function updateAToken(address asset, address implementation) external onlyPoolAdmin {
-    DataTypes.ReserveData memory reserveData = pool.getReserveData(asset);
+  function updateAToken(UpdateATokenInput calldata input) external onlyPoolAdmin {
+    ILendingPool cachedPool = pool;
 
-    _upgradeTokenImplementation(asset, reserveData.aTokenAddress, implementation);
+    DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(input.asset);
 
-    emit ATokenUpgraded(asset, reserveData.aTokenAddress, implementation);
+    (, , , uint256 decimals, ) = cachedPool.getConfiguration(input.asset).getParamsMemory();
+
+    bytes memory encodedCall = abi.encodeWithSelector(
+      IInitializableAToken.initialize.selector,
+      cachedPool,
+      input.treasury,
+      input.asset,
+      input.incentivesController,
+      decimals,
+      input.name,
+      input.symbol,
+      input.params
+    );
+
+    _upgradeTokenImplementation(reserveData.aTokenAddress, input.implementation, encodedCall);
+
+    emit ATokenUpgraded(input.asset, reserveData.aTokenAddress, input.implementation);
   }
 
   /**
    * @dev Updates the stable debt token implementation for the reserve
-   * @param asset The address of the underlying asset of the reserve to be updated
-   * @param implementation The address of the new aToken implementation
    **/
-  function updateStableDebtToken(address asset, address implementation) external onlyPoolAdmin {
-    DataTypes.ReserveData memory reserveData = pool.getReserveData(asset);
+  function updateStableDebtToken(UpdateDebtTokenInput calldata input) external onlyPoolAdmin {
+    ILendingPool cachedPool = pool;
 
-    _upgradeTokenImplementation(asset, reserveData.stableDebtTokenAddress, implementation);
+    DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(input.asset);
 
-    emit StableDebtTokenUpgraded(asset, reserveData.stableDebtTokenAddress, implementation);
+    (, , , uint256 decimals, ) = cachedPool.getConfiguration(input.asset).getParamsMemory();
+
+    bytes memory encodedCall = abi.encodeWithSelector(
+      IInitializableDebtToken.initialize.selector,
+      cachedPool,
+      input.asset,
+      input.incentivesController,
+      decimals,
+      input.name,
+      input.symbol,
+      input.params
+    );
+
+    _upgradeTokenImplementation(
+      reserveData.stableDebtTokenAddress,
+      input.implementation,
+      encodedCall
+    );
+
+    emit StableDebtTokenUpgraded(
+      input.asset,
+      reserveData.stableDebtTokenAddress,
+      input.implementation
+    );
   }
 
   /**
    * @dev Updates the variable debt token implementation for the asset
-   * @param asset The address of the underlying asset of the reserve to be updated
-   * @param implementation The address of the new aToken implementation
    **/
-  function updateVariableDebtToken(address asset, address implementation) external onlyPoolAdmin {
-    DataTypes.ReserveData memory reserveData = pool.getReserveData(asset);
+  function updateVariableDebtToken(UpdateDebtTokenInput calldata input) external onlyPoolAdmin {
+    ILendingPool cachedPool = pool;
 
-    _upgradeTokenImplementation(asset, reserveData.variableDebtTokenAddress, implementation);
+    DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(input.asset);
 
-    emit VariableDebtTokenUpgraded(asset, reserveData.variableDebtTokenAddress, implementation);
+    (, , , uint256 decimals, ) = cachedPool.getConfiguration(input.asset).getParamsMemory();
+
+    bytes memory encodedCall = abi.encodeWithSelector(
+      IInitializableDebtToken.initialize.selector,
+      cachedPool,
+      input.asset,
+      input.incentivesController,
+      decimals,
+      input.name,
+      input.symbol,
+      input.params
+    );
+
+    _upgradeTokenImplementation(
+      reserveData.variableDebtTokenAddress,
+      input.implementation,
+      encodedCall
+    );
+
+    emit VariableDebtTokenUpgraded(
+      input.asset,
+      reserveData.variableDebtTokenAddress,
+      input.implementation
+    );
   }
 
   /**
@@ -2117,44 +2307,29 @@ contract LendingPoolConfigurator is VersionedInitializable {
     pool.setPause(val);
   }
 
-  function _initTokenWithProxy(address implementation, uint8 decimals) internal returns (address) {
+  function _initTokenWithProxy(
+    address implementation,
+    bytes memory initParams
+  ) internal returns (address) {
     InitializableImmutableAdminUpgradeabilityProxy proxy = new InitializableImmutableAdminUpgradeabilityProxy(
         address(this)
       );
 
-    bytes memory params = abi.encodeWithSignature(
-      'initialize(uint8,string,string)',
-      decimals,
-      IERC20Detailed(implementation).name(),
-      IERC20Detailed(implementation).symbol()
-    );
-
-    proxy.initialize(implementation, params);
+    proxy.initialize(implementation, initParams);
 
     return address(proxy);
   }
 
   function _upgradeTokenImplementation(
-    address asset,
     address proxyAddress,
-    address implementation
+    address implementation,
+    bytes memory initParams
   ) internal {
     InitializableImmutableAdminUpgradeabilityProxy proxy = InitializableImmutableAdminUpgradeabilityProxy(
         payable(proxyAddress)
       );
 
-    DataTypes.ReserveConfigurationMap memory configuration = pool.getConfiguration(asset);
-
-    (, , , uint256 decimals, ) = configuration.getParamsMemory();
-
-    bytes memory params = abi.encodeWithSignature(
-      'initialize(uint8,string,string)',
-      uint8(decimals),
-      IERC20Detailed(implementation).name(),
-      IERC20Detailed(implementation).symbol()
-    );
-
-    proxy.upgradeToAndCall(implementation, params);
+    proxy.upgradeToAndCall(implementation, initParams);
   }
 
   function _checkNoLiquidity(address asset) internal view {
```
