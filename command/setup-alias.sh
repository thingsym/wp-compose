#!/usr/bin/env bash
# Usage: bash command/setup-alias.sh

if [ -f ./.env ]; then
  source ./.env
fi

echo -e "# Inserted by the wp-compose script" >> ~/.zshrc
echo -e $'alias docker-wp=\'docker run -it --rm --volumes-from $(docker compose --project-name `echo $(pwd) | awk -F "/" \'"\'"\'{ print $NF }\'"\'"\'` ps -q wordpress) --network container:$(docker compose --project-name `echo $(pwd) | awk -F "/" \'"\'"\'{ print $NF }\'"\'"\'` ps -q wordpress) wordpress:cli\'' >> ~/.zshrc

source ~/.zshrc
