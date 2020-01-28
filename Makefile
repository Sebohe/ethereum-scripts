gethVersion=v1.9.9
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

config:
	@read -p 'Domain to register: ' bridge; \
		echo "DOMAIN_URL="$$bridge > config
	@read -p 'Subdomains to register sperate by a space. Specify atleast one: ' email; \
		echo "SUBDOMAINS="$$email >> config
	@read -p 'Email for SSL certificate (default noreply@gmail.com): ' email; \
		echo "CERTBOT_EMAIL="$$email >> config
	@touch $(flags)/$@
	@echo "MAKE: Done with $@"
	@echo

deploy: config nginx geth
	GETH_IMAGE=ethereum/client-go:$(gethVersion) \
	NGINX_IMAGE=$(nginx) \
	DOMAIN_URL=$(shell cat config | grep DOMAIN_URL | cut -f2 -d=) \
	EMAIL=$(shell cat config | grep CERTBOT_EMAIL | cut -f2 -d=) \
	SUBDOMAINS='$(shell cat config | grep SUBDOMAINS | cut -f2 -d=)' \
	docker stack deploy -c ops/ethereums-testnets.yml $(project)

monitoring-up: config nginx geth
	GETH_IMAGE=ethereum/client-go:$(gethVersion) \
	NGINX_IMAGE=$(nginx) \
	DOMAIN_URL=$(shell cat config | grep DOMAIN_URL | cut -f2 -d=) \
	EMAIL=$(shell cat config | grep CERTBOT_EMAIL | cut -f2 -d=) \
	SUBDOMAINS='$(shell cat config | grep SUBDOMAINS | cut -f2 -d=)' \
	docker stack deploy \
	-c ops/ethereums-testnets.yml \
	-c ops/testnets-minitoring.yml $(project)

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
