```diff
diff --git a/etherscan/v2EthPoolConfigurator/flattened/PoolConfigurator.sol b/etherscan/v2AvaPoolConfigurator/flattened/PoolConfigurator.sol
index 43097d4..a9f418d 100644
--- a/etherscan/v2EthPoolConfigurator/flattened/PoolConfigurator.sol
+++ b/etherscan/v2AvaPoolConfigurator/flattened/PoolConfigurator.sol
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
@@ -1620,16 +1608,269 @@ library PercentageMath {
   }
 }
 
+interface IAaveIncentivesController {
+  event RewardsAccrued(address indexed user, uint256 amount);
+
+  event RewardsClaimed(address indexed user, address indexed to, uint256 amount);
+
+  event RewardsClaimed(
+    address indexed user,
+    address indexed to,
+    address indexed claimer,
+    uint256 amount
+  );
+
+  event ClaimerSet(address indexed user, address indexed claimer);
+
+  /*
+   * @dev Returns the configuration of the distribution for a certain asset
+   * @param asset The address of the reference asset of the distribution
+   * @return The asset index, the emission per second and the last updated timestamp
+   **/
+  function getAssetData(address asset) external view returns (uint256, uint256, uint256);
+
+  /*
+   * LEGACY **************************
+   * @dev Returns the configuration of the distribution for a certain asset
+   * @param asset The address of the reference asset of the distribution
+   * @return The asset index, the emission per second and the last updated timestamp
+   **/
+  function assets(address asset) external view returns (uint128, uint128, uint256);
+
+  /**
+   * @dev Whitelists an address to claim the rewards on behalf of another address
+   * @param user The address of the user
+   * @param claimer The address of the claimer
+   */
+  function setClaimer(address user, address claimer) external;
+
+  /**
+   * @dev Returns the whitelisted claimer for a certain address (0x0 if not set)
+   * @param user The address of the user
+   * @return The claimer address
+   */
+  function getClaimer(address user) external view returns (address);
+
+  /**
+   * @dev Configure assets for a certain rewards emission
+   * @param assets The assets to incentivize
+   * @param emissionsPerSecond The emission for each asset
+   */
+  function configureAssets(
+    address[] calldata assets,
+    uint256[] calldata emissionsPerSecond
+  ) external;
+
+  /**
+   * @dev Called by the corresponding asset on any update that affects the rewards distribution
+   * @param asset The address of the user
+   * @param userBalance The balance of the user of the asset in the lending pool
+   * @param totalSupply The total supply of the asset in the lending pool
+   **/
+  function handleAction(address asset, uint256 userBalance, uint256 totalSupply) external;
+
+  /**
+   * @dev Returns the total of rewards of an user, already accrued + not yet accrued
+   * @param user The address of the user
+   * @return The rewards
+   **/
+  function getRewardsBalance(
+    address[] calldata assets,
+    address user
+  ) external view returns (uint256);
+
+  /**
+   * @dev Claims reward for an user, on all the assets of the lending pool, accumulating the pending rewards
+   * @param amount Amount of rewards to claim
+   * @param to Address that will be receiving the rewards
+   * @return Rewards claimed
+   **/
+  function claimRewards(
+    address[] calldata assets,
+    uint256 amount,
+    address to
+  ) external returns (uint256);
+
+  /**
+   * @dev Claims reward for an user on behalf, on all the assets of the lending pool, accumulating the pending rewards. The caller must
+   * be whitelisted via "allowClaimOnBehalf" function by the RewardsAdmin role manager
+   * @param amount Amount of rewards to claim
+   * @param user Address to check and claim rewards
+   * @param to Address that will be receiving the rewards
+   * @return Rewards claimed
+   **/
+  function claimRewardsOnBehalf(
+    address[] calldata assets,
+    uint256 amount,
+    address user,
+    address to
+  ) external returns (uint256);
+
+  /**
+   * @dev returns the unclaimed rewards of the user
+   * @param user the address of the user
+   * @return the unclaimed user rewards
+   */
+  function getUserUnclaimedRewards(address user) external view returns (uint256);
+
+  /**
+   * @dev returns the unclaimed rewards of the user
+   * @param user the address of the user
+   * @param asset The asset to incentivize
+   * @return the user index for the asset
+   */
+  function getUserAssetData(address user, address asset) external view returns (uint256);
+
+  /**
+   * @dev for backward compatibility with previous implementation of the Incentives controller
+   */
+  function REWARD_TOKEN() external view returns (address);
+
+  /**
+   * @dev for backward compatibility with previous implementation of the Incentives controller
+   */
+  function PRECISION() external view returns (uint8);
+
+  /**
+   * @dev Gets the distribution end timestamp of the emissions
+   */
+  function DISTRIBUTION_END() external view returns (uint256);
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
@@ -1766,6 +2007,18 @@ contract LendingPoolConfigurator is VersionedInitializable {
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
@@ -1795,118 +2048,180 @@ contract LendingPoolConfigurator is VersionedInitializable {
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
@@ -2117,44 +2432,29 @@ contract LendingPoolConfigurator is VersionedInitializable {
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
