FROM ubuntu:focal

LABEL maintainer="Ralf Geschke <ralf@kuerbis.org>"

LABEL last_changed="2020-18-01"


# necessary to set default timezone Etc/UTC
ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update \
        && apt-get -y upgrade \
        && apt-get -y dist-upgrade \
        && apt-get install -y ca-certificates \
        && apt-get install -y --no-install-recommends \
        && apt-get install -y locales \
        && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
        && apt-get install -y curl git gnupg


#RUN apt update    

# testing Ubuntu 20.04 focal, in case of errors, switch to 18.04 again

RUN apt install -y pdns-server pdns-backend-sqlite3 pdns-backend-mysql mysql-client

# bind etc., remove later! 
RUN apt install -y dnsutils iproute2 sqlite3

#  docker run -it --publish 192.168.10.101:53:53/udp --env PDNS_BACKEND=mysql --env MYSQL_HOST=moabit.geschke.net --env MYSQL_USER=powerdnsuser --env MYSQL_PASSWORD=E7BlCALo3ieX4XfLmjL48rBcvqdwQmlX --env PDNS_API_KEY=euNg0ahB --publish 8081:8081  --name pdns pdns


# docker run -it --publish 192.168.10.101:53:53/udp --env PDNS_BACKEND=sqlite3 --env PDNS_API_KEY=euNg0ahB --mount type=bind,source=/home/geschke/pdns/img/data/pdns.db,target=/var/lib/powerdns/pdns.db --publish 8081:8081  --name pdns pdns



EXPOSE 8081
EXPOSE 53/udp
EXPOSE 53/tcp 


USER root
RUN mkdir -p /app
COPY entrypoint.sh /app/entrypoint.sh
COPY wait-for-it.sh /app/wait-for-it.sh
RUN chmod 755 /app/entrypoint.sh && chmod 755 /app/wait-for-it.sh
RUN chown -R pdns:pdns /app

#USER pdns 
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["app:start"]
