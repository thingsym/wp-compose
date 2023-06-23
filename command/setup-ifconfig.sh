#!/usr/bin/env bash
# Usage: bash command/setup-ifconfig.sh

if [ -f ./.env ]; then
  source ./.env
fi

ifconfig lo0 alias ${LOOPBACK_IP} netmask 0xff000000
