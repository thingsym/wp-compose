#!/usr/bin/env bash
# Usage: bash command/setup-mkcert.sh

# Copy mkcert root keys in docker container to your PC.
docker-compose cp wordpress:/root/.local/share/mkcert ./src

# Add trusted-cert to System.keychain.
security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./src/mkcert/rootCA.pem
