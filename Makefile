
rinkeby:
	docker stack deploy -c docker/geth-compose.yml geth

kovan:
	docker stack deploy -c docker/parity-compose.yml kovan

aragon:
	docker stack deploy -c docker/aragon-compose.yml aragon
ipfs:
	docker image pull ipfs/go-ipfs:v0.4.17
	docker stack deploy -c docker/ipfs.yml ipfs
