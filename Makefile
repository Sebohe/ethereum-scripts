gethVersion=v1.9.8


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

eth-testnets:
	sed -i 's|%%GETH_VERSION%%|$(gethVersion)|g' ./ops/geth.Dockerfile
	docker build -f ./docker/geth.Dockerfile -t sebohe/client-go:$(gethVersion) .
	sed -i 's|$(gethVersion)|%%GETH_VERSION%%|g' ./ops/geth.Dockerfile
	GETH_VERSION=$(gethVersion) \
		docker stack deploy testners -f docker/ethereums-testnets.yml -d
