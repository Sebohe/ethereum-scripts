
deploy_parity_kovan:
	docker stack deploy -c docker/parity-compose.yml parity

rinkeby:
	docker stack deploy -c docker/geth-compose.yml geth

aragon-ipfs-rinkeby:
	docker stack deploy -c docker/aragon-rinkeby-ipfs.yml aragon

ipfs:
	docker image pull ipfs/go-ipfs:v0.4.17
	docker stack deploy -c docker/ipfs.yml ipfs
