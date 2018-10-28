FROM postgres:9.6

WORKDIR /docker-entrypoint-initdb.d/

RUN apt-get update 
RUN apt-get install -y vim 
RUN apt-get install -y iputils-ping net-tools
RUN apt-get install -y netcat

ENV DOCKERIZE_VERSION v0.5.0

RUN mkdir -p /var/sql/schema
RUN mkdir -p /var/sql/sample

#RUN chmod 700 /var/log/postgresql/init_error.log

#RUN [ -e /var/log/postgresql/init_error.log ] && rm /var/log/postgresql/init_error.log

COPY 000-pgpass.conf /docker-entrypoint-initdb.d/
COPY ./schema/* /var/sql/schema/
COPY ./script/* ./
