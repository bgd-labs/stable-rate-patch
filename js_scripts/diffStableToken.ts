#!/usr/bin/env node

import child_process from 'child_process';
import dotenv from 'dotenv';
import fs from 'fs';
import {AaveV2Ethereum} from "@bgd-labs/aave-address-book";
dotenv.config();

function runCmd(cmd: string) {
  var resp = child_process.execSync(cmd);
  var result = resp.toString();
  return result;
}

const API_KEYS = {
  mainnet: process.env.ETHERSCAN_API_KEY_MAINNET || '',
  polygon: process.env.ETHERSCAN_API_KEY_POLYGON || '',
  optimism: process.env.ETHERSCAN_API_KEY_OPTIMISM || '',
};

function download(network: string, address: string, poolVersion: string) {
  if (
    network == 'mainnet' && !fs.existsSync(`etherscan/v2EthStableDebtAllTokens/${address}`)
  ) {
    console.log('downloading', address);

    let downloadPath = '';
    if (network == 'mainnet' && poolVersion == 'v2') {
      downloadPath = `etherscan/v2EthStableDebtAllTokens/${address}`
    }

    // @ts-ignore
    runCmd(`cast etherscan-source --chain-id ${network} -d ${downloadPath} ${address} --etherscan-api-key ${API_KEYS[network]}`);
  }
}

function downloadReference(address: string) {
  runCmd(`cast etherscan-source --chain-id mainnet -d etherscan/v2EthStableDebtToken ${address} --etherscan-api-key ${API_KEYS.mainnet}`);
}

function flatten(address: string, network: string, poolVersion: string) {
  console.log('flattening contract', address);
  let sourcePath = '';
  let outPath = '';

  if (address == '0xf37e202e587c6f63fd70f35c24eb7f818cc5d01a') { // v2 Rai stable debt token impl
    sourcePath = `etherscan/v2EthStableDebtAllTokens/${address}/StableDebtToken/StableDebtToken.sol`;
  } else if (address == '0x0e8f4fc4c261d454b13c74507bce8c38aa990361') { // v2 AMPL stable debt token impl
    sourcePath = `etherscan/v2EthStableDebtAllTokens/${address}/AmplStableDebtToken/contracts/protocol/tokenization/ampl/AmplStableDebtToken.sol`;
  } else if (address == '0x8180949ac41ef18e844ff8dafe604a195d86aea9') { // v2 stETH stable debt token impl
    sourcePath = `etherscan/v2EthStableDebtAllTokens/${address}/StableDebtStETH/contracts/protocol/tokenization/StableDebtToken.sol`;
  } else if (address == '0x9c2114bf70774c36e9b8d6c790c9c14ff0d6799e') { // v2 oneInch stable debt token impl
    sourcePath = `etherscan/v2EthStableDebtAllTokens/${address}/StableDebtToken/src/stableDebt.sol`;
  } else if (address == '0xD23A44eB2db8AD0817c994D3533528C030279F7c') { // default impl
    sourcePath = `etherscan/v2EthStableDebtToken/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol`;
  } else if (network == 'mainnet' && poolVersion == 'v2') {
    sourcePath = `etherscan/v2EthStableDebtAllTokens/${address}/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol`;
  } else if (network == 'polygon' && poolVersion == 'v2') {
    sourcePath = `etherscan/v2PolStableDebtToken/${address}/StableDebtToken/contracts/protocol/tokenization/StableDebtToken.sol`;
  }

  if (network == 'mainnet' && poolVersion == 'v2') {
    outPath = `etherscan/v2EthStableDebtAllTokens/flattened/${address}.sol`;
  } else if (network == 'polygon' && poolVersion == 'v2') {
    outPath = `etherscan/v2PolStableDebtAllTokens/flattened/${address}.sol`;
  }

  runCmd(`forge flatten ${sourcePath} --output ${outPath}`);
}

function getDiffsAgainstReference(fromContract: string, network: string, poolVersion: string) {
  const implAddress = getImpl(network, fromContract);
  download(network, implAddress, poolVersion);

  flatten(implAddress, network, poolVersion);

  let before = '';
  let after = '';
  let out = '';

  if (network == 'mainnet') {
    before = 'etherscan/v2EthStableDebtAllTokens/flattened/0xD23A44eB2db8AD0817c994D3533528C030279F7c.sol'; // default impl
    after = `etherscan/v2EthStableDebtAllTokens/flattened/${implAddress}.sol`;
    out = `v2EthStableDebtAll/${implAddress}`;
  } else if (network == 'polygon') {
    before = 'etherscan/v2PolStableDebtAllTokens/flattened/0x72a053fa208eaafa53adb1a1ea6b4b2175b5735e.sol'; // default impl
    after = `etherscan/v2PolStableDebtAllTokens/flattened/${implAddress}.sol`;
    out = `v2PolStableDebtAll/${implAddress}`;
  }

  runCmd(`make git-diff before=${before} after=${after} out=${out}`);
}

function getImpl(network: string, address: string) {
  return runCmd(
    `cast implementation --rpc-url ${network.toLocaleLowerCase()} ${address}`
  ).replace('\n', '');
}

async function diffV2EthStableImpl() {
  const v2EthStableTokens = [];

  for (const [key, value] of Object.entries(AaveV2Ethereum.ASSETS)) {
    // @ts-ignore
    v2EthStableTokens.push(value.S_TOKEN);
  }

  const defaultV2EthReferenceImpl = '0xD23A44eB2db8AD0817c994D3533528C030279F7c';

  downloadReference(defaultV2EthReferenceImpl);
  flatten(defaultV2EthReferenceImpl, 'mainnet', 'v2');

  for (let i = 0; i < v2EthStableTokens.length; i++) {
    if (v2EthStableTokens[i] == defaultV2EthReferenceImpl) continue;
    getDiffsAgainstReference(v2EthStableTokens[i], 'mainnet', 'v2');
  }
}

async function main() {
  diffV2EthStableImpl();
}

main();
