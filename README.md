# geschke/powerdns-server

[![Image Size](https://images.microbadger.com/badges/image/geschke/powerdns-server.svg)](https://microbadger.com/images/geschke/powerdns-server)
[![Version](https://images.microbadger.com/badges/version/geschke/powerdns-server.svg)](https://microbadger.com/images/geschke/powerdns-server)
[![Docker Automated build](https://img.shields.io/docker/cloud/build/geschke/powerdns-server)](https://hub.docker.com/r/geschke/powerdns-server)


This is a Docker image with PowerDNS server.

## Usage

To download the image run

    docker pull geschke/powerdns-server

## Configuration

**Environment Configuration:**

* MySQL connection settings
  * `MYSQL_HOST=localhost`
  * `MYSQL_USER=dbuser`
  * `MYSQL_PASS=<empty>`
  * `MYSQL_DB=powerdns`

  
* Skip modifying these parameters by setting PDNS_AUTOCONFIG to "true".


## Usage example

tbd

## Credits


This image is based on the official Ubuntu image, the Ubuntu PowerDNS packages and uses
some snippets of the following Docker images:

* https://github.com/psi-4ward/docker-powerdns
* https://github.com/docker-library/mariadb/blob/master/10.4/docker-entrypoint.sh

Thank you all!


