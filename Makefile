

pullGeth:
	docker pull ethereum/client-go:stable

pullParity:
	docker pull parity/parity:stable

rinkeby: pullGeth
	docker stack deploy -c docker/geth-compose.yml geth

kovan: pullParity
	docker stack deploy -c docker/parity-compose.yml kovan

main: pullParity
	docker stack deploy -c docker/mainnet-compose.yml parity

aragon: pullGeth
	docker stack deploy -c docker/aragon-compose.yml aragon

ipfs:
	docker stack deploy -c docker/ipfs.yml ipfs
