# Stable Rate Patch

## Summary

Repository containing different developments concerning the Aave incident described [HERE](https://governance.aave.com/t/aave-v2-v3-security-incident-04-11-2023/15335/26).
- Stable Debt Token upgraded implementations, stopping minting.
- Liquidations Grace Sentinel.

## Diffs

All the diffs between the etherscan downloaded and modified contracts can be found [HERE](./diffs). These include both the source code diffs and the storage layout diffs. The storage layout diff files end with `layout_diffs`.

All the files downloaded from etherscan are stored [HERE](./etherscan)

Various diffs have also been created among all the different aave v2 stable debt tokens on ethereum against a reference, which can be found over [HERE](./diffs/v2EthStableDebtAll). The reference is [stable debt token of DAI](https://etherscan.io/address/0xD23A44eB2db8AD0817c994D3533528C030279F7c). Looking at the diffs we can conclude that there is no major difference in different stable debt impl for various tokens on aave v2 ethereum, except for `AMPL` token which is not being upgraded.

The diffs among different aave v3 stable debt tokens have also been added over here: [v3PolArbStableDebtToken](diffs/v3PolArbStableDebtToken.md), [v3PolAvaStableDebtToken](diffs/v3PolAvaStableDebtToken.md), [v3PolOptStableDebtToken](diffs/v3PolOptStableDebtToken.md). We can conclude that there is no diffs between different v3 stable debt tokens across networks.

The diffs among different aave v2 pool configurators can be found here: [v2EthPolPoolConfigurator](diffs/v2EthPolPoolConfigurator.md), [v2PolAvaPoolConfigurator](diffs/v2PolAvaPoolConfigurator.md), [v2EthAvaPoolConfigurator](diffs/v2EthAvaPoolConfigurator.md)

### Scripts for diffs:

- To generate all the source code diffs run: `make diff-contracts`.

- To generate all the storage layout code diffs run: `make storage-diff`.

- To download the source code from etherscan run: `download-all-etherscan`. This should be run once, when initializing the project.

- To validate different impl addresses of aave v3 stable debt tokens run: `npm run get-v3-stable-debt-impl`.

- To diff between the new deployed contracts and the previous one, run: `make download-deployed-contracts` to download the deployed contracts and `make diff-deployed-contracts` to diff them.

- The diffs between different aave v2 stable debt tokens on ethereum can be generated by running this command: `npm run generate-v2-eth-stable-debt-diff`.

You can find the diffs between the new deployed contracts of aave v2 stable debt impl tokens and the previous deployed contract:

| Token | PrevStableDebtImpl | NewStableDebtImpl | Diff |
| --- | --- | --- | --- |
| USDT | 0x9d4578c813d69745092a4f951753ed2b28056279 | 0xC61262D6ad449AC09B4087f46391Dd9A26b5888B | [HERE](diffs/deployed/v2UsdtStableDebtToken.md) |
| WBTC | 0x6ac108c4c3fe7f4d367513f599da1b9df7c43433 | 0x4f279f2046870F77cd9Ce63497f8A2D8689ef804 | [HERE](diffs/deployed/v2WbtcStableDebtToken.md) |
| WETH | 0xa558ea1a875f8b576f0728d32c39f62158e49b92 | 0xEd14b4E51B04d4d0211474a721F77C0817166c2f | [HERE](diffs/deployed/v2WethStableDebtToken.md) |
| ZRX | 0x42a87bf47b5efd11fa9ddd5321bf9aa502233b74 | 0xffaCA447191d8196C8Cf96E5912b732063DE4307 | [HERE](diffs/deployed/v2ZrxStableDebtToken.md) |
| BAT | 0x917fd53da13edcce5c155a7dbc73e1e4dccd4267 | 0x49B6645a9aa05f1Be24893136100467276399470 | [HERE](diffs/deployed/v2BatStableDebtToken.md) |
| ENJ | 0x8286288f3c454b51dfc70bd0d6918220428b0741 | 0x0fB427f800C5E39E7d8029e19F515300d4bb22C2 | [HERE](diffs/deployed/v2EnjStableDebtToken.md) |
| KNC | 0xf818b175353f023e3ec1a098d040778b835897c7 | 0x22a8FD718924ab2f9dd4D0326DD8ab99Ef21D0b3 | [HERE](diffs/deployed/v2KncStableDebtToken.md) |
| LINK | 0xadc313f17a3e2180f609a45d7b381a45e2e88a9f | 0x1B80694AF3D4e617c747423f992F532B8baE098b | [HERE](diffs/deployed/v2LinkStableDebtToken.md) |
| MANA | 0x441c5cd55e9e3267d02f7b1b4d245aa1c61891c3 | 0xe0bf71fF662e8bbeb911ACEa765f4b8be052F59b | [HERE](diffs/deployed/v2ManaStableDebtToken.md) |
| MKR | 0x20f9027c5092739c58250cf456642e8e3d4dbed5 | 0xC4CFCE0b16199818Ad942a87902C9172ba005022 | [HERE](diffs/deployed/v2MkrStableDebtToken.md) |
| REN | 0x7b3e7aea49a5f5d2514b9317d4cf58f828ac28c2 | 0x6F4B277366e10F68003A0a65Ef8f118f3D60B67E | [HERE](diffs/deployed/v2RenStableDebtToken.md) |
| USDC | 0x3b2a77058a1eb4403a90b94585fab16bc512e703 | 0x8DFF7Fda82976452b6FB957F549944e7af7A3e6F | [HERE](diffs/deployed/v2UsdcStableDebtToken.md) |
| LUSD | 0x595c33538215dc4b092f35afc85d904631263f4f | 0x1363602E58e25929A15bE194a3D505Fd6F8BE751 | [HERE](diffs/deployed/v2LusdStableDebtToken.md) |
