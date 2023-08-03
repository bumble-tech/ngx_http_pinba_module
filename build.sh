#!/bin/bash

NGINX_VERSION="1.22.1"

set -e

DIR=$(pwd)

mkdir -p ${DIR}/build
mkdir -p ${DIR}/build/install

if [[ ! -d ${DIR}/build/nginx ]]; then
    wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O ${DIR}/build/nginx-${NGINX_VERSION}.tar.gz
    tar -xzvf ${DIR}/build/nginx-${NGINX_VERSION}.tar.gz -C ${DIR}/build
    mv ${DIR}/build/nginx-${NGINX_VERSION} ${DIR}/build/nginx
fi

if [[ ! -d ${DIR}/build/njs ]]; then
    git clone https://github.com/nginx/njs.git ${DIR}/build/njs
fi

cd ${DIR}/build/nginx

NJS_OPENSSL=NO ./configure \
    --prefix=${DIR}/build/install \
    --add-module=${DIR} \
    --add-module=${DIR}/build/njs/nginx \
    --with-debug

make

make install
