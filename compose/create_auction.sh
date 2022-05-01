anomaw address gen --alias alberto-key --unsafe-dont-encrypt

ANOMA_WALLET_PATH=$(find .anoma/ -name "anoma-internal*" | sort | head -n 1)
ANOMA_WALLET_PATH=$ANOMA_WALLET_PATH/wallet.toml

sed -i 's/xan =/XAN =/g' $ANOMA_WALLET_PATH

anomac init-account --source alberto-key --public-key alberto-key --alias alberto-account

anoma client transfer --source faucet --target alberto-account --signer alberto-key --token btc --amount 1
anoma client transfer --source faucet --target alberto-account --signer alberto-key --token kartoffel --amount 142
anoma client update --address alberto-account --code-path /home/daniil/IdeaProjects/anoma5/anoma-docker-testnet/compose/permissive-vp.wasm

echo "Alberto BTC balance:"
anomac balance --token btc --owner alberto-account

echo "Alberto Kartoffel balance:"
anomac balance --token kartoffel --owner alberto-account


anomaw address gen --alias bob-key --unsafe-dont-encrypt
anomac init-account --source bob-key --public-key bob-key --alias bob-account

anoma client transfer --source faucet --target bob-account --signer bob-key --token btc --amount 17
anoma client transfer --source faucet --target bob-account --signer bob-key --token kartoffel --amount 1
anoma client update --address bob-account --code-path /home/daniil/IdeaProjects/anoma5/anoma-docker-testnet/compose/permissive-vp.wasm

echo "Bob BTC balance:"
anomac balance --token btc --owner bob-account

echo "Alberto Kartoffel balance:"
anomac balance --token kartoffel --owner bob-account


export ALBERTO=$(anoma wallet address find --alias alberto-account | cut -c 28- | tr -d '\n')
export BTC=$(anoma wallet address find --alias btc | cut -c 28- | tr -d '\n')
export KTF=$(anoma wallet address find --alias kartoffel | cut -c 28- | tr -d '\n')

NOW=$(date +%s)

START=$(($NOW + 30))
END=$(($NOW + 70))
CLEARANCE=$(($NOW + 260))

echo 'Start: '
echo $(date -d @$START)

echo 'End: '
echo $(date -d @$END)

echo 'Clearance: '
echo $(date -d @$CLEARANCE)


echo '[{"addr":"'$ALBERTO'","create_auction":{"token_sell": "'$KTF'","token_buy": "'$BTC'","amount": "10","auction_start": "'$START'","auction_end": "'$END'", "auction_clearance": "'$CLEARANCE'"}}]' > auction.json


anoma auction-intent --node "http://127.0.0.1:26660" --signing-key alberto-key --data-path auction.json --topic "asset_v1"

########################



