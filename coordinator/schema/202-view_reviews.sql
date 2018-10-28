CREATE VIEW view_reviews as
    SELECT 
        r.title as title,
        r.grade as grade,
	r.review as review
    FROM reviews as r;
