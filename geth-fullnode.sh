#!/usr/bin/env bash

docker service create \
  --name "geth" \
  --mode "global" \
  --mount "type=bind,source=/home/giga/ethereum,target=/root/.ethereum" \
  --detach \
  ethereum/client-go:latest \
  --cache "6096" \
  --rpc \
  --rpcaddr "0.0.0.0" \
  --rpcport "20203" \
  --lightserv "10"

docker service logs -f geth
