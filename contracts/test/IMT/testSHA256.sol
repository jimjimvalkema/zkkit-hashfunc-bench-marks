// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import {BinaryIMTSHA256, BinaryIMTData} from "../../BinaryIMTSHA256.sol";

contract testSHA256 {
    BinaryIMTData public data;

    constructor(uint256 depth) {
        BinaryIMTSHA256.initWithDefaultZeroes(data, depth);
    }

    function insert(uint256 leaf) public payable {
        BinaryIMTSHA256.insert(data, leaf);
    }

    function update(
        uint256 leaf,
        uint256 newLeaf,
        uint256[] calldata proofSiblings,
        uint8[] calldata proofPathIndices
    ) public {
        BinaryIMTSHA256.update(data, leaf, newLeaf, proofSiblings, proofPathIndices);
    }

    function remove(uint256 leaf, uint256[] calldata proofSiblings, uint8[] calldata proofPathIndices) public {
        BinaryIMTSHA256.remove(data, leaf, proofSiblings, proofPathIndices);
    }

    function root() public view returns(uint256) {
        return data.root;
    }
}
