 while ! nc -z participant 5432;
        do
          echo sleeping;
          sleep 1;
        done;
        echo Connected!;