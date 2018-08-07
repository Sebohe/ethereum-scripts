
deploy_parity_kovan:
	docker stack deploy -c docker/parity-compose.yml parity
