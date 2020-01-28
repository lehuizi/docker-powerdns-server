# geschke/powerdns-server

This is a Docker image with PowerDNS server.

## Usage

To download the image run

    docker pull geschke/powerdns-server

## Configuration

**Environment Configuration:**

* MySQL connection settings
  * `MYSQL_HOST=localhost`
  * `MYSQL_USER=root`
  * `MYSQL_PASS=root`
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


