WARNING='\033[1;33m'
NC='\033[0m'

touch nginx/logs/access.log
touch nginx/logs/error.log
touch bash/.bash_history
touch yarn/.yarnrc

DOCKER_ABSOLUTE_PATH=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")

ENV=$DOCKER_ABSOLUTE_PATH"/.env.local"
DOCKER_COMPOSE_PROD_LOCAL=$DOCKER_ABSOLUTE_PATH"/docker-compose.prod.local.yaml"

if test -f "$ENV"; then

    CONTAINER_NAME_RAW=$(cat "$ENV" | grep "CONTAINER_NAME")
    IFS='=' read -r -a CONTAINER_NAME_ARRAY <<< "$CONTAINER_NAME_RAW"
    CONTAINER_NAME="${CONTAINER_NAME_ARRAY[1]}"

    if test -f "$DOCKER_COMPOSE_PROD_LOCAL"; then
       docker compose --env-file .env.local -f docker-compose.yaml -f docker-compose.prod.local.yaml -p "$CONTAINER_NAME" up --build -d
    else
       docker compose --env-file .env.local -f docker-compose.yaml -f docker-compose.prod.yaml -p "$CONTAINER_NAME" up --build -d
    fi
else
    echo ""
    printf "%b%s do not exist%b\n" "$WARNING" "$ENV_ABSOLUTE_PATH" "$NC"
    echo ""
    exit
fi