# Forked from 
FROM ubuntu:14.04
MAINTAINER Onur Uyar "me@onuruyar.com"

# Set locale
RUN export LANGUAGE=en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN export LC_ALL=en_US.UTF-8
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN dpkg-reconfigure locales

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq -y update && apt-get -y -q install curl
RUN curl -s https://alioth.debian.org/scm/loggerhead/pkg-postgresql/postgresql-common/trunk/download/head:/apt.postgresql.org.s-20130224224205-px3qyst90b3xp8zj-1/apt.postgresql.org.sh | bash
RUN apt-get -qq -y update && apt-get install -y -q postgresql-9.3 postgresql-contrib-9.3 postgresql-9.3-plv8 postgresql-9.3-postgis-2.1 libpq-dev sudo

# /etc/ssl/private can't be accessed from within container for some reason
# (@andrewgodwin says it's something AUFS related)
RUN mkdir /etc/ssl/private-copy; mv /etc/ssl/private/* /etc/ssl/private-copy/; rm -r /etc/ssl/private; mv /etc/ssl/private-copy /etc/ssl/private; chmod -R 0700 /etc/ssl/private; chown -R postgres /etc/ssl/private

ADD postgresql.conf /etc/postgresql/9.3/main/postgresql.conf
ADD pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

VOLUME ["/var/lib/postgresql"]
EXPOSE 5432
CMD ["/usr/local/bin/run"]

