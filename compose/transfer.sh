#/usr/bin/bash
anomaw address gen --alias alberto-key --unsafe-dont-encrypt

ANOMA_WALLET_PATH=$(find .anoma/ -name "anoma-internal*" | sort | head -n 1)
ANOMA_WALLET_PATH=$ANOMA_WALLET_PATH/wallet.toml

sed -i 's/xan =/XAN =/g' $ANOMA_WALLET_PATH

anomac init-account --source alberto-key --public-key alberto-key --alias alberto-account

anomaw address gen --alias my-key --unsafe-dont-encrypt
anomac init-account --alias my-account --public-key my-key --source my-key

anoma client transfer --source faucet --target alberto-account --signer alberto-key --token XAN --amount 42
anoma client transfer --source faucet --target my-account --signer my-key --token XAN --amount 24


echo "My account:" 
anomac balance --token XAN --owner my-account
echo "Alberto account:"
anomac balance --token XAN --owner alberto-account


anoma client transfer --source my-account --target alberto-account --signer my-key --token XAN --amount 1

echo "My account:" 
anomac balance --token XAN --owner my-account
echo "Alberto account:"
anomac balance --token XAN --owner alberto-account


anoma client transfer --source my-account --target alberto-account --signer alberto-key --token XAN --amount 1

echo "My account:"
anomac balance --token XAN --owner my-account
echo "Alberto account:"
anomac balance --token XAN --owner alberto-account


echo "Modifying VPs..."
anoma client update --address my-account --code-path my_vp.wasm
anoma client update --address alberto-account --code-path my_vp.wasm

anoma client transfer --source my-account --target alberto-account --signer alberto-key --token XAN --amount 1

echo "My account:"
anomac balance --token XAN --owner my-account
echo "Alberto account:"
anomac balance --token XAN --owner alberto-account

