#!/bin/bash

main () {
    if [ -f /initialization ] && [ `cat /initialization` == "1" ] ; then
        /sbin/tini -- /usr/local/bin/start_ipfs daemon --migrate=true
    else
        ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["sasquatch.network", "*"]'
        ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["GET"]'
        ipfs config --json API.HTTPHeaders.Access-Control-Allow-Credentials '["true"]'
        echo "1" > /initialization
    fi
}

main "$@"
