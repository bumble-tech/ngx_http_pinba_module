#!/bin/bash

set -e

DIR=$(pwd)

NGINX_BINARY="${DIR}/build/install/sbin/nginx"

if [[ ! -x ${NGINX_BINARY} ]]; then
    echo "Nginx binary ${NGINX_BINARY} is missing, you need to build it before run tests."
    exit 1
fi

if [[ ! -x "$(command -v prove)" ]]; then
    echo "Prove tool is missing, you need to install it before run tests."
    exit 2
fi

TEST_NGINX_BINARY=${NGINX_BINARY} prove -v ./t
