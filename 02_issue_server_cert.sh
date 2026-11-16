#!/bin/bash

set -e
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -subj "/C=IN/O=SKIT Lab/CN=localhost"

openssl x509 -req -in server.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial \
  -out server.crt -days 365 -sha256 -extfile server.ext
openssl verify -CAfile rootCA.crt server.crt
openssl x509 -in server.crt -noout -subject -issuer -dates -ext subjectAltName,basicConstraints
