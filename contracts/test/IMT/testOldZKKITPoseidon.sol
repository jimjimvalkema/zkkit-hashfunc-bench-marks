// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import  {BinaryOldZKKITIMTPoseidon, BinaryIMTData}  from "../../BinaryOldZKKITIMTPoseidon.sol";
//import { BinaryIMTData} from "zk-kit-imt-custom-hash/contracts/InternalBinaryIMT.sol";
contract testOldZKKITPoseidon {
    BinaryIMTData public data;
    uint256 public root;

    constructor(uint256 depth) {
        BinaryOldZKKITIMTPoseidon.initWithDefaultZeroes(data, depth);
    }

    function insert(uint256 leaf) public payable {
        BinaryOldZKKITIMTPoseidon.insert(data, leaf);
    }

    function update(
        uint256 leaf,
        uint256 newLeaf,
        uint256[] calldata proofSiblings,
        uint8[] calldata proofPathIndices
    ) public {
        BinaryOldZKKITIMTPoseidon.update(data, leaf, newLeaf, proofSiblings, proofPathIndices);
    }

    function remove(uint256 leaf, uint256[] calldata proofSiblings, uint8[] calldata proofPathIndices) public {
        BinaryOldZKKITIMTPoseidon.remove(data, leaf, proofSiblings, proofPathIndices);
    }
}
