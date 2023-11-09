# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# deps
update:; forge update

# Build & test
build  :; forge build --sizes
test   :; forge test -vvv
test-contract :; forge test --match-contract ${filter} -vvv

# Utilities
download :; cast etherscan-source --chain ${chain} -d src/etherscan/${chain}_${address} ${address}

get-proxy-impl :;
  @cast implementation ${address} --rpc-url ${rpc}

git-diff :;
  @mkdir -p diffs
  @npx prettier ${before} ${after} --write
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
  cast etherscan-source --chain 250 -d etherscan/v3FanStableDebtToken 0x52a1ceb68ee6b7b5d13e0376a1e0e4423a8ce26e
  cast etherscan-source --chain 250 -d etherscan/v3HarStableDebtToken 0x52a1ceb68ee6b7b5d13e0376a1e0e4423a8ce26e

  cast etherscan-source --chain 1 -d etherscan/v2EthPoolConfigurator 0x3a95ee42f080ff7289c8b4a14eb483a8644d7521
  forge flatten etherscan/v2EthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol --output etherscan/flattened/v2EthPoolConfigurator/PoolConfigurator.sol

  cast etherscan-source --chain 137 -d etherscan/v2PolPoolConfigurator 0xf70a4d422e772926852ba9044026f169e6ad9492
  forge flatten etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol --output etherscan/flattened/v2PolPoolConfigurator/PoolConfigurator.sol

  cast etherscan-source --chain 43114 -d etherscan/v2AvaPoolConfigurator 0xc7938af7ec68c3d5ac3a396e28661b3e366b8fcf
  forge flatten etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol --output etherscan/flattened/v2AvaPoolConfigurator/PoolConfigurator.sol

  cast etherscan-source --chain 1 -d etherscan/v2AmmEthPoolConfigurator 0x5a8adc696009a2e0d142c46fdddd8c44be1604b4
  forge flatten etherscan/v2AmmEthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol --output etherscan/flattened/v2AmmEthPoolConfigurator/PoolConfigurator.sol

download-deployed-contracts :;
  cast etherscan-source --chain 1 -d etherscan/deployed/v2UsdtStableDebtToken 0xC61262D6ad449AC09B4087f46391Dd9A26b5888B
  cast etherscan-source --chain 1 -d etherscan/deployed/v2WbtcStableDebtToken 0x4f279f2046870F77cd9Ce63497f8A2D8689ef804
  cast etherscan-source --chain 1 -d etherscan/deployed/v2WethStableDebtToken 0xEd14b4E51B04d4d0211474a721F77C0817166c2f
  cast etherscan-source --chain 1 -d etherscan/deployed/v2ZrxStableDebtToken 0xffaCA447191d8196C8Cf96E5912b732063DE4307
  cast etherscan-source --chain 1 -d etherscan/deployed/v2BatStableDebtToken 0x49B6645a9aa05f1Be24893136100467276399470
  cast etherscan-source --chain 1 -d etherscan/deployed/v2EnjStableDebtToken 0x0fB427f800C5E39E7d8029e19F515300d4bb22C2
  cast etherscan-source --chain 1 -d etherscan/deployed/v2KnctStableDebtToken 0x22a8FD718924ab2f9dd4D0326DD8ab99Ef21D0b3
  cast etherscan-source --chain 1 -d etherscan/deployed/v2LinkStableDebtToken 0x1B80694AF3D4e617c747423f992F532B8baE098b
  cast etherscan-source --chain 1 -d etherscan/deployed/v2ManaStableDebtToken 0xe0bf71fF662e8bbeb911ACEa765f4b8be052F59b
  cast etherscan-source --chain 1 -d etherscan/deployed/v2MkrStableDebtToken 0xC4CFCE0b16199818Ad942a87902C9172ba005022
  cast etherscan-source --chain 1 -d etherscan/deployed/v2RenStableDebtToken 0x6F4B277366e10F68003A0a65Ef8f118f3D60B67E
  cast etherscan-source --chain 1 -d etherscan/deployed/v2UsdcStableDebtToken 0x8DFF7Fda82976452b6FB957F549944e7af7A3e6F
  cast etherscan-source --chain 1 -d etherscan/deployed/v2LusdStableDebtToken 0x1363602E58e25929A15bE194a3D505Fd6F8BE751

	cast etherscan-source --chain 137 -d etherscan/deployed/v3PolStableDebtToken 0xf4294973b7e6f6c411dd8a388592e7c7d32f2486
	cast etherscan-source --chain 42161 -d etherscan/deployed/v3ArbStableDebtToken 0xCB7113D3d572613BbFCeCf80d1341cFFE2A92C00
	cast etherscan-source --chain 43114 -d etherscan/deployed/v3AvaStableDebtToken 0xccf12894957E637Bd69693B12F3ba12b539C2D11
	cast etherscan-source --chain 10 -d etherscan/deployed/v3OptStableDebtToken 0x69713dA5fDfacf77E80C31F9B928Ec0Fc3716384

diff-deployed-contracts :;
  make git-diff before=etherscan/v2EthStableDebtAllTokens/0x9d4578c813d69745092a4f951753ed2b28056279 after=etherscan/deployed/v2UsdtStableDebtToken out=deployed/v2UsdtStableDebtToken
  make git-diff before=etherscan/v2EthStableDebtAllTokens/0x6ac108c4c3fe7f4d367513f599da1b9df7c43433 after=etherscan/deployed/v2WbtcStableDebtToken out=deployed/v2WbtcStableDebtToken
  make git-diff before=etherscan/v2EthStableDebtAllTokens/0xa558ea1a875f8b576f0728d32c39f62158e49b92 after=etherscan/deployed/v2WethStableDebtToken out=deployed/v2WethStableDebtToken
  make git-diff before=etherscan/v2EthStableDebtAllTokens/0x42a87bf47b5efd11fa9ddd5321bf9aa502233b74 after=etherscan/deployed/v2ZrxStableDebtToken out=deployed/v2ZrxStableDebtToken
  make git-diff before=etherscan/v2EthStableDebtAllTokens/0x917fd53da13edcce5c155a7dbc73e1e4dccd4267 after=etherscan/deployed/v2BatStableDebtToken out=deployed/v2BatStableDebtToken
  make git-diff before=etherscan/v2EthStableDebtAllTokens/0x8286288f3c454b51dfc70bd0d6918220428b0741 after=etherscan/deployed/v2EnjStableDebtToken out=deployed/v2EnjStableDebtToken
  make git-diff before=etherscan/v2EthStableDebtAllTokens/0xf818b175353f023e3ec1a098d040778b835897c7 after=etherscan/deployed/v2KncStableDebtToken out=deployed/v2KncStableDebtToken
  make git-diff before=etherscan/v2EthStableDebtAllTokens/0xadc313f17a3e2180f609a45d7b381a45e2e88a9f after=etherscan/deployed/v2LinkStableDebtToken out=deployed/v2LinkStableDebtToken
  make git-diff before=etherscan/v2EthStableDebtAllTokens/0x441c5cd55e9e3267d02f7b1b4d245aa1c61891c3 after=etherscan/deployed/v2ManaStableDebtToken out=deployed/v2ManaStableDebtToken
  make git-diff before=etherscan/v2EthStableDebtAllTokens/0x20f9027c5092739c58250cf456642e8e3d4dbed5 after=etherscan/deployed/v2MkrStableDebtToken out=deployed/v2MkrStableDebtToken
  make git-diff before=etherscan/v2EthStableDebtAllTokens/0x7b3e7aea49a5f5d2514b9317d4cf58f828ac28c2 after=etherscan/deployed/v2RenStableDebtToken out=deployed/v2RenStableDebtToken
  make git-diff before=etherscan/v2EthStableDebtAllTokens/0x3b2a77058a1eb4403a90b94585fab16bc512e703 after=etherscan/deployed/v2UsdcStableDebtToken out=deployed/v2UsdcStableDebtToken
  make git-diff before=etherscan/v2EthStableDebtAllTokens/0x595c33538215dc4b092f35afc85d904631263f4f after=etherscan/deployed/v2LusdStableDebtToken out=deployed/v2LusdStableDebtToken

	make git-diff before=etherscan/v3PolStableDebtToken after=etherscan/deployed/v3PolStableDebtToken out=deployed/v3PolStableDebtToken
	make git-diff before=etherscan/v3ArbStableDebtToken after=etherscan/deployed/v3ArbStableDebtToken out=deployed/v3ArbStableDebtToken
	make git-diff before=etherscan/v3AvaStableDebtToken after=etherscan/deployed/v3AvaStableDebtToken out=deployed/v3AvaStableDebtToken
	make git-diff before=etherscan/v3OptStableDebtToken after=etherscan/deployed/v3OptStableDebtToken out=deployed/v3OptStableDebtToken

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

  make git-diff before=etherscan/flattened/v2EthPoolConfigurator after=etherscan/flattened/v2PolPoolConfigurator out=v2EthPolPoolConfigurator
  make git-diff before=etherscan/flattened/v2PolPoolConfigurator after=etherscan/flattened/v2AvaPoolConfigurator out=v2PolAvaPoolConfigurator
  make git-diff before=etherscan/flattened/v2EthPoolConfigurator after=etherscan/flattened/v2AvaPoolConfigurator out=v2EthAvaPoolConfigurator
  make git-diff before=etherscan/flattened/v2AmmEthPoolConfigurator after=etherscan/flattened/v2EthPoolConfigurator out=v2EthAmmEthPoolConfigurator

  make git-diff before=etherscan/v2EthPoolConfigurator after=src/v2EthPoolConfigurator out=v2EthPoolConfigurator
  make git-diff before=etherscan/v2PolPoolConfigurator after=src/v2PolPoolConfigurator out=v2PolPoolConfigurator
  make git-diff before=etherscan/v2AvaPoolConfigurator after=src/v2AvaPoolConfigurator out=v2AvaPoolConfigurator
  make git-diff before=etherscan/v2AmmEthPoolConfigurator after=src/v2AmmEthPoolConfigurator out=v2AmmEthPoolConfigurator

  make git-diff before=etherscan/v3PolStableDebtToken after=etherscan/v3ArbStableDebtToken out=v3PolArbStableDebtToken
  make git-diff before=etherscan/v3PolStableDebtToken after=etherscan/v3OptStableDebtToken out=v3PolOptStableDebtToken
  make git-diff before=etherscan/v3PolStableDebtToken after=etherscan/v3AvaStableDebtToken out=v3PolAvaStableDebtToken
  make git-diff before=etherscan/v3FanHarStableDebtToken after=etherscan/v3PolStableDebtToken out=v3FanPolStableDebtToken

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

  forge inspect etherscan/v3FanStableDebtToken/StableDebtToken/@aave/core-v3/contracts/protocol/tokenization/StableDebtToken.sol:StableDebtToken storage-layout --pretty > reports/v3FanStableDebtToken_layout.md
  npm run clean-storage-report v3FanStableDebtToken_layout
  forge inspect src/v3FanHarStableDebtToken/StableDebtToken/@aave/core-v3/contracts/protocol/tokenization/StableDebtToken.sol:StableDebtToken storage-layout --pretty > reports/updated_v3FanHarStableDebtToken_layout.md
  npm run clean-storage-report updated_v3FanHarStableDebtToken_layout
  make git-diff before=reports/v3FanStableDebtToken_layout.md after=reports/updated_v3FanHarStableDebtToken_layout.md out=v3FanHarStableDebtToken_layout_diff

  # Lending Pool Configurator

  forge inspect etherscan/v2EthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol:LendingPoolConfigurator storage-layout --pretty > reports/v2EthPoolConfigurator_layout.md
  npm run clean-storage-report v2EthPoolConfigurator_layout
  forge inspect src/v2EthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol:LendingPoolConfigurator storage-layout --pretty > reports/updated_v2EthPoolConfigurator_layout.md
  npm run clean-storage-report updated_v2EthPoolConfigurator_layout
  make git-diff before=reports/v2EthPoolConfigurator_layout.md after=reports/updated_v2EthPoolConfigurator_layout.md out=v2EthPoolConfigurator_layout_diff

  forge inspect etherscan/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol:LendingPoolConfigurator storage-layout --pretty > reports/v2PolPoolConfigurator_layout.md
  npm run clean-storage-report v2PolPoolConfigurator_layout
  forge inspect src/v2PolPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol:LendingPoolConfigurator storage-layout --pretty > reports/updated_v2PolPoolConfigurator_layout.md
  npm run clean-storage-report updated_v2PolPoolConfigurator_layout
  make git-diff before=reports/v2PolPoolConfigurator_layout.md after=reports/updated_v2PolPoolConfigurator_layout.md out=v2PolPoolConfigurator_layout_diff

  forge inspect etherscan/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol:LendingPoolConfigurator storage-layout --pretty > reports/v2AvaPoolConfigurator_layout.md
  npm run clean-storage-report v2AvaPoolConfigurator_layout
  forge inspect src/v2AvaPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol:LendingPoolConfigurator storage-layout --pretty > reports/updated_v2AvaPoolConfigurator_layout.md
  npm run clean-storage-report updated_v2AvaPoolConfigurator_layout
  make git-diff before=reports/v2AvaPoolConfigurator_layout.md after=reports/updated_v2AvaPoolConfigurator_layout.md out=v2AvaPoolConfigurator_layout_diff

  forge inspect etherscan/v2AmmEthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol:LendingPoolConfigurator storage-layout --pretty > reports/v2AmmEthPoolConfigurator_layout.md
  npm run clean-storage-report v2AmmEthPoolConfigurator_layout
  forge inspect src/v2AmmEthPoolConfigurator/LendingPoolConfigurator/contracts/protocol/lendingpool/LendingPoolConfigurator.sol:LendingPoolConfigurator storage-layout --pretty > reports/updated_v2AmmEthPoolConfigurator_layout.md
  npm run clean-storage-report updated_v2AmmEthPoolConfigurator_layout
  make git-diff before=reports/v2AmmEthPoolConfigurator_layout.md after=reports/updated_v2AmmEthPoolConfigurator_layout.md out=v2AmmEthPoolConfigurator_layout_diff

# common
common-flags := --legacy --ledger --mnemonic-indexes $(MNEMONIC_INDEX) --sender $(LEDGER_SENDER) --verify -vvv --broadcast --slow

deploy-v2-mainnet :; forge script scripts/DeploySTokenV2Eth.s.sol:DeploySTokensV2Ethereum --fork-url mainnet $(common-flags)
deploy-v3-fantom :; forge script scripts/DeploySTokenV3Ftm.s.sol:DeploySTokensV3Ftm --fork-url fantom $(common-flags)
deploy-v3-harmony :; forge script scripts/DeploySTokenV3Har.s.sol:DeploySTokensV3Har --fork-url harmony $(common-flags)


deploy-v3-fantom-payload :; forge script scripts/DeploySTokenV3Ftm.s.sol:DeployPayloadV3Ftm --fork-url fantom $(common-flags)
deploy-v3-harmony-payload :; forge script scripts/DeploySTokenV3Har.s.sol:DeployPayloadV3Har --fork-url harmony $(common-flags)

deploy-v2-arbitrum :; forge script scripts/deploy_scripts.s.sol:DeployArb --fork-url arbitrum $(common-flags)
deploy-v2-polygon :; forge script scripts/deploy_scripts.s.sol:DeployPol --fork-url polygon $(common-flags)
deploy-v2-optimism :; forge script scripts/deploy_scripts.s.sol:DeployOpt --fork-url optimism $(common-flags)

deploy-configurator-mainnet :; forge script ./scripts/DeployPoolConfigurator.s.sol:DeployMainnet --rpc-url mainnet $(common-flags)
deploy-configurator-polygon :; forge script ./scripts/DeployPoolConfigurator.s.sol:DeployPolygon --rpc-url polygon $(common-flags)
deploy-configurator-avalanche :; forge script ./scripts/DeployPoolConfigurator.s.sol:DeployAvalanche --rpc-url avalanche $(common-flags)

deploy-sentinel-pol :; forge script scripts/DeployLiquidationSentinel.s.sol:DeployLiquidationSentinelPol --fork-url polygon $(common-flags)
deploy-sentinel-ava :; forge script scripts/DeployLiquidationSentinel.s.sol:DeployLiquidationSentinelAva --fork-url avalanche $(common-flags)
