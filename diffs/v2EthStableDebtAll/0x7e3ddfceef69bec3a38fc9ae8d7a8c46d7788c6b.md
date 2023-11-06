```diff
diff --git a/etherscan/v2EthStableDebtAllTokens/flattened/0xD23A44eB2db8AD0817c994D3533528C030279F7c.sol b/etherscan/v2EthStableDebtAllTokens/flattened/0x7e3ddfceef69bec3a38fc9ae8d7a8c46d7788c6b.sol
index 4998758..cc5fbd8 100644
--- a/etherscan/v2EthStableDebtAllTokens/flattened/0xD23A44eB2db8AD0817c994D3533528C030279F7c.sol
+++ b/etherscan/v2EthStableDebtAllTokens/flattened/0x7e3ddfceef69bec3a38fc9ae8d7a8c46d7788c6b.sol
@@ -585,14 +585,14 @@ abstract contract VersionedInitializable {
   }
 
   /**
-  * @dev returns the revision number of the contract
-  * Needs to be defined in the inherited class as a constant.
-  **/ 
+   * @dev returns the revision number of the contract
+   * Needs to be defined in the inherited class as a constant.
+   **/
   function getRevision() internal pure virtual returns (uint256);
 
   /**
-  * @dev Returns true if and only if the function is running in the constructor
-  **/ 
+   * @dev Returns true if and only if the function is running in the constructor
+   **/
   function isConstructor() private view returns (bool) {
     // extcodesize checks the size of the code stored in an address, and
     // address returns the current address. Since the code is still not
@@ -622,11 +622,11 @@ abstract contract VersionedInitializable {
  * This contract is only required for intermediate, library-like contracts.
  */
 abstract contract Context {
-  function _msgSender() internal virtual view returns (address payable) {
+  function _msgSender() internal view virtual returns (address payable) {
     return msg.sender;
   }
 
-  function _msgData() internal virtual view returns (bytes memory) {
+  function _msgData() internal view virtual returns (bytes memory) {
     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
     return msg.data;
   }
```
