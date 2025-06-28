// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import {BinaryIMTKeccak, BinaryIMTData} from "../../BinaryIMTKeccak.sol";

contract testKeccak {
    BinaryIMTData public data;

    constructor(uint256 depth) {
        BinaryIMTKeccak.initWithDefaultZeroes(data, depth);
    }

    function insert(uint256 leaf) public payable {
        BinaryIMTKeccak.insert(data, leaf);
    }

    function update(
        uint256 leaf,
        uint256 newLeaf,
        uint256[] calldata proofSiblings,
        uint8[] calldata proofPathIndices
    ) public {
        BinaryIMTKeccak.update(data, leaf, newLeaf, proofSiblings, proofPathIndices);
    }

    function remove(uint256 leaf, uint256[] calldata proofSiblings, uint8[] calldata proofPathIndices) public {
        BinaryIMTKeccak.remove(data, leaf, proofSiblings, proofPathIndices);
    }
    function root() public view returns(uint256) {
        return data.root;
    }
}
