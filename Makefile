
deploy_parity_kovan:
	docker stack deploy -c docker/parity-compose.yml parity

rinkeby:
	docker stack deploy -c docker/geth-compose.yml geth
