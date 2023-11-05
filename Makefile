# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# deps
update:; forge update

# Build & test
build  :; forge build --sizes
test   :; forge test -vvv

# Utilities
download :; cast etherscan-source --chain ${chain} -d src/etherscan/${chain}_${address} ${address}
git-diff :
	@mkdir -p diffs
	@printf '%s\n%s\n%s\n' "\`\`\`diff" "$$(git diff --no-index --diff-algorithm=patience --ignore-space-at-eol ${before} ${after})" "\`\`\`" > diffs/${out}.md

download-all-etherscan :;
	cast etherscan-source --chain 1 -d etherscan/v2EthLendingPoolCollateralManager 0xbd4765210d4167CE2A5b87280D9E8Ee316D5EC7C
	cast etherscan-source --chain 137 -d etherscan/v2PolLendingPoolCollateralManager 0xa39599424642d9fd35e475ef802eddf798dc555b
	cast etherscan-source --chain 43114 -d etherscan/v2AvaLendingPoolCollateralManager 0xa9c1bb836752a2Dfb3694ca084D8ffBB07768771

	cast etherscan-source --chain 1 -d etherscan/v2EthStableDebtToken 0xD23A44eB2db8AD0817c994D3533528C030279F7c
	cast etherscan-source --chain 137 -d etherscan/v2PolStableDebtToken 0x72a053fa208eaafa53adb1a1ea6b4b2175b5735e
	cast etherscan-source --chain 43114 -d etherscan/v2AvaStableDebtToken 0xe42d0Dc2CD1d96B88321371BB31BfB0085240124

	cast etherscan-source --chain 137 -d etherscan/v3PolPool 0xb77fc84a549ecc0b410d6fa15159C2df207545a3
	cast etherscan-source --chain 42161 -d etherscan/v3ArbPool 0xbcb167bdcf14a8f791d6f4a6edd964aed2f8813b
	cast etherscan-source --chain 10 -d etherscan/v3OptPool 0x764594f8e9757ede877b75716f8077162b251460
	cast etherscan-source --chain 43114 -d etherscan/v3AvaPool 0xcf85ff1c37c594a10195f7a9ab85cbb0a03f69de

	cast etherscan-source --chain 137 -d etherscan/v3PolStableDebtToken 0x50ddd0Cd4266299527d25De9CBb55fE0EB8dAc30
	cast etherscan-source --chain 42161 -d etherscan/v3ArbStableDebtToken 0x0c2C95b24529664fE55D4437D7A31175CFE6c4f7
	cast etherscan-source --chain 10 -d etherscan/v3OptStableDebtToken 0x6b4E260b765B3cA1514e618C0215A6B7839fF93e
	cast etherscan-source --chain 43114 -d etherscan/v3AvaStableDebtToken 0x893411580e590D62dDBca8a703d61Cc4A8c7b2b9

diff-contracts :;
	make git-diff before=etherscan/v2EthLendingPoolCollateralManager after=src/v2EthLendingPoolCollateralManager out=v2EthLendingPoolCollateralManager

storage-diff :;
	forge inspect src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol:LendingPoolCollateralManager storage-layout --pretty > reports/v2EthLendingPoolCollateralManager_layout.md
	npm run clean-storage-report v2EthLendingPoolCollateralManager_layout
	forge inspect src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol:LendingPoolCollateralManager storage-layout --pretty > reports/updated_v2EthLendingPoolCollateralManager_layout.md
	npm run clean-storage-report updated_v2EthLendingPoolCollateralManager_layout
	make git-diff before=reports/v2EthLendingPoolCollateralManager_layout.md after=reports/updated_v2EthLendingPoolCollateralManager_layout.md out=v2EthLendingPoolCollateralManager_diff
