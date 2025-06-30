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
yarn hardhat node
```
```shell
yarn hardhat test --hardhatMainnet
```

## insert 32 depth tree
```yaml
og-zk-kit-poseidon:     1274125 (  0.0%) gas    circuit size: 59673   (  0.0%)  proof time: 4.306s  ( 0.0%)
Poseidon:               1281514 (+0.58%) gas    circuit size: 59673   (  0.0%)  proof time: 4.306s  ( 0.0%)
Poseidon2*:            11842583 ( +824%) gas
Keccak:                  333599 (-73.4%) gas    circuit size: 1130638 (+1795%)  proof time: DNF     (  DNF)      
Sha256:                  333599 (-73.4%) gas    circuit size: 581945  ( +875%)  proof time: 26.328s (+511%)
```


## proof time 16 depth tree
```yaml
og-zk-kit-poseidon:     658504 (  0.0%) gas    circuit size: 29844   (  0.0%)  proof time: 2.760s  (   0.0%)   verifier: 1958720 gas 
Poseidon:               662188 (+0.56%) gas    circuit size: 29844   (  0.0%)  proof time: 2.760s  (   0.0%)   verifier: 1958744 gas 
Poseidon2*:            5282247 ( +702%) gas
Keccak:                 186941 (-71.6%) gas    circuit size: 565346  (+1794%)  proof time: 45.005s ( +1530%)   verifier: 2172060 gas 
Sha256:                 186941 (-71.6%) gas    circuit size: 292724  ( +880%)  proof time: 14.128s (  +411%)   verifier: 2138237 gas 
```

machine specs: AMD Ryzen 7 5800H, 8 core, 8 threads, 16gb DDR4, high end laptop from 2021  
  
*Poseidon2 is that expensive since i wasn't able to use a more optimized version. Which would be on par or cheaper then the normal poseidon



compile poseidon2 huff
install huff
```shell
curl -L get.huff.sh | bash;
source ~/.bashrc;
haffup;
```
compile
```shell
huffc submodules/poseidon2-evm/src/huff/Poseidon2.huff --bytecode > deploy/poseidon2ByteCode.txt
# now copy paste it in poseidon2huff.ts 
```