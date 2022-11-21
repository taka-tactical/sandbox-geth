#!/bin/sh -e

if ! [ -f /root/.ethereum/static-nodes.json ]; then
  echo "can not run geth: static-nodes.json not found"
  exit 1
fi

geth --datadir /root/.ethereum --syncmode 'full' --networkid 12345 --nodiscover \
  --http --http.addr '0.0.0.0' --http.port "8545" --http.corsdomain '*' --http.vhosts '*' \
  --http.api 'eth,web3,personal,net,admin,debug,miner,txpool' \
  --ws --ws.addr '0.0.0.0' --ws.port "8546" --ws.origins '*' \
  --ws.api 'eth,web3,personal,net,admin,debug,miner,txpool' \
  --allow-insecure-unlock --unlock 0 --password password.txt --mine --miner.threads 1
