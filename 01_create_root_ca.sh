#!/bin/bash

set -e
openssl version

openssl genrsa -aes256 -out rootCA.key 4096

openssl req -x509 -new -key rootCA.key -sha256 -days 3650 -out rootCA.crt \
  -subj "/C=IN/ST=Rajasthan/O=SKIT Lab CA/CN=SKIT Lab Root CA"
openssl x509 -in rootCA.crt -noout -subject -issuer -dates -ext basicConstraints
