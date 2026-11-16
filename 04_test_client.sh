#!/bin/bash

echo "--- Without trusting the CA (expected: FAIL) ---"
curl https://localhost:8443/index.html || true
echo
echo "--- Trusting the Root CA (expected: page is shown) ---"
curl --cacert rootCA.crt https://localhost:8443/index.html
echo
echo "--- TLS handshake details ---"
openssl s_client -connect localhost:8443 -CAfile rootCA.crt < /dev/null
