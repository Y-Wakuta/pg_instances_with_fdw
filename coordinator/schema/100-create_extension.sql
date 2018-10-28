CREATE EXTENSION postgres_fdw;
CREATE SERVER foreign_server
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'participant',port '5432',dbname 'participant_db');
CREATE USER MAPPING FOR CURRENT_USER
    SERVER foreign_server
    OPTIONS (user 'postgres',password 'yusuke');
IMPORT FOREIGN SCHEMA public
    FROM SERVER foreign_server INTO public;
