use trees::{merkle::{Calculator, MembershipProver, MerkleTree}, types::MT_Creator};
use dep::keccak256::keccak256;
global TREE_DEPTH: u32 = 32;

// TODO check if this slice magic has less constraints then asFlat
fn asFlat(leaves: [[u8;32]; 2]) -> [u8;64] {
    let mut flat:[u8;64] = [0;64];
    for index in 0 .. 32 {
        flat[index] = leaves[0][index];
        flat[32 + index] = leaves[1][index];
    }
    flat
}
fn hasher(leaves: [[u8;32]; 2]) -> [u8;32] {
    //let flatLeaves: [u8;64] = leaves[0].as_slice().append(leaves[1]).as_array();
    let flatLeaves = asFlat(leaves);
    let hash = keccak256(flatLeaves, 64);
    hash
}

// @WARNING index being a field means you cannot prove indexes above the field limit
fn main(root: pub [u8; 32], leaf: [u8; 32], index:Field, hash_path: [[u8; 32]; TREE_DEPTH]) {
    let merkle_tree = MerkleTree::from(root, hasher);
    let calculated_root = merkle_tree.calculate_root(leaf,index , hash_path);
    assert(calculated_root == root, "root doesn't match :/");
}