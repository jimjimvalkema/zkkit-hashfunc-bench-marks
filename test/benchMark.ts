// We don't have Ethereum specific assertions in Hardhat 3 yet
import assert from "node:assert/strict";
import { describe, it } from "node:test";

import { network } from "hardhat";
import {bytesToBigInt, TransactionReceipt} from "viem"
const FIELD_LIMIT = 21888242871839275222246405745257275088548364400416034343698204186575808495617n
/*
 * `node:test` uses `describe` and `it` to define tests, similar to Mocha.
 * `describe` blocks support async functions, simplifying the setup of tests.
 */
describe("Keccak", async function () {
  /*
   * In Hardhat 3, there isn't a single global connection to a network. Instead,
   * you have a `network` object that allows you to connect to different
   * networks.
   *
   * You can create multiple network connections using `network.connect`.
   * It takes two optional parameters and returns a `NetworkConnection` object.
   *
   * Its parameters are:
   *
   * 1. The name of the network configuration to use (from `config.networks`).
   *
   * 2. The `ChainType` to use.
   *
   * Providing a `ChainType` ensures the connection is aware of the kind of
   * chain it's using, potentially affecting RPC interactions for HTTP
   * connections, and changing the simulation behavior for EDR networks.
   * It also ensures the network connection has the correct TypeScript type and
   * viem extensions (e.g. Optimisim L2 actions).
   *
   * If you don't provide a `ChainType`, it will be inferred from the network
   * config, and default to `generic` if not specified in the config. In either
   * case, the connection will have a generic TypeScript type and no viem
   * extensions.
   *
   * Every time you call `network.connect` with an EDR network config name, a
   * new instance of EDR will be created. Each of these instances has its own
   * state and blockchain, and they have no communication with each other.
   *
   * Examples:
   *
   * - `await network.connect({network: "sepolia", chainType: "l1"})`: Connects
   *   to the `sepolia` network config, treating it as an "l1" network with the
   *   appropriate viem extensions.
   *
   * - `await network.connect({network: "hardhatOp", chainType: "optimism"})`:
   *   Creates a new EDR instance in Optimism mode, using the `hardhatOp`
   *   network config.
   *
   * - `await network.connect()`: Creates a new EDR instance with the default
   *    network config (i.e. `hardhat`), the `generic` chain type, and no
   *    viem extensions.
   *
   * Each network connection object has a `provider` property and other
   * network-related fields added by plugins, like `viem` and `networkHelpers`.
   */

  //@ts-ignore hardhat 3 still early :P
  const { viem, ethers  } = await network.connect();
  const publicClient = await viem.getPublicClient();


  it("keccak", async function () {
    const BinaryIMTKeccak = await viem.deployContract("BinaryIMTKeccak");
    const keccakTree = await viem.deployContract("testKeccak",[32n], {libraries:{BinaryIMTKeccak:BinaryIMTKeccak.address}})
    
    const iters = 100
    const getRandomBigInt = () =>bytesToBigInt(crypto.getRandomValues(new Uint8Array(new Array(32).fill(0))))
    const randomBigInts = new Array(iters).fill(await keccakTree.write.insert([getRandomBigInt()]))
    const receipts = await Promise.all(randomBigInts.map(async (hash)=>await (await viem.getPublicClient()).waitForTransactionReceipt({hash})))
    const totalGas = receipts.reduce((a:bigint, b:TransactionReceipt) => a + b.gasUsed, 0n);
    const averageGasInsert = Number(totalGas) / iters
    console.log({averageGasInsert, totalGas})
  });

  it("poseidon", async function () {
    const PoseidonT3Lib = await viem.deployContract("PoseidonT3", [], { value: 0n, libraries: {} })
    const BinaryIMTPoseidon = await viem.deployContract("BinaryIMTPoseidon", [], { value: 0n, libraries: { PoseidonT3: PoseidonT3Lib.address } });
    const keccakTree = await viem.deployContract("testPoseidon",[32n], {libraries:{BinaryIMTPoseidon:BinaryIMTPoseidon.address}})
    
    const iters = 100
    const getRandomBigInt = () => bytesToBigInt(crypto.getRandomValues(new Uint8Array(new Array(32).fill(0)))) % FIELD_LIMIT
    const randomBigInts = new Array(iters).fill(await keccakTree.write.insert([getRandomBigInt()]))
    const receipts = await Promise.all(randomBigInts.map(async (hash)=>await (await viem.getPublicClient()).waitForTransactionReceipt({hash})))
    const totalGas = receipts.reduce((a:bigint, b:TransactionReceipt) => a + b.gasUsed, 0n);
    const averageGasInsert = Number(totalGas) / iters
    console.log({averageGasInsert, totalGas})
  });


  it("old zk-kit poseidon", async function () {
    const PoseidonT3Lib = await viem.deployContract("PoseidonT3", [], { value: 0n, libraries: {} })
    const BinaryOldZKKITIMTPoseidon = await viem.deployContract("BinaryOldZKKITIMTPoseidon", [], { value: 0n, libraries: { PoseidonT3: PoseidonT3Lib.address } });
    const keccakTree = await viem.deployContract("testOldZKKITPoseidon",[32n], {libraries:{BinaryOldZKKITIMTPoseidon:BinaryOldZKKITIMTPoseidon.address}})
    
    const iters = 100
    const getRandomBigInt = () => bytesToBigInt(crypto.getRandomValues(new Uint8Array(new Array(32).fill(0)))) % FIELD_LIMIT
    const randomBigInts = new Array(iters).fill(await keccakTree.write.insert([getRandomBigInt()]))
    const receipts = await Promise.all(randomBigInts.map(async (hash)=>await (await viem.getPublicClient()).waitForTransactionReceipt({hash})))
    const totalGas = receipts.reduce((a:bigint, b:TransactionReceipt) => a + b.gasUsed, 0n);
    const averageGasInsert = Number(totalGas) / iters
    console.log({averageGasInsert, totalGas})
  });

  it("SHA256", async function () {
    const BinaryIMTSHA256 = await viem.deployContract("BinaryIMTSHA256");
    const keccakTree = await viem.deployContract("testSHA256",[32n], {libraries:{BinaryIMTSHA256:BinaryIMTSHA256.address}})
    
    const iters = 100
    const getRandomBigInt = () =>bytesToBigInt(crypto.getRandomValues(new Uint8Array(new Array(32).fill(0))))
    const randomBigInts = new Array(iters).fill(await keccakTree.write.insert([getRandomBigInt()]))
    const receipts = await Promise.all(randomBigInts.map(async (hash)=>await (await viem.getPublicClient()).waitForTransactionReceipt({hash})))
    const totalGas = receipts.reduce((a:bigint, b:TransactionReceipt) => a + b.gasUsed, 0n);
    const averageGasInsert = Number(totalGas) / iters
    console.log({averageGasInsert, totalGas})
  });

})
