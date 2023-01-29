# WP Compose

**WP Compose** is WordPress development environment based on the docker environment. You can easily launch WordPress development environment as localhost. Optimized for ARM based Mac (Apple Chip).

In addition, WP Compose for development can launch a **unit test container** that you can build your themes or plugins and run unit test.

The main features of WP Compose include use of command line tool **WP-CLI**, HTTPS support by **mkcert**, mail test support by **MailHog**.

You can also launch multiple containers using Local Loopback Address and domains other than localhost.

## Requirements

We recommend using Docker Desktop.

* ARM based Mac (Apple Chip)
* Docker version 20.10.x or later
* Docker Compose version v2.13.x or later

## Preparation for WP Compose

### Install docker-wp commnad as alias

The **docker-wp** command is a shortcut that specifies the launched WordPress container. It's usually a long parameter with a docker command, but docker-wp command works just like `wp`.

Installation is as follows:

#### 1. Open .zshrc

```
vi ~/.zshrc
```

#### 2. Add alias

```
alias docker-wp='docker run -it --rm --volumes-from $(docker-compose --project-name `echo $(pwd) | awk -F "/" '"'"'{ print $NF }'"'"'` ps -q wordpress) --network container:$(docker-compose --project-name `echo $(pwd) | awk -F "/" '"'"'{ print $NF }'"'"'` ps -q wordpress) wordpress:cli'
```

#### 3. Reload .zshrc

```
source ~/.zshrc
```

#### 4. Check if the added command is included in the alias list.

```
alias
```

#### 5. After launching WordPress container

After launching WordPress container, check the following commands. Works the same as the wp command.

```
docker-wp help
```

## Getting Started

WP Compose has two uses. One is to simply Acsess a WordPress Site. The other adds a build and unit test environment container for development. Also you can launch multiple containers using domains.

* [Launch localhost (127.0.0.1)](#-launch-localhost-127001)
* [Launch localhost (127.0.0.1) with unit test container](#-launch-localhost-127001-with-unit-test-container)
* [Launch multiple containers using domains](#-launch-multiple-containers-using-domains)

### Launch localhost (127.0.0.1)

#### 1. Launch Docker containers

Builds, (re)creates, starts, and attaches to containers for WordPress development environment. Docker Compose configuration file uses **docker-compose.yml**.

```
cd wp-compose-x.x.x
docker-compose up -d
```

#### 2. Set up mkcert for HTTPS (just once)

Now you need to add the mkcert root keys to your system key chain:

for Mac

```
# Copy mkcert root keys in docker container to your PC.
docker-compose cp wordpress:/root/.local/share/mkcert ./src

# Add trusted-cert to System.keychain.
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./src/mkcert/rootCA.pem
```

You can check cert name as `mkcert root@buildkitsandboxkeychain` through Keychain Access.app

#### 3. Create WordPress config

```
docker-wp --path=/var/www/html config create --dbname=wordpress --dbuser=root --dbpass=root --dbhost=database --dbprefix=wp_ --dbcharset=utf8mb4 --dbcollate=utf8mb4_general_ci --force
```

#### 4. Install WordPress

```
docker-wp --path=/var/www/html core install --url='https://localhost' --title='test' --admin_user=admin --admin_password=admin --admin_email=admin@example.com
```

#### 5. Acsess a WordPress Site

* Acsess WordPress site at [https://localhost](https://localhost)
* Access WordPress dashboard at [https://localhost/wp-admin](https://localhost/wp-admin)
* Access MailHog web UI at [http://localhost:8025](http://localhost:8025)

#### Start/Stop containers

```
docker-compose start
```

```
docker-compose stop
```

#### Delete containers with volumes

```
docker-compose down -v
```

Or added remove Docker Image

```
docker-compose down -v --rmi all
```

### Launch localhost (127.0.0.1) with unit test container

#### 1. Launch Docker containers

Builds, (re)creates, starts, and attaches to containers for WordPress development environment. Docker Compose configuration file uses **docker-compose-develop.yml**.

**Note**: Always pass the **docker-compose-develop.yml** compose file as a parameter to the docker compose command. `-f docker-compose-develop.yml`

```
cd wp-compose-x.x.x
docker-compose -f docker-compose-develop.yml up -d
```

#### 2. Set up mkcert for HTTPS (just once)

Now you need to add the mkcert root keys to your system key chain:

for Mac

```
# Copy mkcert root keys in docker container to your PC.
docker-compose cp wordpress:/root/.local/share/mkcert ./src

# Add trusted-cert to System.keychain.
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./src/mkcert/rootCA.pem
```

You can check cert name as `mkcert root@buildkitsandboxkeychain` through Keychain Access.app

#### 3. Create WordPress config

```
docker-wp --path=/var/www/html config create --dbname=wordpress --dbuser=root --dbpass=root --dbhost=database --dbprefix=wp_ --dbcharset=utf8mb4 --dbcollate=utf8mb4_general_ci --force
```

#### 4. Install WordPress

```
docker-wp --path=/var/www/html core install --url='https://localhost' --title='test' --admin_user=admin --admin_password=admin --admin_email=admin@example.com
```

#### 5. Acsess a WordPress Site

* Acsess WordPress site at [https://localhost](https://localhost)
* Access WordPress dashboard at [https://localhost/wp-admin](https://localhost/wp-admin)
* Access MailHog web UI at [http://localhost:8025](http://localhost:8025)

#### Start/Stop containers

```
docker-compose -f docker-compose-develop.yml start
```

```
docker-compose -f docker-compose-develop.yml stop
```

#### Delete containers with volumes

```
docker-compose -f docker-compose-develop.yml down -v
```

Or added remove Docker Image

```
docker-compose -f docker-compose-develop.yml down -v --rmi all
```

#### Access the console inside the unit test container

Access the console with Your SERVICE name.

```
docker-compose exec wordpress_unittest /bin/bash
```

Or access the console with Your Container NAME.

```
docker exec -it wp-compose--localhost--wordpress-unittest /bin/bash
```

For developer,

* [Install and run PHPUnit Unittest inside the unit test container](#-install-and-run-phpunit-unittest-inside-the-unit-test-container)
* [Install and run PHPUnit Unittest via host](#-install-and-run-phpunit-unittest-via-host)

### Launch multiple containers using domains

Only one container can start on localhost. Multiple containers won't start up due to IP address and port conflicts. You can also launch multiple containers using **Local Loopback Address** and **domains** other than localhost.

The following shows launching `wp-compose.test` on IP address `127.56.0.1`.

#### 1. Edit .env

```
cd wp-compose-x.x.x
vi .env
```


#### 2. Set up Local Loopback Address on Network Insterface (each time)

Add a loopback alias.

```
sudo ifconfig lo0 alias 127.56.0.1 netmask 0xff000000
```

Display ifconfig. Check `inet 127.56.0.1 netmask 0xff000000`

```
ifconfig lo0
```

**Note**: This network interface setting is cleared when the PC is stopped, so it must be set each time the PC is started. If you get the following error message when launching containers, the network interface has not been configured.

```
Error response from daemon: Ports are not available: exposing port TCP 127.56.0.1:1025 -> 0.0.0.0:0: listen tcp 127.56.0.1:1025: bind: can't assign requested address
```

To remove the loopback alias:

```
sudo ifconfig lo0 -alias 127.56.0.1 netmask 0xff000000
```

#### 3. Add IP address and domain to hosts (just once)

Add IP address and domain to `/etc/hosts`.

```
sudo vi /etc/hosts
```

```
127.56.0.1    wp-compose.test
```

#### 4. Launch Docker containers

Builds, (re)creates, starts, and attaches to containers for WordPress development environment.

When using the unit test container, pass the **docker-compose-develop.yml** compose file as a parameter to the docker compose command. `-f docker-compose-develop.yml`

```
docker-compose up -d
```

#### 5. Set up mkcert for HTTPS (just once)

Now you need to add the mkcert root keys to your system key chain:

for Mac

```
# Copy mkcert root keys in docker container to your PC.
docker-compose cp wordpress:/root/.local/share/mkcert ./src

# Add trusted-cert to System.keychain.
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./src/mkcert/rootCA.pem
```

You can check cert name as `mkcert root@buildkitsandboxkeychain` through Keychain Access.app

#### 6. Create WordPress config

```
docker-wp --path=/var/www/html config create --dbname=wordpress --dbuser=root --dbpass=root --dbhost=database --dbprefix=wp_ --dbcharset=utf8mb4 --dbcollate=utf8mb4_general_ci --force
```

#### 7. Install WordPress

```
docker-wp --path=/var/www/html core install --url='https://wp-compose.test' --title='test' --admin_user=admin --admin_password=admin --admin_email=admin@example.com
```

#### 8. Acsess a WordPress Site

* Acsess WordPress site at [https://wp-compose.test](https://wp-compose.test)
* Access WordPress dashboard at [https://wp-compose.test/wp-admin](https://wp-compose.test/wp-admin)
* Access MailHog web UI at [http://wp-compose.test:8025](http://wp-compose.test:8025)

#### Start/Stop containers

```
docker-compose start
```

```
docker-compose stop
```

#### Delete containers with volumes

```
docker-compose down -v
```

Or added remove Docker Image

```
docker-compose down -v --rmi all
```

## Coustomize WP Compose settings (.env)

You can set default values for environment variables referenced in your Compose file in your **.env** file.

```
# Local Loopback Address from 127.0.0.1 to 127.255.255.255
LOOPBACK_IP=127.0.0.1

# If you change default DOMAIN from localhost, set domain to /etc/hosts.
DOMAIN=localhost

# https://hub.docker.com/_/wordpress
WORDPRESS_IMAGE_TAG=latest

# https://hub.docker.com/_/mariadb
MARIADB_IMAGE_TAG=latest

MYSQL_ROOT_PASSWORD=root

WORDPRESS_DB_HOST=database
WORDPRESS_DB_NAME=wordpress
WORDPRESS_DB_USER=root
WORDPRESS_DB_PASSWORD=root
WORDPRESS_TABLE_PREFIX=wp_
WORDPRESS_DEBUG=true
```

* `LOOPBACK_IP` (required) Local Loopback Address from 127.0.0.1 to 127.255.255.255 (default: `127.0.0.1`)
* `DOMAIN` (required) Domain name (default: `localhost`)
* `WORDPRESS_IMAGE_TAG` (required) WordPress docker image tag name. See https://hub.docker.com/_/wordpress (default: `latest`)
* `MARIADB_IMAGE_TAG` (required) MariaDB docker image tag name. See https://hub.docker.com/_/mariadb (default: `latest`)
* `MYSQL_ROOT_PASSWORD` database root password (default: `root`)
* `WORDPRESS_DB_HOST` database host (default: `database`)
* `WORDPRESS_DB_NAME` name of database (default: `wordpress`)
* `WORDPRESS_DB_USER` database user name (default: `root`)
* `WORDPRESS_DB_PASSWORD` database password (default: `root`)
* `WORDPRESS_TABLE_PREFIX` database prefix (default: `wp_`)
* `WORDPRESS_DEBUG` debug mode (default: `true`/ value: `true` | `false`)

## File layout

Directory structure of the WP Compose is as follows.

* .env (Docker Compose environment variable file)
* CHANGELOG.md
* Dockerfile (stores Dockerfile files)
	* wordpress (Dockerfile for WordPress image)
	* wordpress-develop (Dockerfile for unit test image)
* LICENSE
* README.md
* database (stores Database data failes. synchronize to `/var/lib/mysql` inside Database container. Create automatically when Launch Database container. If it already exists, don't create it.)
* docker-compose-develop.yml (Compose specification for localhost with unit test container)
* docker-compose.yml (Compose specification for localhost)
* src (stores source files)
	* backup (stores backup file. synchronize to `/var/www/backup` inside WordPress container.)
	* import (stores import file. synchronize to `/var/www/import` inside WordPress container.)
	* mkcert (stores SSL certificate files. Create when you run the command)
	* plugins (stores your plugins to bind mounts. Required volume configuration in the Docker compose file)
	* themes (stores your themes to bind mounts. Required volume configuration in the Docker compose file)
* wordpress (stores WordPress failes. synchronize to `/var/www/html` inside WordPress container. Create automatically when Launch WordPress container. If it already exists, don't create it.)

## Tips for WordPress theme/plugin developer

### How do you develop themes/plugins with WP Compose?

There are two ways to put the themes/plugins you are developing.

One is to put its in the `/src/themes` or `/src/plugins` folder and mount it to WordPress container.

Set volumes in docker-compose.yml.

```
volumes:
	# Set the path of the theme or plugin you are developing.
	- ./src/themes/YOUR_THEME:/var/www/html/wp-content/plugins/YOUR_THEME
	- ./src/plugins/YOUR_PLUGIN:/var/www/html/wp-content/plugins/YOUR_PLUGIN
```

Another is to put its in the `wp-content/themes` or `wp-content/plugins` folder inside WordPress container.

### Export SQL file using  WP-CLI

```
docker-wp db export /var/www/backup/backup-`date +%Y%m%d%H%M%S`.sql
```

### Import SQL file

```
docker-wp --path=/var/www/html db reset --yes && docker-wp --path=/var/www/html db import /var/www/import/wordpress.sql
```

### Import unit test data

Download unit test data from https://github.com/WPTT/theme-test-data and import.

```
docker exec -it $(docker-compose --project-name `echo $(pwd) | awk -F "/" '{ print $NF }'` ps -q wordpress) sh -c 'curl https://raw.githubusercontent.com/WPTRT/theme-unit-test/master/themeunittestdata.wordpress.xml -o themeunittestdata.wordpress.xml' && docker-wp --path=/var/www/html plugin install wordpress-importer --activate && docker-wp --path=/var/www/html import themeunittestdata.wordpress.xml --authors=create && docker-wp --path=/var/www/html plugin deactivate wordpress-importer && docker exec -it $(docker-compose --project-name `echo $(pwd) | awk -F "/" '{ print $NF }'` ps -q wordpress) sh -c 'rm themeunittestdata.wordpress.xml'
```

### Install and run PHPUnit Unittest inside the unit test container

#### 1. Access the console inside the unit test container

Access the console with Your SERVICE name.

```
docker-compose exec [SERVICE name] /bin/bash
```

#### 2. Move your plugin directory

```
cd /var/www/html/wp-content/(themes|plugins)/[Your theme or plugin name]
```

#### 3. Install WordPress test to `/tmp` dir

```
bin/install-wp-tests.sh wordpress_test root root database
```

#### 4. Install PHPUnit and composer dependencies

```
composer install
```

#### 5. Run phpunit

```
composer run phpunit
```

### Install and run PHPUnit Unittest via host


#### 1. Install WordPress test to `/tmp` dir

```
docker-compose exec -w /var/www/html/wp-content/(themes|plugins)/[Your theme or plugin name] bash bin/install-wp-tests.sh wordpress_test root root database
```

#### 2. Install PHPUnit and composer dependencies

```
docker-compose exec -w /var/www/html/wp-content/(themes|plugins)/[Your theme or plugin name] wordpress_unittest composer install
```

#### 3. Run phpunit

```
docker-compose exec -w /var/www/html/wp-content/(themes|plugins)/[Your theme or plugin name] wordpress_unittest composer run phpunit
```

### Why MailHog ?

Root mail on WordPress container is **wordpress@localhost** which is not correct. So the validation will be false and the email will fail to be sent.

If you set a domain other than localhost, you can receive mail with MailHog for development.

Alternatively, if you use root mail for development such as password reset, you can avoid it with the hook below.

```
# From: WordPress <wordpress@localhost> return false on is_email functon.
# See $phpmailer::$validator static function, /wp-includes/pluggable.php:257

function disable_mail_validator( $email ) {
	return true;
}
add_action( 'is_email', 'disable_mail_validator' );
```

## Contribution

Small patches and bug reports can be submitted a issue tracker in Github.

* VCS - Github: [WP Compose](https://github.com/thingsym/wp-compose)

You can also contribute by answering issues on the forums.

* Issues: [https://github.com/thingsym/wp-compose/issues](https://github.com/thingsym/wp-compose/issues)

### Patches and Bug Fixes

Forking on Github is another good way. You can send a pull request.

1. Fork [WP Compose](https://github.com/thingsym/wp-compose) from GitHub repository
2. Create a feature branch: git checkout -b my-new-feature
3. Commit your changes: git commit -am 'Add some feature'
4. Push to the branch: git push origin my-new-feature
5. Create new Pull Request

### Contribute guidlines

If you would like to contribute, here are some notes and guidlines.

* All development happens on the **main** branch, so it is always the most up-to-date
* If you are going to be submitting a pull request, please submit your pull request to the **main** branch
* See about [forking](https://help.github.com/articles/fork-a-repo/) and [pull requests](https://help.github.com/articles/using-pull-requests/)

## Changelog

See CHANGELOG.md

## License

WP Compose is distributed under GPLv2.

## Author

[thingsym](https://github.com/thingsym)

Copyright (c) 2023 thingsym
