// We don't have Ethereum specific assertions in Hardhat 3 yet
import assert from "node:assert/strict";
import { describe, it } from "node:test";

import { network } from "hardhat";
import { bytesToBigInt, TransactionReceipt, toHex, keccak256, sha256, hexToBigInt, concat, padHex,toBytes, Hex } from "viem"
import { UltraHonkBackend } from '@aztec/bb.js';
import { Noir, CompiledCircuit, InputMap } from '@noir-lang/noir_js';
import keccakCircuit from "../circuits/keccak/target/keccak.json" //assert { type: 'json' };
import sha256Circuit from "../circuits/sha256/target/sha256.json"
import poseidonCircuit from "../circuits/poseidon/target/poseidon.json"
import { IMT, IMTNode } from "@zk-kit/imt"
import { poseidon2 } from "poseidon-lite"
import os from "node:os"
import { MerkleTree, PartialMerkleTree } from 'fixed-merkle-tree'

const FIELD_LIMIT = 21888242871839275222246405745257275088548364400416034343698204186575808495617n
const getRandomBigInt = () => bytesToBigInt(crypto.getRandomValues(new Uint8Array(new Array(32).fill(0))))
const pad = (hexArr: string[], len=32) => {
  return hexArr.length === len ? hexArr : [...new Array(len - hexArr.length).fill("0x00"), ...hexArr]
}
const smallPad = (s: string) => s.length === 2 ? s : "0" + s
//@ts-ignore
const splitHexToU8s = (hex: string,padLen=32) => pad(hex.replace(/^0x/, '').match(/.{1,2}/g).map((n) => "0x" + n),padLen);

describe("insert", async function () {
  const { viem } = await network.connect();

  // it("keccak", async function () {
  //   const BinaryIMTKeccak = await viem.deployContract("BinaryIMTKeccak");
  //   const keccakTree = await viem.deployContract("testKeccak", [32n], { libraries: { BinaryIMTKeccak: BinaryIMTKeccak.address } })

  //   const iters = 100

  //   const insertTxs = new Array(iters).fill(await keccakTree.write.insert([getRandomBigInt()]))
  //   const receipts = await Promise.all(insertTxs.map(async (hash) => await (await viem.getPublicClient()).waitForTransactionReceipt({ hash })))
  //   const totalGas = receipts.reduce((a: bigint, b: TransactionReceipt) => a + b.gasUsed, 0n);
  //   const averageGasInsert = Number(totalGas) / iters
  //   console.log({ averageGasInsert, totalGas })
  // });

  // it("poseidon", async function () {
  //   const PoseidonT3Lib = await viem.deployContract("PoseidonT3", [], { value: 0n, libraries: {} })
  //   const BinaryIMTPoseidon = await viem.deployContract("BinaryIMTPoseidon", [], { value: 0n, libraries: { PoseidonT3: PoseidonT3Lib.address } });
  //   const poseidonTree = await viem.deployContract("testPoseidon", [32n], { libraries: { BinaryIMTPoseidon: BinaryIMTPoseidon.address } })

  //   const iters = 100

  //   const insertTxs = new Array(iters).fill(await poseidonTree.write.insert([getRandomBigInt() % FIELD_LIMIT]))
  //   const receipts = await Promise.all(insertTxs.map(async (hash) => await (await viem.getPublicClient()).waitForTransactionReceipt({ hash })))
  //   const totalGas = receipts.reduce((a: bigint, b: TransactionReceipt) => a + b.gasUsed, 0n);
  //   const averageGasInsert = Number(totalGas) / iters
  //   console.log({ averageGasInsert, totalGas })
  // });


  // it("old zk-kit poseidon", async function () {
  //   const PoseidonT3Lib = await viem.deployContract("PoseidonT3", [], { value: 0n, libraries: {} })
  //   const BinaryOldZKKITIMTPoseidon = await viem.deployContract("BinaryOldZKKITIMTPoseidon", [], { value: 0n, libraries: { PoseidonT3: PoseidonT3Lib.address } });
  //   const ogPoseidonTree = await viem.deployContract("testOldZKKITPoseidon", [32n], { libraries: { BinaryOldZKKITIMTPoseidon: BinaryOldZKKITIMTPoseidon.address } })

  //   const iters = 100
  //   const insertTxs = new Array(iters).fill(await ogPoseidonTree.write.insert([getRandomBigInt() % FIELD_LIMIT]))
  //   const receipts = await Promise.all(insertTxs.map(async (hash) => await (await viem.getPublicClient()).waitForTransactionReceipt({ hash })))
  //   const totalGas = receipts.reduce((a: bigint, b: TransactionReceipt) => a + b.gasUsed, 0n);
  //   const averageGasInsert = Number(totalGas) / iters
  //   console.log({ averageGasInsert, totalGas })
  // });

  // it("SHA256", async function () {
  //   const BinaryIMTSHA256 = await viem.deployContract("BinaryIMTSHA256");
  //   const SHA256Tree = await viem.deployContract("testSHA256", [32n], { libraries: { BinaryIMTSHA256: BinaryIMTSHA256.address } })

  //   const iters = 100

  //   const insertTxs = new Array(iters).fill(await SHA256Tree.write.insert([getRandomBigInt()]))
  //   const receipts = await Promise.all(insertTxs.map(async (hash) => await (await viem.getPublicClient()).waitForTransactionReceipt({ hash })))
  //   const totalGas = receipts.reduce((a: bigint, b: TransactionReceipt) => a + b.gasUsed, 0n);
  //   const averageGasInsert = Number(totalGas) / iters
  //   console.log({ averageGasInsert, totalGas })
  // });
});


describe("prove 16 depth", async function () {
  const { viem } = await network.connect();
  const publicClient = await viem.getPublicClient();
  const treeDepth = 16n


  it("keccak", async function () {
    const BinaryIMTKeccak = await viem.deployContract("BinaryIMTKeccak");
    const keccakTree = await viem.deployContract("testKeccak", [treeDepth], { libraries: { BinaryIMTKeccak: BinaryIMTKeccak.address } })

    const leaf = 12345n//getRandomBigInt()
    const insertTx = await keccakTree.write.insert([leaf])
    const receipt = await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: insertTx })

    // TORNADOCASH tree
    const hashFunction = (left:Hex, right:Hex) => keccak256(concat([padHex(left,{size:32}), padHex(right,{size:32})]))
    //@ts-ignore
    const tornadoTree = new MerkleTree(Number(treeDepth), [toHex(leaf,{size:32})], { hashFunction, zeroElement: "0x00" })
    const tornadoProof = tornadoTree.proof(toHex(leaf,{size:32}))

    const hashFunctionButBigInt = (input: IMTNode[]) => hexToBigInt(hashFunction(toHex(input[0],{size:32}),toHex(input[1],{size:32})))
    const jsTree = new IMT(hashFunctionButBigInt, Number(treeDepth), 0, 2,[leaf])
    const leafIndex = jsTree.indexOf(leaf)
    const merkleProof = jsTree.createProof(leafIndex)



    console.time('prove keccak')
    const threads = os.cpus().length
    console.log({threads})
    const noir = new Noir(keccakCircuit as CompiledCircuit);
    const backend = new UltraHonkBackend(keccakCircuit.bytecode);
    // const proofInputs: InputMap = {
    //   root: splitHexToU8s(tornadoTree.root,32),//splitHexToU8s(toHex(jsTree.root,{size:32})),
    //   leaf: splitHexToU8s(toHex(leaf,{size:32})),
    //   index: toHex(tornadoTree.indexOf(toHex(leaf,{size:32})),{size:32}),//toHex(jsTree.indexOf(leaf),{size:32}),
    //   hash_path: tornadoProof.pathElements.map((a) => splitHexToU8s(a))//merkleProof.siblings.map((a) => splitHexToU8s(toHex(a[0],{size:1})))
    // }
    const proofInputs: InputMap = {
      root: splitHexToU8s(toHex(jsTree.root,{size:32})),
      leaf: splitHexToU8s(toHex(leaf,{size:32})),
      index: toHex(jsTree.indexOf(leaf),{size:32}),
      hash_path: merkleProof.siblings.map((a) => splitHexToU8s(toHex(a[0],{size:32})))
    }
    try {
      const { witness, returnValue } = await noir.execute(proofInputs);
      const proof = await backend.generateProof(witness);

    } catch (error) {
      //@ts-ignore

      console.error(error)
                const test = `
      let root:[u8; 32] = [${proofInputs.root.toString()}];
      let leaf: [u8; 32] = [${proofInputs.leaf.toString()}];
      let index:Field = ${proofInputs.index.toString()};
      let hash_path: [[u8; 32]; 32] = [${proofInputs.hash_path.map((p)=>`[${p.toString()}]`).toString()}];
      main(root, leaf, index, hash_path);
      `
      console.log(test)
      throw error;


    }

    console.timeEnd('prove keccak')
  });

  // it("poseidon", async function () {
  //   const PoseidonT3Lib = await viem.deployContract("PoseidonT3", [], { value: 0n, libraries: {} })
  //   const BinaryIMTPoseidon = await viem.deployContract("BinaryIMTPoseidon", [], { value: 0n, libraries: { PoseidonT3: PoseidonT3Lib.address } });
  //   const poseidonTree = await viem.deployContract("testPoseidon", , { libraries: { BinaryIMTPoseidon: BinaryIMTPoseidon.address } })

  //   const leaf = getRandomBigInt() % FIELD_LIMIT
  //   const insertTx = await poseidonTree.write.insert([leaf])
  //   const receipt = await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: insertTx });

  //   const jsTree = new IMT(poseidon2, 32, 0, 2)
  //   jsTree.insert(leaf)
  //   const leafIndex = jsTree.indexOf(leaf)
  //   const merkleProof = jsTree.createProof(leafIndex)

  //   console.time('prove poseidon')
  //   const noir = new Noir(poseidonCircuit as CompiledCircuit);
  //   //os.cpus().length
  //   const backend = new UltraHonkBackend(poseidonCircuit.bytecode);
  //   const proofInputs: InputMap = {
  //     root: toHex(jsTree.root),
  //     leaf: toHex(leaf),
  //     index: toHex(jsTree.indexOf(leaf)),
  //     hash_path: merkleProof.siblings.map((a) => toHex(a[0]))
  //   }
  //   const { witness, returnValue } = await noir.execute(proofInputs);
  //   const proof = await backend.generateProof(witness);
  //   console.timeEnd('prove poseidon')
  // });


  // it("og zk-kit poseidon", async function () {
  //   const PoseidonT3Lib = await viem.deployContract("PoseidonT3", [], { value: 0n, libraries: {} })
  //   const BinaryOldZKKITIMTPoseidon = await viem.deployContract("BinaryOldZKKITIMTPoseidon", [], { value: 0n, libraries: { PoseidonT3: PoseidonT3Lib.address } });
  //   const ogPoseidonTree = await viem.deployContract("testOldZKKITPoseidon", , { libraries: { BinaryOldZKKITIMTPoseidon: BinaryOldZKKITIMTPoseidon.address } })

  //   const leaf = getRandomBigInt() % FIELD_LIMIT
  //   const insertTx = await ogPoseidonTree.write.insert([leaf])
  //   const receipt = await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: insertTx });

  //   const jsTree = new IMT(poseidon2, 32, 0, 2)
  //   jsTree.insert(leaf)
  //   const leafIndex = jsTree.indexOf(leaf)
  //   const merkleProof = jsTree.createProof(leafIndex)

  //   console.time('prove og zk-kit poseidon')
  //   const noir = new Noir(poseidonCircuit as CompiledCircuit);
  //   const backend = new UltraHonkBackend(poseidonCircuit.bytecode);
  //   const proofInputs: InputMap = {
  //     root: toHex(jsTree.root),
  //     leaf: toHex(leaf),
  //     index: toHex(jsTree.indexOf(leaf)),
  //     hash_path: merkleProof.siblings.map((a) => toHex(a[0]))
  //   }
  //   const { witness, returnValue } = await noir.execute(proofInputs);
  //   const proof = await backend.generateProof(witness);
  //   console.timeEnd('prove og zk-kit poseidon')
  // });

  // it("SHA256", async function () {
  //   const BinaryIMTSHA256 = await viem.deployContract("BinaryIMTSHA256");
  //   const SHA256Tree = await viem.deployContract("testSHA256", , { libraries: { BinaryIMTSHA256: BinaryIMTSHA256.address } })

  //   const leaf = getRandomBigInt()
  //   const insertTx = await SHA256Tree.write.insert([leaf])
  //   const receipt = await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: insertTx });

  //   const sha256ForIMT = (input: IMTNode[]) => hexToBigInt(sha256(concat(input.map((v) => toHex(v)))));
  //   const jsTree = new IMT(sha256ForIMT, 32, 0, 2)
  //   jsTree.insert(leaf)
  //   const leafIndex = jsTree.indexOf(leaf)
  //   const merkleProof = jsTree.createProof(leafIndex)

  //   console.time('prove SHA256')
  //   const noir = new Noir(sha256Circuit as CompiledCircuit);
  //   const backend = new UltraHonkBackend(sha256Circuit.bytecode);
  //   const proofInputs: InputMap = {
  //     root: splitHexToU8s(toHex(jsTree.root)),
  //     leaf: splitHexToU8s(toHex(leaf)),
  //     index: toHex(jsTree.indexOf(leaf)),
  //     hash_path: merkleProof.siblings.map((a) => splitHexToU8s(toHex(a[0])))
  //   }
  //   try {
  //     const { witness, returnValue } = await noir.execute(proofInputs);
  //   const proof = await backend.generateProof(witness);
      
  //   } catch (error) {
  //     console.log(error)
  //     throw error
      
  //   }
    
  //   console.timeEnd('prove SHA256');
  //   console.log("done")
  // })
})

