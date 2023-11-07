#!/usr/bin/env node

import child_process from 'child_process';
import dotenv from 'dotenv';
import {AaveV3Polygon, AaveV3Avalanche, AaveV3Optimism, AaveV3Arbitrum} from "@bgd-labs/aave-address-book";
dotenv.config();

function runCmd(cmd: string) {
  var resp = child_process.execSync(cmd);
  var result = resp.toString();
  return result;
}

function getImpl(network: string, address: string) {
  return runCmd(
    `cast implementation --rpc-url ${network.toLocaleLowerCase()} ${address}`
  ).replace('\n', '');
}

async function getV3StableDebtImpl() {
  const v3PolStableTokens = [];
  const v3AvaStableTokens = [];
  const v3OptStableTokens = [];
  const v3ArbStableTokens = [];

  for (const [key, value] of Object.entries(AaveV3Polygon.ASSETS)) {
    // @ts-ignore
    v3PolStableTokens.push(value.S_TOKEN);
  }
  for (const [key, value] of Object.entries(AaveV3Avalanche.ASSETS)) {
    // @ts-ignore
    v3AvaStableTokens.push(value.S_TOKEN);
  }
  for (const [key, value] of Object.entries(AaveV3Optimism.ASSETS)) {
    // @ts-ignore
    v3OptStableTokens.push(value.S_TOKEN);
  }
  for (const [key, value] of Object.entries(AaveV3Arbitrum.ASSETS)) {
    // @ts-ignore
    v3ArbStableTokens.push(value.S_TOKEN);
  }

  // we see that all the stable debt impl for aave v3 are same in one network

  console.log('Polygon stable debt impl addresses:');
  for (let i = 0; i < v3PolStableTokens.length; i++) {
    const addr = getImpl('polygon', v3PolStableTokens[i]);
    console.log('impl: ', addr, ' proxy:', v3PolStableTokens[i]);
  }

  console.log('Avalanche stable debt impl addresses:');
  for (let i = 0; i < v3AvaStableTokens.length; i++) {
    const addr = getImpl('avalanche', v3AvaStableTokens[i]);
    console.log('impl: ', addr, ' proxy:', v3AvaStableTokens[i]);
  }

  console.log('Optimism stable debt impl addresses:');
  for (let i = 0; i < v3OptStableTokens.length; i++) {
    const addr = getImpl('optimism', v3OptStableTokens[i]);
    console.log('impl: ', addr, ' proxy:', v3OptStableTokens[i]);
  }

  console.log('Arbitrum stable debt impl addresses:');
  for (let i = 0; i < v3ArbStableTokens.length; i++) {
    const addr = getImpl('arbitrum', v3ArbStableTokens[i]);
    console.log('impl: ', addr, ' proxy:', v3ArbStableTokens[i]);
  }

}

async function main() {
  getV3StableDebtImpl();
}

main();
