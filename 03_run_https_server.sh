#!/bin/bash

openssl s_server -accept 8443 -cert server.crt -key server.key -WWW
