#!/usr/bin/env bash
# Usage: bash command/wp-build-testdata.sh

shopt -s expand_aliases

alias docker-wp='docker run -it --rm --volumes-from $(docker compose --project-name `echo $(pwd) | awk -F "/" '"'"'{ print $NF }'"'"'` ps -q wordpress) --network container:$(docker compose --project-name `echo $(pwd) | awk -F "/" '"'"'{ print $NF }'"'"'` ps -q wordpress) wordpress:cli'

if [ -f ./.env ]; then
  source ./.env
fi

docker-wp --path=/var/www/html config create --dbname=${WORDPRESS_DB_NAME:-wordpress} --dbuser=${WORDPRESS_DB_USER:-root} --dbpass=${WORDPRESS_DB_PASSWORD:-root} --dbhost=${WORDPRESS_DB_HOST:-database} --dbprefix=${WORDPRESS_TABLE_PREFIX:-wp_} --dbcharset=${WORDPRESS_DBCHARSET:-utf8mb4} --dbcollate=${WORDPRESS_DBCOLLATE:-utf8mb4_general_ci} --force
docker-wp --path=/var/www/html core install --url=https://${DOMAIN:-localhost} --title='test' --admin_user=admin --admin_password=admin --admin_email=admin@example.com

docker exec -it $(docker compose --project-name `echo $(pwd) | awk -F "/" '{ print $NF }'` ps -q wordpress) sh -c 'curl https://raw.githubusercontent.com/WPTRT/theme-unit-test/master/themeunittestdata.wordpress.xml -o themeunittestdata.wordpress.xml' && \
docker-wp --path=/var/www/html plugin install wordpress-importer --activate && \
docker-wp --path=/var/www/html import themeunittestdata.wordpress.xml --authors=create && \
docker-wp --path=/var/www/html plugin deactivate wordpress-importer && \
docker exec -it $(docker compose --project-name `echo $(pwd) | awk -F "/" '{ print $NF }'` ps -q wordpress) sh -c 'rm themeunittestdata.wordpress.xml'
