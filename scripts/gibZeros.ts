import {keccak256, concat, numberToBytes, ByteArray, toHex, sha256, toBytes} from "viem"
import { poseidon2Hash } from "@zkpassport/poseidon2"
import { poseidon2 } from "poseidon-lite";
const ZERO_BYTES = numberToBytes(0, { size: 32 })
const ZERO_BIGINT = 0n;

function gibZeroBytes(howMuch:number, zero=ZERO_BYTES, hashFunc=keccak256) {
    let zeros = [zero]
    for (let index = 0; index < howMuch; index++) {
        zero = hashFunc(concat([zero,zero]), "bytes")
        zeros.push(zero)
    }
    return zeros    
}

function gibZeroBigInt(howMuch:number, zero=ZERO_BIGINT, hashFunc=poseidon2) {
    let zeros = [zero]
    for (let index = 0; index < howMuch; index++) {
        zero = hashFunc([zero, zero])
        zeros.push(zero)
    }
    return zeros    
}

function makeSolidityZeros(zeros:ByteArray[]) {
    let constants = ""
    let defaultFunc = `\n    function _defaultZero(uint256 index) internal pure returns (uint256) {\n`
    for (const [index, zero] of Object.entries(zeros)) {
        constants += `    uint256 internal constant Z_${index} = ${toHex(zero)};\n`
        defaultFunc += `        if (index == ${index}) return Z_${index};\n`
    }
   
    defaultFunc += `        revert WrongDefaultZeroIndex();\n    }`
    return constants + defaultFunc
}

console.log(makeSolidityZeros(gibZeroBigInt(256).map((v)=>toBytes(v))))