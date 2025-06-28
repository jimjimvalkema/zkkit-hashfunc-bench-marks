// We don't have Ethereum specific assertions in Hardhat 3 yet
import { describe, it, assert } from "node:test";

import { network } from "hardhat";
import { bytesToBigInt, TransactionReceipt, toHex, keccak256, sha256, hexToBigInt, concat, padHex, toBytes, Hex } from "viem"
import { UltraHonkBackend } from '@aztec/bb.js';
import { Noir, CompiledCircuit, InputMap } from '@noir-lang/noir_js';
import keccakCircuit16 from "../circuits/16/keccak/target/keccak.json" //assert { type: 'json' };
import sha256Circuit16 from "../circuits/16/sha256/target/sha256.json"
import poseidonCircuit16 from "../circuits/16/poseidon/target/poseidon.json"
import keccakCircuit32 from "../circuits/32/keccak/target/keccak.json" //assert { type: 'json' };
import sha256Circuit32 from "../circuits/32/sha256/target/sha256.json"
import poseidonCircuit32 from "../circuits/32/poseidon/target/poseidon.json"
import { IMT, IMTNode } from "@zk-kit/imt"
import { poseidon2 } from "poseidon-lite"
import os from "node:os"
import { MerkleTree, PartialMerkleTree } from 'fixed-merkle-tree'
const FIELD_LIMIT = 21888242871839275222246405745257275088548364400416034343698204186575808495617n
const getRandomBigInt = () => bytesToBigInt(crypto.getRandomValues(new Uint8Array(new Array(32).fill(0))))
const pad = (hexArr: string[], len = 32) => {
  return hexArr.length === len ? hexArr : [...new Array(len - hexArr.length).fill("0x00"), ...hexArr]
}
const smallPad = (s: string) => s.length === 2 ? s : "0" + s
//@ts-ignore
const splitHexToU8s = (hex: string, padLen = 32) => pad(hex.replace(/^0x/, '').match(/.{1,2}/g).map((n) => "0x" + n), padLen);

describe("insert gas test 32", async function () {
  const { viem } = await network.connect();
  const treeDepth = 32n

  it("old zk-kit poseidon", async function () {
    const PoseidonT3Lib = await viem.deployContract("PoseidonT3", [], { value: 0n, libraries: {} })
    const BinaryOldZKKITIMTPoseidon = await viem.deployContract("BinaryOldZKKITIMTPoseidon", [], { value: 0n, libraries: { PoseidonT3: PoseidonT3Lib.address } });
    const ogPoseidonTree = await viem.deployContract("testOldZKKITPoseidon", [treeDepth], { libraries: { BinaryOldZKKITIMTPoseidon: BinaryOldZKKITIMTPoseidon.address } })

    const iters = 25
    const leafs = new Array(iters).fill(0).map((v, i) => BigInt(i))
    const insertTxs: any = []
        // first insert is alway way more expensive since it warm the slots
    await ogPoseidonTree.write.insert([10000000000000000000n])
    for (const leaf of leafs) {
      insertTxs.push(await ogPoseidonTree.write.insert([leaf]))

    }
    //@ts-ignore
    const receipts = await Promise.all(insertTxs.map(async (hash) => await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: await hash })))
    const totalGas = receipts.reduce((a: bigint, b: TransactionReceipt) => a + b.gasUsed, 0n);
    const averageGasInsert = Number(totalGas) / iters
    const root = toHex(await ogPoseidonTree.read.root())
    console.log({ averageGasInsert, root })
  });

  it("poseidon", async function () {
    const PoseidonT3Lib = await viem.deployContract("PoseidonT3", [], { value: 0n, libraries: {} })
    const BinaryIMTPoseidon = await viem.deployContract("BinaryIMTPoseidon", [], { value: 0n, libraries: { PoseidonT3: PoseidonT3Lib.address } });
    const poseidonTree = await viem.deployContract("testPoseidon", [treeDepth], { libraries: { BinaryIMTPoseidon: BinaryIMTPoseidon.address } })

    const iters = 25

    const leafs = new Array(iters).fill(0).map((v, i) => BigInt(i))
    const insertTxs: any = []
    // first insert is alway way more expensive since it warm the slots
    await poseidonTree.write.insert([10000000000000000000n])
    for (const leaf of leafs) {
      insertTxs.push(await poseidonTree.write.insert([leaf]))

    }
    //@ts-ignore
    const receipts = await Promise.all(insertTxs.map(async (hash) => await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: await hash })))
    const totalGas = receipts.reduce((a: bigint, b: TransactionReceipt) => a + b.gasUsed, 0n);
    const averageGasInsert = Number(totalGas) / iters
    const root = toHex(await poseidonTree.read.root())
    console.log({ averageGasInsert, root })
  });

  it("poseidon2", async function () {
    const Poseidon2 = await viem.deployContract("Poseidon2", [], { value: 0n, libraries: {} })
    const BinaryIMTPoseidon2 = await viem.deployContract("BinaryIMTPoseidon2", [], { value: 0n, libraries: {} });
    const poseidon2Tree = await viem.deployContract("testPoseidon2", [treeDepth], { libraries: { BinaryIMTPoseidon2: BinaryIMTPoseidon2.address } })

    const iters = 3

    const leafs = new Array(iters).fill(0).map((v, i) => BigInt(i))
    const insertTxs: any = []
        // first insert is alway way more expensive since it warm the slots
    await poseidon2Tree.write.insert([10000000000000000000n])
    for (const leaf of leafs) {
      insertTxs.push(await poseidon2Tree.write.insert([leaf]))

    }
    //@ts-ignore
    const receipts = await Promise.all(insertTxs.map(async (hash) => await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: await hash })))
    const totalGas = receipts.reduce((a: bigint, b: TransactionReceipt) => a + b.gasUsed, 0n);
    const averageGasInsert = Number(totalGas) / iters
    const root = toHex(await poseidon2Tree.read.root())
    console.log({ averageGasInsert, root })
  });

  it("keccak", async function () {
    const BinaryIMTKeccak = await viem.deployContract("BinaryIMTKeccak");
    const keccakTree = await viem.deployContract("testKeccak", [treeDepth], { libraries: { BinaryIMTKeccak: BinaryIMTKeccak.address } })

    const iters = 25
    const leafs = new Array(iters).fill(0).map((v, i) => BigInt(i))
    const insertTxs: any = []
        // first insert is alway way more expensive since it warm the slots
    await keccakTree.write.insert([10000000000000000000n])
    for (const leaf of leafs) {
      insertTxs.push(await keccakTree.write.insert([leaf]))

    }
    //@ts-ignore
    const receipts = await Promise.all(insertTxs.map(async (hash) => await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: await hash })))
    const totalGas = receipts.reduce((a: bigint, b: TransactionReceipt) => a + b.gasUsed, 0n);
    const averageGasInsert = Number(totalGas) / iters
    const root = toHex(await keccakTree.read.root())
    console.log({ averageGasInsert, root })
  });

  it("SHA256", async function () {
    const BinaryIMTSHA256 = await viem.deployContract("BinaryIMTSHA256");
    const SHA256Tree = await viem.deployContract("testSHA256", [treeDepth], { libraries: { BinaryIMTSHA256: BinaryIMTSHA256.address } })

    const iters = 25
    const leafs = new Array(iters).fill(0).map((v, i) => BigInt(i))
    const insertTxs: any = []
        // first insert is alway way more expensive since it warm the slots
    await SHA256Tree.write.insert([10000000000000000000n])
    for (const leaf of leafs) {
      insertTxs.push(await SHA256Tree.write.insert([leaf]))

    }
    //@ts-ignore
    const receipts = await Promise.all(insertTxs.map(async (hash) => await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: await hash })))
    const totalGas = receipts.reduce((a: bigint, b: TransactionReceipt) => a + b.gasUsed, 0n);
    const averageGasInsert = Number(totalGas) / iters
    const root = toHex(await SHA256Tree.read.root())
    console.log({ averageGasInsert, root })
  });
});
describe("insert gas test 16", async function () {
  const { viem } = await network.connect();
  const treeDepth = 16n

  it("old zk-kit poseidon", async function () {
    const PoseidonT3Lib = await viem.deployContract("PoseidonT3", [], { value: 0n, libraries: {} })
    const BinaryOldZKKITIMTPoseidon = await viem.deployContract("BinaryOldZKKITIMTPoseidon", [], { value: 0n, libraries: { PoseidonT3: PoseidonT3Lib.address } });
    const ogPoseidonTree = await viem.deployContract("testOldZKKITPoseidon", [treeDepth], { libraries: { BinaryOldZKKITIMTPoseidon: BinaryOldZKKITIMTPoseidon.address } })

    const iters = 25
    const leafs = new Array(iters).fill(0).map((v, i) => BigInt(i))
    const insertTxs: any = []
        // first insert is alway way more expensive since it warm the slots
    await ogPoseidonTree.write.insert([10000000000000000000n])
    for (const leaf of leafs) {
      insertTxs.push(await ogPoseidonTree.write.insert([leaf]))

    }
    //@ts-ignore
    const receipts = await Promise.all(insertTxs.map(async (hash) => await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: await hash })))
    const totalGas = receipts.reduce((a: bigint, b: TransactionReceipt) => a + b.gasUsed, 0n);
    const averageGasInsert = Number(totalGas) / iters
    const root = toHex(await ogPoseidonTree.read.root())
    console.log({ averageGasInsert, root })
  });

  it("poseidon", async function () {
    const PoseidonT3Lib = await viem.deployContract("PoseidonT3", [], { value: 0n, libraries: {} })
    const BinaryIMTPoseidon = await viem.deployContract("BinaryIMTPoseidon", [], { value: 0n, libraries: { PoseidonT3: PoseidonT3Lib.address } });
    const poseidonTree = await viem.deployContract("testPoseidon", [treeDepth], { libraries: { BinaryIMTPoseidon: BinaryIMTPoseidon.address } })

    const iters = 25

    const leafs = new Array(iters).fill(0).map((v, i) => BigInt(i))
    const insertTxs: any = []
    // first insert is alway way more expensive since it warm the slots
    await poseidonTree.write.insert([10000000000000000000n])
    for (const leaf of leafs) {
      insertTxs.push(await poseidonTree.write.insert([leaf]))

    }
    //@ts-ignore
    const receipts = await Promise.all(insertTxs.map(async (hash) => await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: await hash })))
    const totalGas = receipts.reduce((a: bigint, b: TransactionReceipt) => a + b.gasUsed, 0n);
    const averageGasInsert = Number(totalGas) / iters
    const root = toHex(await poseidonTree.read.root())
    console.log({ averageGasInsert, root })
  });

  it("poseidon2", async function () {
    const Poseidon2 = await viem.deployContract("Poseidon2", [], { value: 0n, libraries: {} })
    const BinaryIMTPoseidon2 = await viem.deployContract("BinaryIMTPoseidon2", [], { value: 0n, libraries: {} });
    const poseidon2Tree = await viem.deployContract("testPoseidon2", [treeDepth], { libraries: { BinaryIMTPoseidon2: BinaryIMTPoseidon2.address } })

    const iters = 3

    const leafs = new Array(iters).fill(0).map((v, i) => BigInt(i))
    const insertTxs: any = []
        // first insert is alway way more expensive since it warm the slots
    await poseidon2Tree.write.insert([10000000000000000000n])
    for (const leaf of leafs) {
      insertTxs.push(await poseidon2Tree.write.insert([leaf]))

    }
    //@ts-ignore
    const receipts = await Promise.all(insertTxs.map(async (hash) => await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: await hash })))
    const totalGas = receipts.reduce((a: bigint, b: TransactionReceipt) => a + b.gasUsed, 0n);
    const averageGasInsert = Number(totalGas) / iters
    const root = toHex(await poseidon2Tree.read.root())
    console.log({ averageGasInsert, root })
  });

  it("keccak", async function () {
    const BinaryIMTKeccak = await viem.deployContract("BinaryIMTKeccak");
    const keccakTree = await viem.deployContract("testKeccak", [treeDepth], { libraries: { BinaryIMTKeccak: BinaryIMTKeccak.address } })

    const iters = 25
    const leafs = new Array(iters).fill(0).map((v, i) => BigInt(i))
    const insertTxs: any = []
        // first insert is alway way more expensive since it warm the slots
    await keccakTree.write.insert([10000000000000000000n])
    for (const leaf of leafs) {
      insertTxs.push(await keccakTree.write.insert([leaf]))

    }
    //@ts-ignore
    const receipts = await Promise.all(insertTxs.map(async (hash) => await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: await hash })))
    const totalGas = receipts.reduce((a: bigint, b: TransactionReceipt) => a + b.gasUsed, 0n);
    const averageGasInsert = Number(totalGas) / iters
    const root = toHex(await keccakTree.read.root())
    console.log({ averageGasInsert, root })
  });

  it("SHA256", async function () {
    const BinaryIMTSHA256 = await viem.deployContract("BinaryIMTSHA256");
    const SHA256Tree = await viem.deployContract("testSHA256", [treeDepth], { libraries: { BinaryIMTSHA256: BinaryIMTSHA256.address } })

    const iters = 25
    const leafs = new Array(iters).fill(0).map((v, i) => BigInt(i))
    const insertTxs: any = []
        // first insert is alway way more expensive since it warm the slots
    await SHA256Tree.write.insert([10000000000000000000n])
    for (const leaf of leafs) {
      insertTxs.push(await SHA256Tree.write.insert([leaf]))

    }
    //@ts-ignore
    const receipts = await Promise.all(insertTxs.map(async (hash) => await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: await hash })))
    const totalGas = receipts.reduce((a: bigint, b: TransactionReceipt) => a + b.gasUsed, 0n);
    const averageGasInsert = Number(totalGas) / iters
    const root = toHex(await SHA256Tree.read.root())
    console.log({ averageGasInsert, root })
  });
});

describe("prove 16 depth", async function () {
  const { viem } = await network.connect();
  const publicClient = await viem.getPublicClient();
  const verifyZk = await viem.deployContract("verifyZk", [], {})
  const treeDepth = 16n


  it("og zk-kit poseidon", async function () {
    const PoseidonT3Lib = await viem.deployContract("PoseidonT3", [], { value: 0n, libraries: {} })
    const BinaryOldZKKITIMTPoseidon = await viem.deployContract("BinaryOldZKKITIMTPoseidon", [], { value: 0n, libraries: { PoseidonT3: PoseidonT3Lib.address } });
    const ogPoseidonTree = await viem.deployContract("testOldZKKITPoseidon", [treeDepth], { libraries: { BinaryOldZKKITIMTPoseidon: BinaryOldZKKITIMTPoseidon.address } })
    const verifier = await viem.deployContract("poseidonIMTVerifier", [], {})

    const leaf = getRandomBigInt() % FIELD_LIMIT
    const insertTx = await ogPoseidonTree.write.insert([leaf])
    const receipt = await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: insertTx });

    const jsTree = new IMT(poseidon2, Number(treeDepth), 0, 2)
    jsTree.insert(leaf)
    const leafIndex = jsTree.indexOf(leaf)
    const merkleProof = jsTree.createProof(leafIndex)

    console.time('prove og zk-kit poseidon')
    const threads = os.cpus().length
    console.log({ threads })
    const noir = new Noir(poseidonCircuit16 as CompiledCircuit);
    const backend = new UltraHonkBackend(poseidonCircuit16.bytecode, { threads });
    const proofInputs: InputMap = {
      root: toHex(jsTree.root),
      leaf: toHex(leaf),
      index: toHex(jsTree.indexOf(leaf)),
      hash_path: merkleProof.siblings.map((a) => toHex(a[0]))
    }
    const { witness, returnValue } = await noir.execute(proofInputs);
    const proof = await backend.generateProof(witness, { keccak: true });
    console.timeEnd('prove og zk-kit poseidon')
    await backend.destroy()
    //@ts-ignore
    const verifyTx = await verifyZk.write.verifyZkPayable([toHex(proof.proof), [padHex(proofInputs.root, { size: 32 })], verifier.address])
    const verifyReceipt = await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: verifyTx });
    console.log({ verifyGas: verifyReceipt.gasUsed })
  });

  it("poseidon", async function () {
    const PoseidonT3Lib = await viem.deployContract("PoseidonT3", [], { value: 0n, libraries: {} })
    const BinaryIMTPoseidon = await viem.deployContract("BinaryIMTPoseidon", [], { value: 0n, libraries: { PoseidonT3: PoseidonT3Lib.address } });
    const poseidonTree = await viem.deployContract("testPoseidon", [treeDepth], { libraries: { BinaryIMTPoseidon: BinaryIMTPoseidon.address } })
    const verifier = await viem.deployContract("poseidonIMTVerifier", [], {})

    const leaf = getRandomBigInt() % FIELD_LIMIT
    const insertTx = await poseidonTree.write.insert([leaf])
    const receipt = await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: insertTx });

    const jsTree = new IMT(poseidon2, Number(treeDepth), 0, 2)
    jsTree.insert(leaf)
    const leafIndex = jsTree.indexOf(leaf)
    const merkleProof = jsTree.createProof(leafIndex)

    console.time('prove poseidon')
    const threads = os.cpus().length
    console.log({ threads })
    const noir = new Noir(poseidonCircuit16 as CompiledCircuit);
    const backend = new UltraHonkBackend(poseidonCircuit16.bytecode, { threads });
    const proofInputs: InputMap = {
      root: toHex(jsTree.root),
      leaf: toHex(leaf),
      index: toHex(jsTree.indexOf(leaf)),
      hash_path: merkleProof.siblings.map((a) => toHex(a[0]))
    }
    const { witness, returnValue } = await noir.execute(proofInputs);
    const proof = await backend.generateProof(witness, { keccak: true });
    console.timeEnd('prove poseidon')
    await backend.destroy()
    //@ts-ignore
    const verifyTx = await verifyZk.write.verifyZkPayable([toHex(proof.proof), [padHex(proofInputs.root, { size: 32 })], verifier.address])
    const verifyReceipt = await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: verifyTx });
    console.log({ verifyGas: verifyReceipt.gasUsed })
  });

  it("keccak", async function () {
    const BinaryIMTKeccak = await viem.deployContract("BinaryIMTKeccak");
    const keccakTree = await viem.deployContract("testKeccak", [treeDepth], { libraries: { BinaryIMTKeccak: BinaryIMTKeccak.address } })
    const verifier = await viem.deployContract("keccakIMTVerifier", [], {})

    const leaf = 12345n//getRandomBigInt()
    const insertTx = await keccakTree.write.insert([leaf])
    const receipt = await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: insertTx })

    const hashFunction = (left: Hex, right: Hex) => keccak256(concat([padHex(left, { size: 32 }), padHex(right, { size: 32 })]))
    const hashFunctionButBigInt = (input: IMTNode[]) => hexToBigInt(hashFunction(toHex(input[0], { size: 32 }), toHex(input[1], { size: 32 })))
    const jsTree = new IMT(hashFunctionButBigInt, Number(treeDepth), 0, 2, [leaf])
    const leafIndex = jsTree.indexOf(leaf)
    const merkleProof = jsTree.createProof(leafIndex)

    console.time('prove keccak')
    const threads = os.cpus().length
    console.log({ threads })
    const noir = new Noir(keccakCircuit16 as CompiledCircuit);
    const backend = new UltraHonkBackend(keccakCircuit16.bytecode, { threads });

    const proofInputs: InputMap = {
      root: splitHexToU8s(toHex(jsTree.root, { size: 32 })),
      leaf: splitHexToU8s(toHex(leaf, { size: 32 })),
      index: toHex(jsTree.indexOf(leaf), { size: 32 }),
      hash_path: merkleProof.siblings.map((a) => splitHexToU8s(toHex(a[0], { size: 32 })))
    }
    let proof
    try {
      const { witness, returnValue } = await noir.execute(proofInputs);
      proof = await backend.generateProof(witness, { keccak: true });

    } catch (error) {
      console.error(error)
      throw error;
    }

    console.timeEnd('prove keccak')
    await backend.destroy()
    //@ts-ignore
    const verifyTx = await verifyZk.write.verifyZkPayable([toHex(proof.proof), [...proofInputs.root.map((v) => padHex(v, { size: 32 }))], verifier.address])
    const verifyReceipt = await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: verifyTx });
    console.log({ verifyGas: verifyReceipt.gasUsed })

  });

  it("sha256", async function () {
    const BinaryIMTSHA256 = await viem.deployContract("BinaryIMTSHA256");
    const SHA256Tree = await viem.deployContract("testSHA256", [treeDepth], { libraries: { BinaryIMTSHA256: BinaryIMTSHA256.address } })
    const verifier = await viem.deployContract("sha256IMTVerifier", [], {})
    const leaf = 12345n//getRandomBigInt()
    const insertTx = await SHA256Tree.write.insert([leaf])
    const receipt = await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: insertTx })

    const hashFunction = (left: Hex, right: Hex) => sha256(concat([padHex(left, { size: 32 }), padHex(right, { size: 32 })]))
    const hashFunctionButBigInt = (input: IMTNode[]) => hexToBigInt(hashFunction(toHex(input[0], { size: 32 }), toHex(input[1], { size: 32 })))
    const jsTree = new IMT(hashFunctionButBigInt, Number(treeDepth), 0, 2, [leaf])
    const leafIndex = jsTree.indexOf(leaf)
    const merkleProof = jsTree.createProof(leafIndex)

    console.time('prove sha256')
    const threads = os.cpus().length
    console.log({ threads })
    const noir = new Noir(sha256Circuit16 as CompiledCircuit);
    const backend = new UltraHonkBackend(sha256Circuit16.bytecode, { threads });

    const proofInputs: InputMap = {
      root: splitHexToU8s(toHex(jsTree.root, { size: 32 })),
      leaf: splitHexToU8s(toHex(leaf, { size: 32 })),
      index: toHex(jsTree.indexOf(leaf), { size: 32 }),
      hash_path: merkleProof.siblings.map((a) => splitHexToU8s(toHex(a[0], { size: 32 })))
    }
    let proof
    try {
      const { witness, returnValue } = await noir.execute(proofInputs);
      proof = await backend.generateProof(witness, { keccak: true });

    } catch (error) {
      console.error(error)
      throw error;
    }

    console.timeEnd('prove sha256')
    await backend.destroy()
    //@ts-ignore
    const verifyTx = await verifyZk.write.verifyZkPayable([toHex(proof.proof), [...proofInputs.root.map((v) => padHex(v, { size: 32 }))], verifier.address])
    const verifyReceipt = await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: verifyTx });
    console.log({ verifyGas: verifyReceipt.gasUsed })

  });
})
describe("prove 32 depth", async function () {
  const { viem } = await network.connect();
  const publicClient = await viem.getPublicClient();
  const treeDepth = 32n

  it("og zk-kit poseidon", async function () {
    const PoseidonT3Lib = await viem.deployContract("PoseidonT3", [], { value: 0n, libraries: {} })
    const BinaryOldZKKITIMTPoseidon = await viem.deployContract("BinaryOldZKKITIMTPoseidon", [], { value: 0n, libraries: { PoseidonT3: PoseidonT3Lib.address } });
    const ogPoseidonTree = await viem.deployContract("testOldZKKITPoseidon", [treeDepth], { libraries: { BinaryOldZKKITIMTPoseidon: BinaryOldZKKITIMTPoseidon.address } })

    const leaf = getRandomBigInt() % FIELD_LIMIT
    const insertTx = await ogPoseidonTree.write.insert([leaf])
    const receipt = await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: insertTx });

    const jsTree = new IMT(poseidon2, Number(treeDepth), 0, 2)
    jsTree.insert(leaf)
    const leafIndex = jsTree.indexOf(leaf)
    const merkleProof = jsTree.createProof(leafIndex)

    console.time('prove og zk-kit poseidon')
    const threads = os.cpus().length
    console.log({ threads })
    const noir = new Noir(poseidonCircuit32 as CompiledCircuit);
    const backend = new UltraHonkBackend(poseidonCircuit32.bytecode, { threads });
    const proofInputs: InputMap = {
      root: toHex(jsTree.root),
      leaf: toHex(leaf),
      index: toHex(jsTree.indexOf(leaf)),
      hash_path: merkleProof.siblings.map((a) => toHex(a[0]))
    }
    const { witness, returnValue } = await noir.execute(proofInputs);
    const proof = await backend.generateProof(witness, { keccak: true });
    console.timeEnd('prove og zk-kit poseidon')
    await backend.destroy()
  });

  it("poseidon", async function () {
    const PoseidonT3Lib = await viem.deployContract("PoseidonT3", [], { value: 0n, libraries: {} })
    const BinaryIMTPoseidon = await viem.deployContract("BinaryIMTPoseidon", [], { value: 0n, libraries: { PoseidonT3: PoseidonT3Lib.address } });
    const poseidonTree = await viem.deployContract("testPoseidon", [treeDepth], { libraries: { BinaryIMTPoseidon: BinaryIMTPoseidon.address } })

    const leaf = getRandomBigInt() % FIELD_LIMIT
    const insertTx = await poseidonTree.write.insert([leaf])
    const receipt = await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: insertTx });

    const jsTree = new IMT(poseidon2, Number(treeDepth), 0, 2)
    jsTree.insert(leaf)
    const leafIndex = jsTree.indexOf(leaf)
    const merkleProof = jsTree.createProof(leafIndex)

    console.time('prove poseidon')
    const threads = os.cpus().length
    console.log({ threads })
    const noir = new Noir(poseidonCircuit32 as CompiledCircuit);
    const backend = new UltraHonkBackend(poseidonCircuit32.bytecode, { threads });
    const proofInputs: InputMap = {
      root: toHex(jsTree.root),
      leaf: toHex(leaf),
      index: toHex(jsTree.indexOf(leaf)),
      hash_path: merkleProof.siblings.map((a) => toHex(a[0]))
    }
    const { witness, returnValue } = await noir.execute(proofInputs);
    const proof = await backend.generateProof(witness, { keccak: true });
    console.timeEnd('prove poseidon')
    await backend.destroy()
  });

  it("keccak", async function () {
    const BinaryIMTKeccak = await viem.deployContract("BinaryIMTKeccak");
    const keccakTree = await viem.deployContract("testKeccak", [treeDepth], { libraries: { BinaryIMTKeccak: BinaryIMTKeccak.address } })

    const leaf = 12345n//getRandomBigInt()
    const insertTx = await keccakTree.write.insert([leaf])
    const receipt = await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: insertTx })

    const hashFunction = (left: Hex, right: Hex) => keccak256(concat([padHex(left, { size: 32 }), padHex(right, { size: 32 })]))
    const hashFunctionButBigInt = (input: IMTNode[]) => hexToBigInt(hashFunction(toHex(input[0], { size: 32 }), toHex(input[1], { size: 32 })))
    const jsTree = new IMT(hashFunctionButBigInt, Number(treeDepth), 0, 2, [leaf])
    const leafIndex = jsTree.indexOf(leaf)
    const merkleProof = jsTree.createProof(leafIndex)

    console.time('prove keccak')
    const threads = os.cpus().length
    console.log({ threads })
    const noir = new Noir(keccakCircuit32 as CompiledCircuit);
    const backend = new UltraHonkBackend(keccakCircuit32.bytecode, { threads });

    const proofInputs: InputMap = {
      root: splitHexToU8s(toHex(jsTree.root, { size: 32 })),
      leaf: splitHexToU8s(toHex(leaf, { size: 32 })),
      index: toHex(jsTree.indexOf(leaf), { size: 32 }),
      hash_path: merkleProof.siblings.map((a) => splitHexToU8s(toHex(a[0], { size: 32 })))
    }
    let proof
    try {
      const { witness, returnValue } = await noir.execute(proofInputs);
      proof = await backend.generateProof(witness, { keccak: true });

    } catch (error) {
      console.error(error)
      await backend.destroy()
      throw error;
    }

    console.timeEnd('prove keccak')
    await backend.destroy()
  });

  it("sha256", async function () {
    const BinaryIMTSHA256 = await viem.deployContract("BinaryIMTSHA256");
    const SHA256Tree = await viem.deployContract("testSHA256", [treeDepth], { libraries: { BinaryIMTSHA256: BinaryIMTSHA256.address } })

    const leaf = 12345n//getRandomBigInt()
    const insertTx = await SHA256Tree.write.insert([leaf])
    const receipt = await (await viem.getPublicClient()).waitForTransactionReceipt({ hash: insertTx })

    const hashFunction = (left: Hex, right: Hex) => sha256(concat([padHex(left, { size: 32 }), padHex(right, { size: 32 })]))
    const hashFunctionButBigInt = (input: IMTNode[]) => hexToBigInt(hashFunction(toHex(input[0], { size: 32 }), toHex(input[1], { size: 32 })))
    const jsTree = new IMT(hashFunctionButBigInt, Number(treeDepth), 0, 2, [leaf])
    const leafIndex = jsTree.indexOf(leaf)
    const merkleProof = jsTree.createProof(leafIndex)

    console.time('prove sha256')
    const threads = os.cpus().length
    console.log({ threads })
    const noir = new Noir(sha256Circuit32 as CompiledCircuit);
    const backend = new UltraHonkBackend(sha256Circuit32.bytecode, { threads });

    const proofInputs: InputMap = {
      root: splitHexToU8s(toHex(jsTree.root, { size: 32 })),
      leaf: splitHexToU8s(toHex(leaf, { size: 32 })),
      index: toHex(jsTree.indexOf(leaf), { size: 32 }),
      hash_path: merkleProof.siblings.map((a) => splitHexToU8s(toHex(a[0], { size: 32 })))
    }
    let proof
    try {
      const { witness, returnValue } = await noir.execute(proofInputs);
      proof = await backend.generateProof(witness, { keccak: true });

    } catch (error) {
      console.error(error)
      await backend.destroy()
      throw error;
    }

    console.timeEnd('prove sha256')
    await backend.destroy()
  });
})



