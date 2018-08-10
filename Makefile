
deploy_parity_kovan:
	docker stack deploy -c docker/parity-compose.yml parity

deploy_geth_rinkeby:
	docker stack deploy -c docker/geth-compose.yml geth
