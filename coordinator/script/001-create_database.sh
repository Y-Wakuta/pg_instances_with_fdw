find /var/sql/schema -name "000-*.sql" -type f | \
sort | \
xargs -i psql -v ON_ERROR_STOP=1 -U postgres -f {}
