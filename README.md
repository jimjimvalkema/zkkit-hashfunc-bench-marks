# zkkit-hashfunc-bench-marks
exploring the trade-offs of hash functions in noir and solidity

## install
```shell
noirup -v 1.0.0-beta.6
bbup -v 0.84.0
```

## compile circuit and verify contracts
```shell
cd circuits/poseidon
nargo compile; 
bb write_vk -b ./target/poseidon.json -o ./target/ --oracle_hash keccak;
bb write_solidity_verifier -k ./target/vk --scheme ultra_honk -o  ../../contracts/test/IMT/verifiers//poseidonIMTVerifier.sol;
cd ../..;

cd circuits/keccak
nargo compile; 
bb write_vk -b ./target/keccak.json -o ./target/ --oracle_hash keccak;
bb write_solidity_verifier -k ./target/vk --scheme ultra_honk -o ../../contracts/test/IMT/verifiers/keccakIMTVerifier.sol;
cd ../..;

cd circuits/sha256
nargo compile; 
bb write_vk -b ./target/sha256.json -o ./target/ --oracle_hash keccak;
bb write_solidity_verifier -k ./target/vk --scheme ultra_honk -o ../../contracts/test/IMT/verifiers/sha256IMTVerifier.sol;
cd ../..;
```


## insert
```yaml
og-zk-kit-poseidon:   2156770 (  0.0%) gas   circuit size: 59673     (  0.0%)
Poseidon:             2154253 ( +0.1%) gas   circuit size: 59673     (  0.0%)     
Keccak:               1533760 (-28.8%) gas   circuit size: 1130638   (+1795%)  
Sha256:               1533760 (-28.8%) gas   circuit size: 581945    ( +875%)
```