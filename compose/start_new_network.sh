#/usr/bin/bash
export ANOMA_TAG=v0.4.0
./tasks init
#./tasks compose up --build 

pids=()

./tasks compose up --build > logs/testnet.log &
pids+=( $! )

sleep 10
echo 'Starting ledger...'
anoma ledger > logs/ledger.log &
pids+=( $! )


sleep 5
echo 'Starting gossip node...'
anoma node gossip --rpc "127.0.0.1:26660" > logs/gossip.log &
pids+=( $! )

#sleep 2
#anoma node matchmaker --matchmaker-path libmm_token_exch.so --tx-code-path tx_from_intent.wasm --ledger-address "127.0.0.1:26657" --source my-matchmaker --signing-key my-matchmaker > mmaker.log 

echo 'Running!'
( trap exit SIGINT ; read -r -d '' _ </dev/tty )

echo 'Killing taks...'
for pid in "${pids[@]}"; do
        kill $pid
done

