#/usr/bin/bash
export ANOMA_TAG=v0.4.0
./tasks init

./tasks compose up --build > logs/testnet.log &
pids+=( $! )

sleep 10
echo 'Starting ledger...'
anoma node ledger run > logs/ledger.log &
pids+=( $! )


sleep 5
echo 'Starting gossip node...'
anoma node gossip --rpc "127.0.0.1:26660" > logs/gossip.log &
pids+=( $! )

#### matchmaker
sleep 3
echo 'Creating mm address...'
anoma wallet key gen --alias my-matchmaker --unsafe-dont-encrypt

ANOMA_WALLET_PATH=$(find .anoma/ -name "anoma-internal*" | sort | head -n 1)
ANOMA_WALLET_PATH=$ANOMA_WALLET_PATH/wallet.toml

sed -i 's/xan =/XAN =/g' $ANOMA_WALLET_PATH
anoma client init-account --alias my-matchmaker-account --public-key my-matchmaker --source my-matchmaker

sleep 3
echo 'Starting matchmaker...'
anoma node matchmaker --matchmaker-path libmm_template.so --tx-code-path tx_from_intent.wasm --ledger-address "127.0.0.1:26657" --source my-matchmaker --signing-key my-matchmaker > logs/mmaker.log &
pids+=( $! )

sleep 2
echo 'Subscribe gossip topic...'
anoma client subscribe-topic --node "http://127.0.0.1:26660" --topic "asset_v1" > logs/subscribe.log &
pids+=( $! )


echo 'Running!'
( trap exit SIGINT ; read -r -d '' _ </dev/tty )

echo 'Killing taks...'
for pid in "${pids[@]}"; do
        kill $pid
done

