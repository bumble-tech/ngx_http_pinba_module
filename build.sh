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

cd ${DIR}/build/nginx

./configure --prefix=${DIR}/build/install --add-module=${DIR} --with-debug

make

make install
