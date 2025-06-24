import {keccak256, concat, numberToBytes, ByteArray, toHex, sha256} from "viem"
const ZERO = numberToBytes(0, { size: 32 })

function gibZero(howMuch:number, zero=ZERO) {
    let zeros = [zero]
    for (let index = 0; index < howMuch; index++) {
        zero = sha256(concat([zero,zero]), "bytes")
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

console.log(makeSolidityZeros(gibZero(256)))