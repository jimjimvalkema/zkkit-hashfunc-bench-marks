// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import  {BinaryIMTPoseidon2}  from "../../BinaryIMTPoseidon2.sol";
import { BinaryIMTData} from "zk-kit-imt-custom-hash/contracts/InternalBinaryIMT.sol";
contract testPoseidon2 {
    BinaryIMTData public data;

    constructor(uint256 depth) {
        BinaryIMTPoseidon2.initWithDefaultZeroes(data, depth);
    }

    function insert(uint256 leaf) public payable {
        BinaryIMTPoseidon2.insert(data, leaf);
    }

    function update(
        uint256 leaf,
        uint256 newLeaf,
        uint256[] calldata proofSiblings,
        uint8[] calldata proofPathIndices
    ) public {
        BinaryIMTPoseidon2.update(data, leaf, newLeaf, proofSiblings, proofPathIndices);
    }

    function remove(uint256 leaf, uint256[] calldata proofSiblings, uint8[] calldata proofPathIndices) public {
        BinaryIMTPoseidon2.remove(data, leaf, proofSiblings, proofPathIndices);
    }

    function root() public view returns(uint256) {
        return data.root;
    }
}
