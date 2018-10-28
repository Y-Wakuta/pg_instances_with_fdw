CREATE VIEW view_movie_genres as
    SELECT 
        mg.title as title,
        mg.genre as genre
    FROM movie_genres as mg;
