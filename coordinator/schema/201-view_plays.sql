CREATE VIEW view_plays as
    SELECT 
        c.movie as movie,
        c.place as location,
        c.start as startTime
    FROM cinemas as c
    UNION
    SELECT
        nycc.title as movie,
        nycc.name as location,
        nycc.startTime as startTime
    FROM nyc_cinemas as nycc;
