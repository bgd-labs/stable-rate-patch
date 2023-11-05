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
