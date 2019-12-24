# Docker ethereum rpc 

Ethereum nodes with automatic subdomain ssl certs. This repo contains a docker compose file that starts the following services:
- nginx proxy with ssl certs per subdomain/service that needs it
- Goerli and Rinkeby tesnets. Additonal networks can be added by adding new services and new DNS subdomains `A` records.
- Grafana service that monitors the ethereum nodes

# Installation

Dependencies:
- `docker swarm` or `docker-compose`
- `make`

# Usage
### DNS records
Set the DNS `A` record for the subdomains that match the service names such as `goerli`, `rinkeby`, and `grafana` .

### Running

```
make # to get

# Follow the promps. Make sure to include the ports that nginx needs to access:
domain to register: sebas.tech
subdomains to register sperate by a space. specify atleast one: goerli:8545 rinkeby:8545
email for ssl certificate (default noreply@gmail.com):
MAKE: Done with config

# Or you can run to include grafana
make monitoring-up
domain to register: sebas.tech
subdomains to register sperate by a space. specify atleast one: goerli:8545 rinkeby:8545 grafana:3000
email for ssl certificate (default noreply@gmail.com):
MAKE: Done with config

make down # to bring down the docker stack
