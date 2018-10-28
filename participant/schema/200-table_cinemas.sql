CREATE TABLE cinemas(
    place character varying(20) primary key default ''::character varying not null,
    movie character varying(20) default ''::character varying not null,
    start integer
);
