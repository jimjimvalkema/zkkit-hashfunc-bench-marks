use trees::{merkle::{MembershipProver, MerkleTree}, types::MT_Creator};
use dep::std::hash::poseidon2::{Poseidon2};

global TREE_DEPTH: u32 = 32;

fn hasher(leaves: [Field; 2]) -> Field {
    Poseidon2::hash(leaves, 2)
}

fn main(root:pub Field, leaf: Field, index:Field, hash_path: [Field; TREE_DEPTH]) {
    let merkle_tree: MerkleTree<Field> = MerkleTree::from(root, hasher);
    merkle_tree.membership(leaf,index , hash_path);
}