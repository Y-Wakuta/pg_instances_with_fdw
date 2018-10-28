#!/bin/bash
output_file='result_ver_9_6_6.sql'
query_array=`find ./Query -name "*.sql" -type f | sort`
rm $output_file

echo Query start...
for item in ${query_array[@]}; do
    result=`psql -f $item -qAt -h localhost -U postgres -p 15432 -d coordinator_db`
    {
    echo '----------------------------------------------------'
    echo "--$item"
    echo '----------------------------------------------------'
    query=`cat $item`
    echo -e "$query"
    echo '----------------------------------------------------'
    echo '--result'
    echo '----------------------------------------------------'
    echo -e "$result"
    echo -e "\n"
    } | tee -a $output_file
done