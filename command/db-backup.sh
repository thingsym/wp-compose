#!/usr/bin/env bash
# Usage: bash command/db-backup.sh

shopt -s expand_aliases

alias docker-wp='docker run -it --rm --volumes-from $(docker-compose --project-name `echo $(pwd) | awk -F "/" '"'"'{ print $NF }'"'"'` ps -q wordpress) --network container:$(docker-compose --project-name `echo $(pwd) | awk -F "/" '"'"'{ print $NF }'"'"'` ps -q wordpress) wordpress:cli'

docker-wp db export /var/www/backup/backup-`date +%Y%m%d%H%M%S`.sql
