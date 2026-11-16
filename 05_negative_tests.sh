#!/bin/bash

echo "=== 1. Tampered certificate ==="
cp server.crt tampered.crt
sed -i '10s/./X/5' tampered.crt
openssl verify -CAfile rootCA.crt tampered.crt

echo "=== 2. Untrusted (wrong) CA ==="
openssl req -x509 -newkey rsa:2048 -nodes -keyout fakeCA.key -out fakeCA.crt -days 30 -subj "/CN=Fake CA"
openssl verify -CAfile fakeCA.crt server.crt

echo "=== 3. Expired certificate (date set to 1 Jan 2030) ==="
openssl verify -CAfile rootCA.crt -attime 1893456000 server.crt
