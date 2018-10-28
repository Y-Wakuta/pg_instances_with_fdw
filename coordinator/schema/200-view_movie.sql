CREATE VIEW view_movie as
    SELECT 
        m.title as title,
        md.director as director,
        md.year as year,
        md.genre as genre
    FROM movie as m,movie_detail as md
    WHERE m.MID = md.MID
    UNION
    SELECT 
        mg.title as title,
        mdi.director as director,
        my.year as year,
        mg.genre as genre
    FROM movie_genres as mg,
         movie_directors as mdi, 
         movie_years as my
    WHERE mg.title = mdi.title and mdi.title = my.title;
