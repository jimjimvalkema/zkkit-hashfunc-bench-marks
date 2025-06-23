// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import  {BinaryIMT}  from "zk-kit-imt-custom-hash/contracts/BinaryIMT.sol";
import { BinaryIMTData} from "zk-kit-imt-custom-hash/contracts/InternalBinaryIMT.sol";
contract testPoseidon {
    BinaryIMTData public data;
    uint256 public root;

    constructor(uint256 depth) {
        BinaryIMT.initWithDefaultZeroes(data, depth);
    }

    function insert(uint256 leaf) public payable {
        BinaryIMT.insert(data, leaf);
    }

    function update(
        uint256 leaf,
        uint256 newLeaf,
        uint256[] calldata proofSiblings,
        uint8[] calldata proofPathIndices
    ) public {
        BinaryIMT.update(data, leaf, newLeaf, proofSiblings, proofPathIndices);
    }

    function remove(uint256 leaf, uint256[] calldata proofSiblings, uint8[] calldata proofPathIndices) public {
        BinaryIMT.remove(data, leaf, proofSiblings, proofPathIndices);
    }
}
