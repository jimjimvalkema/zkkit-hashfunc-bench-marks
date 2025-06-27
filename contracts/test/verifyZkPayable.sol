// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
interface IVerifier {
    function verify(bytes calldata _proof, bytes32[] calldata _publicInputs) external view returns (bool);
}

contract verifyZk {
    // viem wont let me estimate gas if its read only so thats why i made this silly thing
    function verifyZkPayable(bytes calldata proof, bytes32[] calldata publicInputs, address verifier) payable public {
        require(IVerifier(verifier).verify(proof, publicInputs), "whoops invalid proof!");
    }
}
