FROM postgres:9.6

WORKDIR /docker-entrypoint-initdb.d/

RUN apt-get update 
RUN apt-get install -y vim 

RUN mkdir -p /var/sql/schema
RUN mkdir -p /var/sql/sample

#RUN chmod 700 /var/log/postgresql/init_error.log

#RUN [ -e /var/log/postgresql/init_error.log ] && rm /var/log/postgresql/init_error.log

COPY 000-pgpass.conf /docker-entrypoint-initdb.d/
COPY ./schema/* /var/sql/schema/
COPY ./sample/* /var/sql/sample/
COPY ./script/* ./
