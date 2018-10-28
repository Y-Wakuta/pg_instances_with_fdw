CREATE TABLE nyc_cinemas(
    name character varying(20) primary key default ''::character varying not null,
    title character varying(20) default ''::character varying not null,
    startTime integer
);
