CREATE TABLE reviews(
    title character varying(20) primary key default ''::character varying not null,
    date integer,
    grade character varying(20) default ''::character varying not null,
    review character varying(20) default ''::character varying not null 
);
