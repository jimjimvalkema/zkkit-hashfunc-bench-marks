use trees::{merkle::{MembershipProver, MerkleTree}, types::MT_Creator};
use dep::poseidon::poseidon;

global TREE_DEPTH: u32 = 16;

fn hasher(leaves: [Field; 2]) -> Field {
    poseidon::bn254::hash_2(leaves)
}

fn main(root:Field, leaf: Field, index:Field, hash_path: [Field; TREE_DEPTH]) {
    let merkle_tree: MerkleTree<Field> = MerkleTree::from(root, hasher);
    merkle_tree.membership(leaf,index , hash_path);
}