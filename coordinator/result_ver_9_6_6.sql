----------------------------------------------------
--./Query/00-get_tables.sql
----------------------------------------------------
\d
----------------------------------------------------
--result
----------------------------------------------------
public|actor|foreign table|postgres
public|actor_plays|foreign table|postgres
public|cinemas|foreign table|postgres
public|movie|foreign table|postgres
public|movie_detail|foreign table|postgres
public|movie_directors|foreign table|postgres
public|movie_genres|foreign table|postgres
public|movie_years|foreign table|postgres
public|nyc_cinemas|foreign table|postgres
public|reviews|foreign table|postgres
public|view_movie|view|postgres
public|view_movie_genres|view|postgres
public|view_plays|view|postgres
public|view_reviews|view|postgres


----------------------------------------------------
--./Query/000-query_join_simple_views.sql
----------------------------------------------------
explain verbose select * from view_reviews as vr join view_movie_genres as vmg on vr.title = vmg.title;
----------------------------------------------------
--result
----------------------------------------------------
Hash Join  (cost=227.55..298.63 rows=1208 width=290)
  Output: r.title, r.grade, r.review, mg.title, mg.genre
  Hash Cond: ((mg.title)::text = (r.title)::text)
  ->  Foreign Scan on public.movie_genres mg  (cost=100.00..127.55 rows=585 width=116)
        Output: mg.title, mg.genre
        Remote SQL: SELECT title, genre FROM public.movie_genres
  ->  Hash  (cost=122.39..122.39 rows=413 width=174)
        Output: r.title, r.grade, r.review
        ->  Foreign Scan on public.reviews r  (cost=100.00..122.39 rows=413 width=174)
              Output: r.title, r.grade, r.review
              Remote SQL: SELECT title, grade, review FROM public.reviews


----------------------------------------------------
--./Query/001-select_from_view_movie.sql
----------------------------------------------------
explain verbose select * from view_movie;
----------------------------------------------------
--result
----------------------------------------------------
HashAggregate  (cost=1258.12..1370.02 rows=11190 width=152)
  Output: m.title, md.director, md.year, md.genre
  Group Key: m.title, md.director, md.year, md.genre
  ->  Append  (cost=237.20..1146.22 rows=11190 width=152)
        ->  Hash Join  (cost=237.20..384.76 rows=3046 width=158)
              Output: m.title, md.director, md.year, md.genre
              Hash Cond: (m.mid = md.mid)
              ->  Foreign Scan on public.movie m  (cost=100.00..138.56 rows=952 width=62)
                    Output: m.mid, m.title
                    Remote SQL: SELECT mid, title FROM public.movie
              ->  Hash  (cost=129.20..129.20 rows=640 width=104)
                    Output: md.director, md.year, md.genre, md.mid
                    ->  Foreign Scan on public.movie_detail md  (cost=100.00..129.20 rows=640 width=104)
                          Output: md.director, md.year, md.genre, md.mid
                          Remote SQL: SELECT mid, director, genre, year FROM public.movie_detail
        ->  Merge Join  (cost=494.53..649.56 rows=8144 width=178)
              Output: mg.title, mdi.director, my.year, mg.genre
              Merge Cond: ((mg.title)::text = (my.title)::text)
              ->  Merge Join  (cost=308.87..337.46 rows=1711 width=232)
                    Output: mg.title, mg.genre, mdi.director, mdi.title
                    Merge Cond: ((mg.title)::text = (mdi.title)::text)
                    ->  Sort  (cost=154.44..155.90 rows=585 width=116)
                          Output: mg.title, mg.genre
                          Sort Key: mg.title
                          ->  Foreign Scan on public.movie_genres mg  (cost=100.00..127.55 rows=585 width=116)
                                Output: mg.title, mg.genre
                                Remote SQL: SELECT title, genre FROM public.movie_genres
                    ->  Sort  (cost=154.44..155.90 rows=585 width=116)
                          Output: mdi.director, mdi.title
                          Sort Key: mdi.title
                          ->  Foreign Scan on public.movie_directors mdi  (cost=100.00..127.55 rows=585 width=116)
                                Output: mdi.director, mdi.title
                                Remote SQL: SELECT title, director FROM public.movie_directors
              ->  Sort  (cost=185.66..188.04 rows=952 width=62)
                    Output: my.year, my.title
                    Sort Key: my.title
                    ->  Foreign Scan on public.movie_years my  (cost=100.00..138.56 rows=952 width=62)
                          Output: my.year, my.title
                          Remote SQL: SELECT title, year FROM public.movie_years


----------------------------------------------------
--./Query/002-select_from_view_movie_with_record.sql
----------------------------------------------------
EXPLAIN verbose SELECT * FROM view_movie WHERE year = 1974;
----------------------------------------------------
--result
----------------------------------------------------
HashAggregate  (cost=437.00..437.57 rows=57 width=152)
  Output: m.title, md.director, md.year, md.genre
  Group Key: m.title, md.director, md.year, md.genre
  ->  Append  (cost=100.00..436.43 rows=57 width=152)
        ->  Foreign Scan  (cost=100.00..152.08 rows=14 width=158)
              Output: m.title, md.director, md.year, md.genre
              Relations: (public.movie m) INNER JOIN (public.movie_detail md)
              Remote SQL: SELECT r1.title, r2.director, r2.year, r2.genre FROM (public.movie r1 INNER JOIN public.movie_detail r2 ON (((r1.mid = r2.mid)) AND ((r2.year = 1974))))
        ->  Hash Join  (cost=252.86..283.78 rows=43 width=178)
              Output: mg.title, mdi.director, my.year, mg.genre
              Hash Cond: ((mdi.title)::text = (mg.title)::text)
              ->  Foreign Scan on public.movie_directors mdi  (cost=100.00..127.55 rows=585 width=116)
                    Output: mdi.title, mdi.director
                    Remote SQL: SELECT title, director FROM public.movie_directors
              ->  Hash  (cost=152.68..152.68 rows=15 width=178)
                    Output: mg.title, mg.genre, my.year, my.title
                    ->  Foreign Scan  (cost=100.00..152.68 rows=15 width=178)
                          Output: mg.title, mg.genre, my.year, my.title
                          Relations: (public.movie_genres mg) INNER JOIN (public.movie_years my)
                          Remote SQL: SELECT r1.title, r1.genre, r3.year, r3.title FROM (public.movie_genres r1 INNER JOIN public.movie_years r3 ON (((r1.title = r3.title)) AND ((r3.year = 1974))))


----------------------------------------------------
--./Query/003-select_from_view_movie_with_no_record.sql
----------------------------------------------------
explain verbose SELECT * FROM view_movie where year = 2100;
----------------------------------------------------
--result
----------------------------------------------------
HashAggregate  (cost=437.00..437.57 rows=57 width=152)
  Output: m.title, md.director, md.year, md.genre
  Group Key: m.title, md.director, md.year, md.genre
  ->  Append  (cost=100.00..436.43 rows=57 width=152)
        ->  Foreign Scan  (cost=100.00..152.08 rows=14 width=158)
              Output: m.title, md.director, md.year, md.genre
              Relations: (public.movie m) INNER JOIN (public.movie_detail md)
              Remote SQL: SELECT r1.title, r2.director, r2.year, r2.genre FROM (public.movie r1 INNER JOIN public.movie_detail r2 ON (((r1.mid = r2.mid)) AND ((r2.year = 2100))))
        ->  Hash Join  (cost=252.86..283.78 rows=43 width=178)
              Output: mg.title, mdi.director, my.year, mg.genre
              Hash Cond: ((mdi.title)::text = (mg.title)::text)
              ->  Foreign Scan on public.movie_directors mdi  (cost=100.00..127.55 rows=585 width=116)
                    Output: mdi.title, mdi.director
                    Remote SQL: SELECT title, director FROM public.movie_directors
              ->  Hash  (cost=152.68..152.68 rows=15 width=178)
                    Output: mg.title, mg.genre, my.year, my.title
                    ->  Foreign Scan  (cost=100.00..152.68 rows=15 width=178)
                          Output: mg.title, mg.genre, my.year, my.title
                          Relations: (public.movie_genres mg) INNER JOIN (public.movie_years my)
                          Remote SQL: SELECT r1.title, r1.genre, r3.year, r3.title FROM (public.movie_genres r1 INNER JOIN public.movie_years r3 ON (((r1.title = r3.title)) AND ((r3.year = 2100))))


----------------------------------------------------
--./Query/004-select_from_view_plays.sql
----------------------------------------------------
explain verbose SELECT * FROM view_plays;
----------------------------------------------------
--result
----------------------------------------------------
HashAggregate  (cost=273.96..285.32 rows=1136 width=120)
  Output: c.movie, c.place, c.start
  Group Key: c.movie, c.place, c.start
  ->  Append  (cost=100.00..265.44 rows=1136 width=120)
        ->  Foreign Scan on public.cinemas c  (cost=100.00..127.04 rows=568 width=120)
              Output: c.movie, c.place, c.start
              Remote SQL: SELECT place, movie, start FROM public.cinemas
        ->  Foreign Scan on public.nyc_cinemas nycc  (cost=100.00..127.04 rows=568 width=120)
              Output: nycc.title, nycc.name, nycc.starttime
              Remote SQL: SELECT name, title, starttime FROM public.nyc_cinemas


----------------------------------------------------
--./Query/005-update_view_reviews.sql
----------------------------------------------------
explain verbose UPDATE view_reviews SET grade = 'changed';
----------------------------------------------------
--result
----------------------------------------------------
Update on public.reviews r  (cost=100.00..126.38 rows=546 width=184)
  ->  Foreign Update on public.reviews r  (cost=100.00..126.38 rows=546 width=184)
        Remote SQL: UPDATE public.reviews SET grade = 'changed'::character varying(20)


----------------------------------------------------
--./Query/006-group_simple_view.sql
----------------------------------------------------
explain verbose SELECT * FROM view_reviews as vr GROUP BY vr.title,vr,grade,vr.review;
----------------------------------------------------
--result
----------------------------------------------------
Group  (cost=140.33..145.50 rows=200 width=206)
  Output: r.title, r.grade, r.review, (ROW(r.title, r.grade, r.review))
  Group Key: r.title, (ROW(r.title, r.grade, r.review)), r.grade, r.review
  ->  Sort  (cost=140.33..141.37 rows=413 width=206)
        Output: r.title, r.grade, r.review, (ROW(r.title, r.grade, r.review))
        Sort Key: r.title, (ROW(r.title, r.grade, r.review)), r.grade, r.review
        ->  Foreign Scan on public.reviews r  (cost=100.00..122.39 rows=413 width=206)
              Output: r.title, r.grade, r.review, ROW(r.title, r.grade, r.review)
              Remote SQL: SELECT title, grade, review FROM public.reviews


----------------------------------------------------
--./Query/007-select_from_view_plays.sql
----------------------------------------------------
explain verbose SELECT * FROM view_plays;
----------------------------------------------------
--result
----------------------------------------------------
HashAggregate  (cost=273.96..285.32 rows=1136 width=120)
  Output: c.movie, c.place, c.start
  Group Key: c.movie, c.place, c.start
  ->  Append  (cost=100.00..265.44 rows=1136 width=120)
        ->  Foreign Scan on public.cinemas c  (cost=100.00..127.04 rows=568 width=120)
              Output: c.movie, c.place, c.start
              Remote SQL: SELECT place, movie, start FROM public.cinemas
        ->  Foreign Scan on public.nyc_cinemas nycc  (cost=100.00..127.04 rows=568 width=120)
              Output: nycc.title, nycc.name, nycc.starttime
              Remote SQL: SELECT name, title, starttime FROM public.nyc_cinemas


----------------------------------------------------
--./Query/008-query_join_tables.sql
----------------------------------------------------
explain analyze select * from reviews as vr join movie_genres as vmg on vr.title = vmg.title;
----------------------------------------------------
--result
----------------------------------------------------
Hash Join  (cost=227.21..297.32 rows=1185 width=294) (actual time=1.394..1.398 rows=5 loops=1)
  Hash Cond: ((vmg.title)::text = (vr.title)::text)
  ->  Foreign Scan on movie_genres vmg  (cost=100.00..127.55 rows=585 width=116) (actual time=0.802..0.803 rows=5 loops=1)
  ->  Hash  (cost=122.15..122.15 rows=405 width=178) (actual time=0.544..0.544 rows=20 loops=1)
        Buckets: 1024  Batches: 1  Memory Usage: 10kB
        ->  Foreign Scan on reviews vr  (cost=100.00..122.15 rows=405 width=178) (actual time=0.529..0.534 rows=20 loops=1)
Planning time: 1.605 ms
Execution time: 6.324 ms


----------------------------------------------------
--./Query/009-groupby_from_single_table.sql
----------------------------------------------------
explain verbose select nationality from actor GROUP BY nationality;
----------------------------------------------------
--result
----------------------------------------------------
HashAggregate  (cost=142.47..144.47 rows=200 width=58)
  Output: nationality
  Group Key: actor.nationality
  ->  Foreign Scan on public.actor  (cost=100.00..139.97 rows=999 width=58)
        Output: aid, firstname, lastname, nationality, yearofbirth
        Remote SQL: SELECT nationality FROM public.actor


----------------------------------------------------
--./Query/010-groupby_from_join_self.sql
----------------------------------------------------
explain verbose select a1.nationality from actor as a1 left join actor as a2 on a1.aid = a2.aid GROUP BY a1.nationality;
----------------------------------------------------
--result
----------------------------------------------------
HashAggregate  (cost=800.22..802.22 rows=200 width=58)
  Output: a1.nationality
  Group Key: a1.nationality
  ->  Merge Left Join  (cost=551.80..765.41 rows=13923 width=58)
        Output: a1.nationality
        Merge Cond: (a1.aid = a2.aid)
        ->  Sort  (cost=185.66..188.04 rows=952 width=62)
              Output: a1.nationality, a1.aid
              Sort Key: a1.aid
              ->  Foreign Scan on public.actor a1  (cost=100.00..138.56 rows=952 width=62)
                    Output: a1.nationality, a1.aid
                    Remote SQL: SELECT aid, nationality FROM public.actor
        ->  Sort  (cost=366.15..373.46 rows=2925 width=4)
              Output: a2.aid
              Sort Key: a2.aid
              ->  Foreign Scan on public.actor a2  (cost=100.00..197.75 rows=2925 width=4)
                    Output: a2.aid
                    Remote SQL: SELECT aid FROM public.actor


----------------------------------------------------
--./Query/011-groupby_from_double_table.sql
----------------------------------------------------
explain verbose select a.aid,a.nationality from actor as a left join actor_plays as ap on a.aid = ap.aid GROUP BY a.nationality,a.aid;
----------------------------------------------------
--result
----------------------------------------------------
HashAggregate  (cost=835.02..837.02 rows=200 width=62)
  Output: a.aid, a.nationality
  Group Key: a.nationality, a.aid
  ->  Merge Left Join  (cost=551.80..765.41 rows=13923 width=62)
        Output: a.aid, a.nationality
        Merge Cond: (a.aid = ap.aid)
        ->  Sort  (cost=185.66..188.04 rows=952 width=62)
              Output: a.aid, a.nationality
              Sort Key: a.aid
              ->  Foreign Scan on public.actor a  (cost=100.00..138.56 rows=952 width=62)
                    Output: a.aid, a.nationality
                    Remote SQL: SELECT aid, nationality FROM public.actor
        ->  Sort  (cost=366.15..373.46 rows=2925 width=4)
              Output: ap.aid
              Sort Key: ap.aid
              ->  Foreign Scan on public.actor_plays ap  (cost=100.00..197.75 rows=2925 width=4)
                    Output: ap.aid
                    Remote SQL: SELECT aid FROM public.actor_plays


----------------------------------------------------
--./Query/012-groupby_from_sigle_simple_view.sql
----------------------------------------------------
explain verbose select review from view_reviews GROUP BY review;
----------------------------------------------------
--result
----------------------------------------------------
HashAggregate  (cost=142.47..144.47 rows=200 width=58)
  Output: r.review
  Group Key: r.review
  ->  Foreign Scan on public.reviews r  (cost=100.00..139.97 rows=999 width=58)
        Output: r.title, r.date, r.grade, r.review
        Remote SQL: SELECT review FROM public.reviews


----------------------------------------------------
--./Query/013-groupby_from_sigle_complex_view.sql
----------------------------------------------------
explain verbose select director from view_movie GROUP BY director;
----------------------------------------------------
--result
----------------------------------------------------
HashAggregate  (cost=1509.90..1511.90 rows=200 width=58)
  Output: md.director
  Group Key: md.director
  ->  HashAggregate  (cost=1258.12..1370.02 rows=11190 width=152)
        Output: m.title, md.director, md.year, md.genre
        Group Key: m.title, md.director, md.year, md.genre
        ->  Append  (cost=237.20..1146.22 rows=11190 width=152)
              ->  Hash Join  (cost=237.20..384.76 rows=3046 width=158)
                    Output: m.title, md.director, md.year, md.genre
                    Hash Cond: (m.mid = md.mid)
                    ->  Foreign Scan on public.movie m  (cost=100.00..138.56 rows=952 width=62)
                          Output: m.mid, m.title
                          Remote SQL: SELECT mid, title FROM public.movie
                    ->  Hash  (cost=129.20..129.20 rows=640 width=104)
                          Output: md.director, md.year, md.genre, md.mid
                          ->  Foreign Scan on public.movie_detail md  (cost=100.00..129.20 rows=640 width=104)
                                Output: md.director, md.year, md.genre, md.mid
                                Remote SQL: SELECT mid, director, genre, year FROM public.movie_detail
              ->  Merge Join  (cost=494.53..649.56 rows=8144 width=178)
                    Output: mg.title, mdi.director, my.year, mg.genre
                    Merge Cond: ((mg.title)::text = (my.title)::text)
                    ->  Merge Join  (cost=308.87..337.46 rows=1711 width=232)
                          Output: mg.title, mg.genre, mdi.director, mdi.title
                          Merge Cond: ((mg.title)::text = (mdi.title)::text)
                          ->  Sort  (cost=154.44..155.90 rows=585 width=116)
                                Output: mg.title, mg.genre
                                Sort Key: mg.title
                                ->  Foreign Scan on public.movie_genres mg  (cost=100.00..127.55 rows=585 width=116)
                                      Output: mg.title, mg.genre
                                      Remote SQL: SELECT title, genre FROM public.movie_genres
                          ->  Sort  (cost=154.44..155.90 rows=585 width=116)
                                Output: mdi.director, mdi.title
                                Sort Key: mdi.title
                                ->  Foreign Scan on public.movie_directors mdi  (cost=100.00..127.55 rows=585 width=116)
                                      Output: mdi.director, mdi.title
                                      Remote SQL: SELECT title, director FROM public.movie_directors
                    ->  Sort  (cost=185.66..188.04 rows=952 width=62)
                          Output: my.year, my.title
                          Sort Key: my.title
                          ->  Foreign Scan on public.movie_years my  (cost=100.00..138.56 rows=952 width=62)
                                Output: my.year, my.title
                                Remote SQL: SELECT title, year FROM public.movie_years


----------------------------------------------------
--./Query/014-groupby_from_double_views.sql
----------------------------------------------------
explain verbose select vmg.genre from view_movie_genres as vmg left join view_movie as vm on vmg.title = vm.title group by vmg.genre;
----------------------------------------------------
--result
----------------------------------------------------
HashAggregate  (cost=2865.17..2867.17 rows=200 width=58)
  Output: mg.genre
  Group Key: mg.genre
  ->  Hash Right Join  (cost=1392.98..2783.34 rows=32731 width=58)
        Output: mg.genre
        Hash Cond: ((m.title)::text = (mg.title)::text)
        ->  HashAggregate  (cost=1258.12..1370.02 rows=11190 width=152)
              Output: m.title, md.director, md.year, md.genre
              Group Key: m.title, md.director, md.year, md.genre
              ->  Append  (cost=237.20..1146.22 rows=11190 width=152)
                    ->  Hash Join  (cost=237.20..384.76 rows=3046 width=158)
                          Output: m.title, md.director, md.year, md.genre
                          Hash Cond: (m.mid = md.mid)
                          ->  Foreign Scan on public.movie m  (cost=100.00..138.56 rows=952 width=62)
                                Output: m.mid, m.title
                                Remote SQL: SELECT mid, title FROM public.movie
                          ->  Hash  (cost=129.20..129.20 rows=640 width=104)
                                Output: md.director, md.year, md.genre, md.mid
                                ->  Foreign Scan on public.movie_detail md  (cost=100.00..129.20 rows=640 width=104)
                                      Output: md.director, md.year, md.genre, md.mid
                                      Remote SQL: SELECT mid, director, genre, year FROM public.movie_detail
                    ->  Merge Join  (cost=494.53..649.56 rows=8144 width=178)
                          Output: mg_1.title, mdi.director, my.year, mg_1.genre
                          Merge Cond: ((mg_1.title)::text = (my.title)::text)
                          ->  Merge Join  (cost=308.87..337.46 rows=1711 width=232)
                                Output: mg_1.title, mg_1.genre, mdi.director, mdi.title
                                Merge Cond: ((mg_1.title)::text = (mdi.title)::text)
                                ->  Sort  (cost=154.44..155.90 rows=585 width=116)
                                      Output: mg_1.title, mg_1.genre
                                      Sort Key: mg_1.title
                                      ->  Foreign Scan on public.movie_genres mg_1  (cost=100.00..127.55 rows=585 width=116)
                                            Output: mg_1.title, mg_1.genre
                                            Remote SQL: SELECT title, genre FROM public.movie_genres
                                ->  Sort  (cost=154.44..155.90 rows=585 width=116)
                                      Output: mdi.director, mdi.title
                                      Sort Key: mdi.title
                                      ->  Foreign Scan on public.movie_directors mdi  (cost=100.00..127.55 rows=585 width=116)
                                            Output: mdi.director, mdi.title
                                            Remote SQL: SELECT title, director FROM public.movie_directors
                          ->  Sort  (cost=185.66..188.04 rows=952 width=62)
                                Output: my.year, my.title
                                Sort Key: my.title
                                ->  Foreign Scan on public.movie_years my  (cost=100.00..138.56 rows=952 width=62)
                                      Output: my.year, my.title
                                      Remote SQL: SELECT title, year FROM public.movie_years
        ->  Hash  (cost=127.55..127.55 rows=585 width=116)
              Output: mg.genre, mg.title
              ->  Foreign Scan on public.movie_genres mg  (cost=100.00..127.55 rows=585 width=116)
                    Output: mg.genre, mg.title
                    Remote SQL: SELECT title, genre FROM public.movie_genres


