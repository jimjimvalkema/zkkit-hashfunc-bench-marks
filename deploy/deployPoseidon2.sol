pragma solidity ^0.8.28;
import { HuffDeployer } from "foundry-huff/HuffDeployer.sol";

contract deployPoseidon2 {
    function deploy() external returns(address) {
        return HuffDeployer.deploy("Poseidon2");
    }
}