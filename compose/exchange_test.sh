anoma wallet key gen --alias alberto --unsafe-dont-encrypt

ANOMA_WALLET_PATH=$(find .anoma/ -name "anoma-internal*" | sort | head -n 1)
ANOMA_WALLET_PATH=$ANOMA_WALLET_PATH/wallet.toml

sed -i 's/xan =/XAN =/g' $ANOMA_WALLET_PATH
sed -i 's/eth =/ETH =/g' $ANOMA_WALLET_PATH
sed -i 's/btc =/BTC =/g' $ANOMA_WALLET_PATH

anoma client init-account --alias alberto-account --public-key alberto --source alberto

anoma wallet  key gen --alias christel --unsafe-dont-encrypt
anoma client init-account --alias christel-account --public-key christel --source christel

anoma wallet key gen --alias bertha --unsafe-dont-encrypt
anoma client init-account --alias bertha-account --public-key bertha --source bertha

anoma wallet key gen --alias my-matchmaker --unsafe-dont-encrypt
anoma client init-account --alias my-matchmaker-account --public-key my-matchmaker --source my-matchmaker

anoma client transfer --source faucet --target alberto-account --signer alberto-account --token BTC --amount 1000
anoma client transfer --source faucet --target bertha-account --signer bertha-account --token ETH --amount 1000
anoma client transfer --source faucet --target christel-account --signer christel-account --token XAN --amount 1000


export ALBERTO=$(anoma wallet address find --alias alberto-account | cut -c 28- | tr -d '\n')
export CHRISTEL=$(anoma wallet address find --alias christel-account | cut -c 28- | tr -d '\n')
export BERTHA=$(anoma wallet address find --alias bertha-account | cut -c 28- | tr -d '\n')
export XAN=$(anoma wallet address find --alias XAN | cut -c 28- | tr -d '\n')
export BTC=$(anoma wallet address find --alias BTC | cut -c 28- | tr -d '\n')
export ETH=$(anoma wallet address find --alias ETH | cut -c 28- | tr -d '\n')

echo '[{"addr":"'$ALBERTO'","key":"'$ALBERTO'","max_sell":"70","min_buy":"100","rate_min":"2","token_buy":"'$XAN'","token_sell":"'$BTC'"}]' > intent.A.data

echo '[{"addr":"'$BERTHA'","key":"'$BERTHA'","max_sell":"300","min_buy":"50","rate_min":"0.7","token_buy":"'$BTC'","token_sell":"'$ETH'"}]' > intent.B.data

echo '[{"addr":"'$CHRISTEL'","key":"'$CHRISTEL'","max_sell":"200","min_buy":"20","rate_min":"0.5","token_buy":"'$ETH'","token_sell":"'$XAN'"}]' > intent.C.data

# run gossip
anoma node gossip --rpc "127.0.0.1:26660"

anoma node matchmaker --matchmaker-path libmm_token_exch.so --tx-code-path tx_from_intent.wasm --ledger-address "127.0.0.1:26657" --source my-matchmaker --signing-key my-matchmaker

anoma client subscribe-topic --node "http://127.0.0.1:26660" --topic "asset_v1"

anoma client intent --data-path intent.A.data --topic "asset_v1" --signing-key alberto --node "http://127.0.0.1:26660"
anoma client intent --data-path intent.B.data --topic "asset_v1" --signing-key bertha --node "http://127.0.0.1:26660"
anoma client intent --data-path intent.C.data --topic "asset_v1" --signing-key christel --node "http://127.0.0.1:26660"

anoma client balance --owner alberto-account
anoma client balance --owner bertha-account
anoma client balance --owner christel-account

