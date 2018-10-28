chmod +x  /var/log/postgresql/init_error.log || :
#echo Creating database... 2 >> /var/log/postgresql/init_error.log
find /var/sql/schema -name "[!0]*.sql" -type f | \
sort | \
xargs -i psql -v ON_ERROR_STOP=1 -U postgres -f {} participant_db
