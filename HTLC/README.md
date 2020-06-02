## 创建合约

```bash
nchcli vm create --code_file=./HashedTimeLock.bc \
--from $(nchcli keys show -a alice) \
--gas 10000000
```

## 创建HTLC

```bash
echo 11111111 | \
nchcli vm call \
--from=$(nchcli keys show -a alice) \
--contract_addr=nch1yw28p8hve4lspwfcaysswu82f80pvpse79w5a8 \
--method=CreateHTLC \
--abi_file=./HashedTimeLock.abi \
--args="$(nchcli keys show -a bob) 0x06bcbf53e05cd44da1c9dc7a0737f08eceef318eeab6f4c6743dea34038b62ce $(date -v+1H +%s)" \
--amount=100000000000000pnch \
--gas=300000
```

## 查询合约event

查询合约event，获取新创建的HTLC合约id

```bash
nchcli q vm logs 0D54C3C4D8C53375435687DEF34629E431464AF8D7E4162F96E828FFD4C65730
```

根据合约代码中定义的HTLCNew vent结构，返回结果中，第二个topic为新创建的HTLC contractID

## 查询新创建的HTLC

```bash
nchcli q vm call $(nchcli keys show -a alice) nch1yw28p8hve4lspwfcaysswu82f80pvpse79w5a8 getContract ./HashedTimeLock.abi --args="768c22feacb1a83088947c0996198b57789cd05cd4b0e949bef91992b8f8af37"
```

## 认领HTLC

```bash
nchcli vm call \
--from=$(nchcli keys show -a bob) \
--contract_addr=nch1yw28p8hve4lspwfcaysswu82f80pvpse79w5a8 \
--method=ClaimHTLC \
--abi_file=./HashedTimeLock.abi \
--args="768c22feacb1a83088947c0996198b57789cd05cd4b0e949bef91992b8f8af37 0xpreimagexxxxx" \
--amount=100000000000000pnch \
--gas=300000 
```

## 退款HTLC

```bash
nchcli vm call \
--from=$(nchcli keys show -a alice) \
--contract_addr=nch1yw28p8hve4lspwfcaysswu82f80pvpse79w5a8 \
--method=RefundHTLC \
--abi_file=./HashedTimeLock.abi \
--args="768c22feacb1a83088947c0996198b57789cd05cd4b0e949bef91992b8f8af37" \
--amount=100000000000000pnch \
--gas=300000
```