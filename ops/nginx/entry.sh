#!/bin/bash

# Set default variables
domain="${DOMAIN_URL:-localhost}"
email="${EMAIL:-noreply@gmail.com}"
subdomains="${SUBDOMAINS}"

echo "
USING ENVVARS:
domain=$domain
email=$email
subdomains=$subdomains
"

# Setup SSL Certs
letsencrypt=/etc/letsencrypt/live
servers=/etc/nginx/servers;
devcerts=$letsencrypt/localhost
mkdir -p $devcerts
mkdir -p /etc/certs
mkdir -p /var/www/letsencrypt
mkdir -p $servers

if [[ "$domain" == "localhost" && ! -f "$devcerts/privkey.pem" ]]
then
  echo "Developing locally, generating self-signed certs"
  openssl req -x509 -newkey rsa:4096 -keyout $devcerts/privkey.pem -out $devcerts/fullchain.pem -days 365 -nodes -subj '/CN=localhost'
fi

for sub in $subdomains; do
  echo "SUB: $sub"
  if [[ ! -f "$letsencrypt/$sub.$domain/privkey.pem" ]]
  then
    echo "Couldn't find certs for $sub.$domain, using certbot to initialize those now.."
    certbot certonly --standalone -m $email --agree-tos --no-eff-email -d $sub.$domain -n
    if [[ ! $? -eq 0 ]] 
    then
      echo "ERROR"
      echo "Sleeping to not piss off certbot"
      sleep 9999 # FREEZE! Don't pester eff & get throttled
    fi
  fi
done

for sub in $subdomains; do
  DEFAULT_PORT=8545
  cat - > "${servers}/${sub}.conf" <<EOF
server {
  listen  80;
  server_name $sub.$DOMAIN_URL;
  location / {
    return 301 https://\$host\$request_uri;
  }
}

server {
  listen  443 ssl;
  ssl_certificate       /etc/letsencrypt/live/$sub.$DOMAIN_URL/fullchain.pem;
  ssl_certificate_key   /etc/letsencrypt/live/$sub.$DOMAIN_URL/privkey.pem;
  server_name $sub.$DOMAIN_URL;
  location / {
		proxy_pass "http://$sub:8545";
  }
}
EOF
done

# Hack way to implement variables in the nginx.conf file

# periodically fork off & see if our certs need to be renewed
function renewcerts {
  while true
  do
    echo -n "Preparing to renew certs... "
    if [[ -d "/etc/letsencrypt/live/$domain" ]]
    then
      echo -n "Found certs to renew for $domain... "
      certbot renew --webroot -w /var/www/letsencrypt/ -n
      echo "Done!"
    fi
    sleep 48h
  done
}

if [[ "$domain" != "localhost" ]]
then
  echo "Forking renewcerts to the background..."
  renewcerts &
fi

sleep 3 # give renewcerts a sec to do it's first check

echo "Entrypoint finished, executing nginx..."; echo
exec nginx