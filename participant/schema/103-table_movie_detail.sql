CREATE TABLE movie_detail(
    MID integer primary key,
    director character varying(20) default ''::character varying not null,
    genre character varying(10) default ''::character varying not null,
    year integer
);
