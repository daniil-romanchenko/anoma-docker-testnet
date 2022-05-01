#!/bin/bash

NET_PATH=/home/daniil/IdeaProjects/anoma5/anoma-docker-testnet/compose
FHE_PATH=/home/daniil/IdeaProjects/mk-tfhe-decoupled/build/test

cd $NET_PATH
/home/daniil/IdeaProjects/anoma5/anoma-docker-testnet/compose/start_new_network.sh &

sleep 30

cd $NET_PATH
/home/daniil/IdeaProjects/anoma5/anoma-docker-testnet/compose/create_auction.sh

cd $FHE_PATH
/home/daniil/IdeaProjects/mk-tfhe-decoupled/build/test/generate_bids.sh

sleep 20

cd $NET_PATH
/home/daniil/IdeaProjects/anoma5/anoma-docker-testnet/compose/send_bid_intents.sh

cd $FHE_PATH
/home/daniil/IdeaProjects/mk-tfhe-decoupled/build/test/transfer_keys.sh

sleep 35

cd $NET_PATH
/home/daniil/IdeaProjects/anoma5/anoma-docker-testnet/compose/trigger_calc.sh

sleep 160

cd $FHE_PATH
/home/daniil/IdeaProjects/mk-tfhe-decoupled/build/test/decrypt.sh

sleep 45

cd $NET_PATH
/home/daniil/IdeaProjects/anoma5/anoma-docker-testnet/compose/trigger_clearance.sh


