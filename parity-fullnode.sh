#!/usr/bin/env bash
docker service create \
  --name "parity" \
  --mode "global" \
  --mount "type=bind,source=/home/giga/parity,target=/root/parity" \
  --detach \
  parity/parity:v1.11.4 \
  --no-jsonrpc \
  --no-ws  \
  --base-path /root/parity

docker service logs -f parity
