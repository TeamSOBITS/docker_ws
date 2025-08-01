export UID=$(id -u $USER)
export GID=$(id -g $USER)
docker compose -f docker-compose.yml build --build-arg UID=$UID --build-arg GID=$GID