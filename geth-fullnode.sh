#!/usr/bin/env bash

docker volume create geth_data

docker service create \
  --name "geth" \
  --mode "global" \
  --mount "type=volume,source=geth_data,destination=/root/.ethereum" \
  --detach \
  ethereum/client-go:v1.8.9 \
  --cache "6096" \
  --rpc \
  --rpcaddr "0.0.0.0" \
  --rpcport "20203" \
  --lightserv "50"

docker service logs -f geth
