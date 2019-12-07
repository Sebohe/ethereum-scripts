gethVersion=v1.9.8
nginx=sebohe/nginx-eth:latest
project=testnets

flags=.makeFlags
VPATH=$(flags)
$(shell mkdir -p $(flags))

default: deploy

clean:
	rm -rf $(flags)

nginx:
	docker build -f ops/nginx/Dockerfile -t $(nginx) ./ops/nginx

geth:
	docker pull ethereum/client-go:$(gethVersion)
	touch $(flags)/$@

deploy: nginx geth
	GETH_IMAGE=ethereum/client-go:$(gethVersion) \
	DOMAIN_URL="sebas.tech" \
	NGINX_IMAGE=$(nginx) \
	docker stack deploy -c ops/ethereums-testnets.yml $(project)

down:
	docker stack rm $(project)
	docker stack rm dev_$(project)
	while [ -n "`docker network ls --quiet --filter label=com.docker.stack.namespace=$(project)`" ]; do echo -n '.' && sleep 1; done
	@echo
	while [ -n "`docker network ls --quiet --filter label=com.docker.stack.namespace=dev_$(project)`" ]; do echo -n '.' && sleep 1; done
	@echo  "MAKE: Done with $@"
	@echo

r:
	make down && make
