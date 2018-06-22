#!/usr/bin/env bash
docker service create \
  --name "parity" \
  --mode "global" \
  --mount "type=bind,source=/home/giga/ethereum/parity,target=/root/parity" \
  --detach \
  --publish "31245:31245" \
  parity/parity:v1.11.4 \
  --jsonrpc-port=31245 \
  --jsonrpc-interface=0.0.0.0 \
  --jsonrpc-apis=all \
  --no-ws  \
  --base-path /root/parity \
  --cache-size=8192


docker service logs -f parity --raw
