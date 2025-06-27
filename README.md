# zkkit-hashfunc-bench-marks
exploring the trade-offs of hash functions in noir and solidity

## install
```shell
noirup -v 1.0.0-beta.6
bbup -v 0.84.0
```

## compile circuit and verify contracts
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
yarn ts-node ./scripts/replaceLine.ts --file ./contracts/test/IMT/verifiers/poseidonIMTVerifier.sol \
--remove "contract HonkVerifier is BaseHonkVerifier(N, LOG_N, NUMBER_OF_PUBLIC_INPUTS) {" \
--replace "contract poseidonIMTVerifier is BaseHonkVerifier(N, LOG_N, NUMBER_OF_PUBLIC_INPUTS) {";

yarn ts-node ./scripts/replaceLine.ts --file ./contracts/test/IMT/verifiers/keccakIMTVerifier.sol \
--remove "contract HonkVerifier is BaseHonkVerifier(N, LOG_N, NUMBER_OF_PUBLIC_INPUTS) {" \
--replace "contract keccakIMTVerifier is BaseHonkVerifier(N, LOG_N, NUMBER_OF_PUBLIC_INPUTS) {";

yarn ts-node ./scripts/replaceLine.ts --file ./contracts/test/IMT/verifiers/sha256IMTVerifier.sol \
--remove "contract HonkVerifier is BaseHonkVerifier(N, LOG_N, NUMBER_OF_PUBLIC_INPUTS) {" \
--replace "contract sha256IMTVerifier is BaseHonkVerifier(N, LOG_N, NUMBER_OF_PUBLIC_INPUTS) {";
```

32 depth
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


## insert 32 depth tree
```yaml
og-zk-kit-poseidon:   2156770 (  0.0%) gas   circuit size: 59673     (  0.0%)       proof time: 3.376s  ( 0.0%)
Poseidon:             2154253 ( +0.1%) gas   circuit size: 59673     (  0.0%)       proof time: 3.376s  ( 0.0%)
Keccak:               1533760 (-28.8%) gas   circuit size: 1130638   (+1795%)       proof time: DNF     (  DNF)      
Sha256:               1533760 (-28.8%) gas   circuit size: 581945    ( +875%)       proof time: 20.612s (+791%)
```


## proof time 16 depth tree
```yaml
og-zk-kit-poseidon: circuit size: 29844     (  0.0%)   proof time: 2.178s      (   0.0%)
Poseidon:           circuit size: 29844     (  0.0%)   proof time: 2.178s      (   0.0%)
Keccak:             circuit size: 565346    (+1794%)   proof time: 33.759s     ( +1450%)
Sha256:             circuit size: 292724    ( +880%)   proof time: 11.424s     (  +424%)
```