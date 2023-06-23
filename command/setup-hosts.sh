#!/usr/bin/env bash
# Usage: bash command/setup-hosts.sh

if [ -f ./.env ]; then
  source ./.env
fi

echo -e "# Inserted by the wp-compose script" >> /etc/hosts
echo -e "${LOOPBACK_IP}    ${DOMAIN}" >> /etc/hosts
