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
	cast etherscan-source --chain 1 -d etherscan/v2EthPool 0x085E34722e04567Df9E6d2c32e82fd74f3342e79
	cast etherscan-source --chain 137 -d etherscan/v2PolPool 0x1685d81212580dd4cda287616c2f6f4794927e18
	cast etherscan-source --chain 43114 -d etherscan/v2AvaPool 0x102bf2c03c1901adba191457a8c4a4ef18b40029
