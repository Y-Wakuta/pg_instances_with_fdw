docker-compose down
docker-compose rm

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
docker volume rm $(docker volume ls -f dangling=true -q)

docekr-compose build --no-cache
docker-compose up