# zkkit-hashfunc-bench-marks
exploring the trade-offs of hash functions in noir and solidity

## install
```shell
noirup -v 1.0.0-beta.6
bbup -v 0.84.0
```

## compile circuit and verify contracts

### 16 depths circuits and verifier contracts
```shell
# compile and generate contracts
cd circuits/16/poseidon
nargo compile; 
bb write_vk -b ./target/poseidon.json -o ./target/ --oracle_hash keccak;
bb write_solidity_verifier -k ./target/vk --scheme ultra_honk -o  ../../../contracts/test/IMT/verifiers//poseidonIMTVerifier.sol;
cd ../../..;

cd circuits/16/keccak
nargo compile; 
bb write_vk -b ./target/keccak.json -o ./target/ --oracle_hash keccak;
bb write_solidity_verifier -k ./target/vk --scheme ultra_honk -o ../../../contracts/test/IMT/verifiers/keccakIMTVerifier.sol;
cd ../../..;

cd circuits/16/sha256
nargo compile; 
bb write_vk -b ./target/sha256.json -o ./target/ --oracle_hash keccak;
bb write_solidity_verifier -k ./target/vk --scheme ultra_honk -o ../../../contracts/test/IMT/verifiers/sha256IMTVerifier.sol;
cd ../../..;

# rename the contracts
yarn bun ./scripts/replaceLine.ts --file ./contracts/test/IMT/verifiers/poseidonIMTVerifier.sol \
--remove "contract HonkVerifier is BaseHonkVerifier(N, LOG_N, NUMBER_OF_PUBLIC_INPUTS) {" \
--replace "contract poseidonIMTVerifier is BaseHonkVerifier(N, LOG_N, NUMBER_OF_PUBLIC_INPUTS) {";

yarn bun ./scripts/replaceLine.ts --file ./contracts/test/IMT/verifiers/keccakIMTVerifier.sol \
--remove "contract HonkVerifier is BaseHonkVerifier(N, LOG_N, NUMBER_OF_PUBLIC_INPUTS) {" \
--replace "contract keccakIMTVerifier is BaseHonkVerifier(N, LOG_N, NUMBER_OF_PUBLIC_INPUTS) {";

yarn bun ./scripts/replaceLine.ts --file ./contracts/test/IMT/verifiers/sha256IMTVerifier.sol \
--remove "contract HonkVerifier is BaseHonkVerifier(N, LOG_N, NUMBER_OF_PUBLIC_INPUTS) {" \
--replace "contract sha256IMTVerifier is BaseHonkVerifier(N, LOG_N, NUMBER_OF_PUBLIC_INPUTS) {";
```

### 32 depth circuit
```shell
cd circuits/32/poseidon
nargo compile; 
bb write_vk -b ./target/poseidon.json -o ./target/ --oracle_hash keccak;
cd ../../..;

cd circuits/32/keccak
nargo compile; 
bb write_vk -b ./target/keccak.json -o ./target/ --oracle_hash keccak;
cd ../../..;

cd circuits/32/sha256
nargo compile; 
bb write_vk -b ./target/sha256.json -o ./target/ --oracle_hash keccak;
cd ../../..;
```
## run bench mark
```shell
yarn hardhat test
```

## insert 32 depth tree
```yaml
og-zk-kit-poseidon:     2156770 (  0.0%) gas    circuit size: 59673   (  0.0%)  proof time: 4.799s  ( 0.0%)
Poseidon:               2154253 ( +0.1%) gas    circuit size: 59673   (  0.0%)  proof time: 4.799s  ( 0.0%)
Keccak:                 1533760 (-28.8%) gas    circuit size: 1130638 (+1795%)  proof time: DNF     (  DNF)      
Sha256:                 1533760 (-28.8%) gas    circuit size: 581945  ( +875%)  proof time: 26.475s (+451%)
```


## proof time 16 depth tree
```yaml
og-zk-kit-poseidon:     1095899 (  0.0%) gas    circuit size: 29844   (  0.0%)  proof time: 2.647s  (   0.0%)   verifier: 1958720 gas 
Poseidon:               1094638 ( +0.1%) gas    circuit size: 29844   (  0.0%)  proof time: 2.647s  (   0.0%)   verifier: 1958744 gas 
Keccak:                 783116  (-28.5%) gas    circuit size: 565346  (+1794%)  proof time: 45.451s ( +1617%)   verifier: 2172060 gas 
Sha256:                 783116  (-28.5%) gas    circuit size: 292724  ( +880%)  proof time: 14.206s (  +436%)   verifier: 2138237 gas 
```

machine specs: AMD Ryzen 7 5800H, 8 core, 8 threads, 16gb DDR4, high end laptop from 2021  
  
looks like the new custom hash function adds 80 gas per hash?