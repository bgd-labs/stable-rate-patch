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

get-proxy-impl :;
	@cast implementation ${address} --rpc-url ${rpc}

git-diff :;
	@mkdir -p diffs
	@printf '%s\n%s\n%s\n' "\`\`\`diff" "$$(git diff --no-index --diff-algorithm=patience --ignore-space-at-eol ${before} ${after})" "\`\`\`" > diffs/${out}.md

download-all-etherscan :;
	cast etherscan-source --chain 1 -d etherscan/v2EthLendingPoolCollateralManager 0xbd4765210d4167CE2A5b87280D9E8Ee316D5EC7C
	cast etherscan-source --chain 137 -d etherscan/v2PolLendingPoolCollateralManager 0xa39599424642d9fd35e475ef802eddf798dc555b
	cast etherscan-source --chain 43114 -d etherscan/v2AvaLendingPoolCollateralManager 0xa9c1bb836752a2Dfb3694ca084D8ffBB07768771

	cast etherscan-source --chain 1 -d etherscan/v2EthStableDebtToken 0xD23A44eB2db8AD0817c994D3533528C030279F7c

	cast etherscan-source --chain 137 -d etherscan/v3PolPool 0xb77fc84a549ecc0b410d6fa15159C2df207545a3
	cast etherscan-source --chain 42161 -d etherscan/v3ArbPool 0xbcb167bdcf14a8f791d6f4a6edd964aed2f8813b
	cast etherscan-source --chain 10 -d etherscan/v3OptPool 0x764594f8e9757ede877b75716f8077162b251460
	cast etherscan-source --chain 43114 -d etherscan/v3AvaPool 0xcf85ff1c37c594a10195f7a9ab85cbb0a03f69de

	cast etherscan-source --chain 137 -d etherscan/v3PolStableDebtToken 0x50ddd0Cd4266299527d25De9CBb55fE0EB8dAc30
	cast etherscan-source --chain 42161 -d etherscan/v3ArbStableDebtToken 0x0c2C95b24529664fE55D4437D7A31175CFE6c4f7
	cast etherscan-source --chain 10 -d etherscan/v3OptStableDebtToken 0x6b4E260b765B3cA1514e618C0215A6B7839fF93e
	cast etherscan-source --chain 43114 -d etherscan/v3AvaStableDebtToken 0x893411580e590D62dDBca8a703d61Cc4A8c7b2b9

	cast etherscan-source --chain 1 -d etherscan/v2EthPoolConfigurator 0x3a95ee42f080ff7289c8b4a14eb483a8644d7521
	forge flatten etherscan/v2EthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol --output etherscan/v2EthPoolConfigurator/flattened/PoolConfigurator.sol

	cast etherscan-source --chain 137 -d etherscan/v2PolPoolConfigurator 0xf70a4d422e772926852ba9044026f169e6ad9492
	forge flatten etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol --output etherscan/v2PolPoolConfigurator/flattened/PoolConfigurator.sol

	cast etherscan-source --chain 43114 -d etherscan/v2AvaPoolConfigurator 0xc7938af7ec68c3d5ac3a396e28661b3e366b8fcf
	forge flatten etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol --output etherscan/v2AvaPoolConfigurator/flattened/PoolConfigurator.sol

diff-contracts :;
	make git-diff before=etherscan/v2EthLendingPoolCollateralManager after=src/v2EthLendingPoolCollateralManager out=v2EthLendingPoolCollateralManager
	make git-diff before=etherscan/v2PolLendingPoolCollateralManager after=src/v2PolLendingPoolCollateralManager out=v2PolLendingPoolCollateralManager
	make git-diff before=etherscan/v2AvaLendingPoolCollateralManager after=src/v2AvaLendingPoolCollateralManager out=v2AvaLendingPoolCollateralManager

	make git-diff before=etherscan/v2EthStableDebtToken after=src/v2EthStableDebtToken out=v2EthStableDebtToken

	make git-diff before=etherscan/v3PolPool after=src/v3PolPool out=v3PolPool
	make git-diff before=etherscan/v3ArbPool after=src/v3ArbPool out=v3ArbPool
	make git-diff before=etherscan/v3OptPool after=src/v3OptPool out=v3OptPool
	make git-diff before=etherscan/v3AvaPool after=src/v3AvaPool out=v3AvaPool

	make git-diff before=etherscan/v3PolStableDebtToken after=src/v3PolStableDebtToken out=v3PolStableDebtToken
	make git-diff before=etherscan/v3ArbStableDebtToken after=src/v3ArbStableDebtToken out=v3ArbStableDebtToken
	make git-diff before=etherscan/v3OptStableDebtToken after=src/v3OptStableDebtToken out=v3OptStableDebtToken
	make git-diff before=etherscan/v3AvaStableDebtToken after=src/v3AvaStableDebtToken out=v3AvaStableDebtToken

	make git-diff before=etherscan/v2EthPoolConfigurator/flattened/PoolConfigurator.sol after=etherscan/v2PolPoolConfigurator/flattened/PoolConfigurator.sol out=v2EthPolPoolConfigurator
	make git-diff before=etherscan/v2PolPoolConfigurator/flattened/PoolConfigurator.sol after=etherscan/v2AvaPoolConfigurator/flattened/PoolConfigurator.sol out=v2PolAvaPoolConfigurator
	make git-diff before=etherscan/v2EthPoolConfigurator/flattened/PoolConfigurator.sol after=etherscan/v2AvaPoolConfigurator/flattened/PoolConfigurator.sol out=v2EthAvaPoolConfigurator

	make git-diff before=etherscan/v3PolStableDebtToken after=etherscan/v3ArbStableDebtToken out=v3PolArbStableDebtToken
	make git-diff before=etherscan/v3PolStableDebtToken after=etherscan/v3OptStableDebtToken out=v3PolOptStableDebtToken
	make git-diff before=etherscan/v3PolStableDebtToken after=etherscan/v3AvaStableDebtToken out=v3PolAvaStableDebtToken

storage-diff :;
	# LendingPoolCollateralManager

	forge inspect etherscan/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol:LendingPoolCollateralManager storage-layout --pretty > reports/v2EthLendingPoolCollateralManager_layout.md
	npm run clean-storage-report v2EthLendingPoolCollateralManager_layout
	forge inspect src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol:LendingPoolCollateralManager storage-layout --pretty > reports/updated_v2EthLendingPoolCollateralManager_layout.md
	npm run clean-storage-report updated_v2EthLendingPoolCollateralManager_layout
	make git-diff before=reports/v2EthLendingPoolCollateralManager_layout.md after=reports/updated_v2EthLendingPoolCollateralManager_layout.md out=v2EthLendingPoolCollateralManager_layout_diff

	forge inspect etherscan/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol:LendingPoolCollateralManager storage-layout --pretty > reports/v2PolLendingPoolCollateralManager_layout.md
	npm run clean-storage-report v2PolLendingPoolCollateralManager_layout
	forge inspect src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol:LendingPoolCollateralManager storage-layout --pretty > reports/updated_v2PolLendingPoolCollateralManager_layout.md
	npm run clean-storage-report updated_v2PolLendingPoolCollateralManager_layout
	make git-diff before=reports/v2PolLendingPoolCollateralManager_layout.md after=reports/updated_v2PolLendingPoolCollateralManager_layout.md out=v2PolLendingPoolCollateralManager_layout_diff

	forge inspect etherscan/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol:LendingPoolCollateralManager storage-layout --pretty > reports/v2AvaLendingPoolCollateralManager_layout.md
	npm run clean-storage-report v2AvaLendingPoolCollateralManager_layout
	forge inspect src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol:LendingPoolCollateralManager storage-layout --pretty > reports/updated_v2AvaLendingPoolCollateralManager_layout.md
	npm run clean-storage-report updated_v2AvaLendingPoolCollateralManager_layout
	make git-diff before=reports/v2AvaLendingPoolCollateralManager_layout.md after=reports/updated_v2AvaLendingPoolCollateralManager_layout.md out=v2AvaLendingPoolCollateralManager_layout_diff

	# v2 stable debt token

	forge inspect etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol:StableDebtToken storage-layout --pretty > reports/v2EthStableDebtToken_layout.md
	npm run clean-storage-report v2EthStableDebtToken_layout
	forge inspect src/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol:StableDebtToken storage-layout --pretty > reports/updated_v2EthStableDebtToken_layout.md
	npm run clean-storage-report updated_v2EthStableDebtToken_layout
	make git-diff before=reports/v2EthStableDebtToken_layout.md after=reports/updated_v2EthStableDebtToken_layout.md out=v2EthStableDebtToken_layout_diff

	# v3 pools

	forge inspect etherscan/v3PolPool/Pool/lib/aave-v3-core/contracts/protocol/pool/Pool.sol:Pool storage-layout --pretty > reports/v3PolPool_layout.md
	npm run clean-storage-report v3PolPool_layout
	forge inspect src/v3PolPool/Pool/lib/aave-v3-core/contracts/protocol/pool/Pool.sol:Pool storage-layout --pretty > reports/updated_v3PolPool_layout.md
	npm run clean-storage-report updated_v3PolPool_layout
	make git-diff before=reports/v3PolPool_layout.md after=reports/updated_v3PolPool_layout.md out=v3PolPool_layout_diff

	forge inspect etherscan/v3ArbPool/L2Pool/lib/aave-v3-core/contracts/protocol/pool/L2Pool.sol:L2Pool storage-layout --pretty > reports/v3ArbPool_layout.md
	npm run clean-storage-report v3ArbPool_layout
	forge inspect src/v3ArbPool/L2Pool/lib/aave-v3-core/contracts/protocol/pool/L2Pool.sol:L2Pool storage-layout --pretty > reports/updated_v3ArbPool_layout.md
	npm run clean-storage-report updated_v3ArbPool_layout
	make git-diff before=reports/v3ArbPool_layout.md after=reports/updated_v3ArbPool_layout.md out=v3ArbPool_layout_diff

	forge inspect etherscan/v3OptPool/L2Pool/lib/aave-v3-core/contracts/protocol/pool/L2Pool.sol:L2Pool storage-layout --pretty > reports/v3OptPool_layout.md
	npm run clean-storage-report v3OptPool_layout
	forge inspect src/v3OptPool/L2Pool/lib/aave-v3-core/contracts/protocol/pool/L2Pool.sol:L2Pool storage-layout --pretty > reports/updated_v3OptPool_layout.md
	npm run clean-storage-report updated_v3OptPool_layout
	make git-diff before=reports/v3OptPool_layout.md after=reports/updated_v3OptPool_layout.md out=v3OptPool_layout_diff

	forge inspect etherscan/v3AvaPool/Pool/lib/aave-v3-core/contracts/protocol/pool/Pool.sol:Pool storage-layout --pretty > reports/v3AvaPool_layout.md
	npm run clean-storage-report v3AvaPool_layout
	forge inspect src/v3AvaPool/Pool/lib/aave-v3-core/contracts/protocol/pool/Pool.sol:Pool storage-layout --pretty > reports/updated_v3AvaPool_layout.md
	npm run clean-storage-report updated_v3AvaPool_layout
	make git-diff before=reports/v3AvaPool_layout.md after=reports/updated_v3AvaPool_layout.md out=v3AvaPool_layout_diff

	# v3 stable debt token

	forge inspect etherscan/v3PolStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol:StableDebtToken storage-layout --pretty > reports/v3PolStableDebtToken_layout.md
	npm run clean-storage-report v3PolStableDebtToken_layout
	forge inspect src/v3PolStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol:StableDebtToken storage-layout --pretty > reports/updated_v3PolStableDebtToken_layout.md
	npm run clean-storage-report updated_v3PolStableDebtToken_layout
	make git-diff before=reports/v3PolStableDebtToken_layout.md after=reports/updated_v3PolStableDebtToken_layout.md out=v3PolStableDebtToken_layout_diff

	forge inspect etherscan/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol:StableDebtToken storage-layout --pretty > reports/v3ArbStableDebtToken_layout.md
	npm run clean-storage-report v3ArbStableDebtToken_layout
	forge inspect src/v3ArbStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol:StableDebtToken storage-layout --pretty > reports/updated_v3ArbStableDebtToken_layout.md
	npm run clean-storage-report updated_v3ArbStableDebtToken_layout
	make git-diff before=reports/v3ArbStableDebtToken_layout.md after=reports/updated_v3ArbStableDebtToken_layout.md out=v3ArbStableDebtToken_layout_diff

	forge inspect etherscan/v3OptStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol:StableDebtToken storage-layout --pretty > reports/v3OptStableDebtToken_layout.md
	npm run clean-storage-report v3OptStableDebtToken_layout
	forge inspect src/v3OptStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol:StableDebtToken storage-layout --pretty > reports/updated_v3OptStableDebtToken_layout.md
	npm run clean-storage-report updated_v3OptStableDebtToken_layout
	make git-diff before=reports/v3OptStableDebtToken_layout.md after=reports/updated_v3OptStableDebtToken_layout.md out=v3OptStableDebtToken_layout_diff

	forge inspect etherscan/v3AvaStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol:StableDebtToken storage-layout --pretty > reports/v3AvaStableDebtToken_layout.md
	npm run clean-storage-report v3AvaStableDebtToken_layout
	forge inspect src/v3AvaStableDebtToken/StableDebtToken/lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol:StableDebtToken storage-layout --pretty > reports/updated_v3AvaStableDebtToken_layout.md
	npm run clean-storage-report updated_v3AvaStableDebtToken_layout
	make git-diff before=reports/v3AvaStableDebtToken_layout.md after=reports/updated_v3AvaStableDebtToken_layout.md out=v3AvaStableDebtToken_layout_diff
