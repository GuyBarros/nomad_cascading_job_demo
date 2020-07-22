#!/bin/bash
set -v

# Generate a 2048 bit RSA Key
openssl genrsa -out keypair.pem 2048

# Export the RSA Public Key to a File
openssl rsa -in keypair.pem -pubout -out publickey.crt

# Exports the Private Key
openssl rsa -in keypair.pem -out private_unencrypted.pem -outform PEM

# convert to PKCS#8
openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in keypair.pem -out pkcs8.key
pwd

# copy files to a shared directory
cp keypair.pem /tmp/shared/keypair.pem
cp publickey.crt /tmp/shared/publickey.crt
cp private_unencrypted.pem /tmp/shared/private_unencrypted.pem
cp pkcs8.key /tmp/shared/pkcs8.key

