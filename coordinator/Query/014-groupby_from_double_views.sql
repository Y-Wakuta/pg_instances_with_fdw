explain verbose select vmg.genre from view_movie_genres as vmg left join view_movie as vm on vmg.title = vm.title group by vmg.genre;