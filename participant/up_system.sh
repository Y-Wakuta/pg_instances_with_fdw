docker stop `docker ps -a -q`
docker rm `docker ps -a -q`
docker rmi $(docker images -q)

docker build -t distribute .
docker run -p 5432:5432 --name distributed_db distribute
