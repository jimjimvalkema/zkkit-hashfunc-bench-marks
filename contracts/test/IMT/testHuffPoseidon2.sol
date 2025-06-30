// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import  {BinaryIMTHuffPoseidon2}  from "../../BinaryIMTHuffPoseidon2.sol";
import { BinaryIMTData} from "zk-kit-imt-custom-hash/contracts/InternalBinaryIMT.sol";
import {SNARK_SCALAR_FIELD} from "zk-kit-imt-custom-hash/contracts/Constants.sol";

error ValueGreaterThanSnarkScalarField();
error WrongDefaultZeroIndex();
contract testHuffPoseidon2 {
    BinaryIMTData public data;
    address public poseidon2;

    constructor(uint256 depth, address _poseidon2) {
        BinaryIMTHuffPoseidon2.initWithDefaultZeroes(data, depth);
        poseidon2 = _poseidon2;
    }

    function hash(uint256[1] memory inputs) public returns (bytes memory) {
        (,bytes memory result )= poseidon2.call(
            abi.encode([uint256(1),uint256(1)])
        );
        //require(success, "call to poseidon2 failed");
        return result;
    }

    function hasher(uint256[2] memory inputs) internal view returns (uint256) {
        if (inputs[0] >= SNARK_SCALAR_FIELD || inputs[1] >= SNARK_SCALAR_FIELD) {
            revert ValueGreaterThanSnarkScalarField();
        }
        (bool success,bytes memory result) = poseidon2.staticcall(
            abi.encode(
                inputs[0],
                inputs[1]
            )
        );
        require(success, "call to poseidon2 failed");
        return uint256(bytes32(result));
    }

    function hasherUnsafe(uint256[2] memory inputs) internal view returns (uint256) {
        (bool success,bytes memory result) = poseidon2.staticcall(
            abi.encode(
                inputs[0],
                inputs[1]
            )
        );
        require(success, "call to poseidon2 failed");
        return uint256(bytes32(result));
    }

    function insert(uint256 leaf) public payable {
        BinaryIMTHuffPoseidon2.insert(data, leaf, hasherUnsafe);
    }

    function update(
        uint256 leaf,
        uint256 newLeaf,
        uint256[] calldata proofSiblings,
        uint8[] calldata proofPathIndices
    ) public {
        BinaryIMTHuffPoseidon2.update(data, leaf, newLeaf, proofSiblings, proofPathIndices, hasher);
    }

    function remove(uint256 leaf, uint256[] calldata proofSiblings, uint8[] calldata proofPathIndices) public {
        BinaryIMTHuffPoseidon2.remove(data, leaf, proofSiblings, proofPathIndices, hasher);
    }

    function root() public view returns(uint256) {
        return data.root;
    }
}
