

pullGeth:
	docker pull ethereum/client-go:stable

pullParity:
	docker pull parity/parity:stable

pullIPFS:
	docker pull ipfs/go-ipfs:v0.4.18

rinkeby: pullGeth
	docker stack deploy -c docker/geth-compose.yml geth

kovan: pullParity
	docker stack deploy -c docker/parity-compose.yml kovan

main: pullParity
	docker stack deploy -c docker/mainnet-compose.yml parity

aragon: pullGeth
	docker stack deploy -c docker/aragon-compose.yml aragon

ipfs: pullIPFS
	docker stack deploy -c docker/ipfs.yml ipfs
