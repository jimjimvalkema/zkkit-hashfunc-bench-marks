use trees::{merkle::{MembershipProver, MerkleTree}, types::MT_Creator};
use dep::sha256::sha256_var;
global TREE_DEPTH:u32 = 32;
// TODO check if this slice magic has less constraints then asFlat
fn hasher(leaves: [[u8;32]; 2]) -> [u8;32] {
    let flatLeaves: [u8;64] = leaves[0].as_slice().append(leaves[1]).as_array();
    sha256_var(flatLeaves, 64)
}

// @WARNING index being a field means you cannot prove indexes above the field limit
fn main(root: pub [u8; 32], leaf: [u8; 32], index:Field, hash_path: [[u8; 32]; TREE_DEPTH]) {
    let merkle_tree: MerkleTree<[u8; 32]> = MerkleTree::from(root, hasher);
    merkle_tree.membership(leaf,index , hash_path);
}