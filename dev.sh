WARNING='\033[1;33m'
NC='\033[0m'

touch nginx/logs/access.log
touch nginx/logs/error.log
touch bash/.bash_history
touch yarn/.yarnrc

ENV_ABSOLUTE_PATH=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.env.local")

if test -f "$ENV_ABSOLUTE_PATH"; then

    CONTAINER_NAME_RAW=$(cat "$ENV_ABSOLUTE_PATH" | grep "CONTAINER_NAME")
    IFS='=' read -r -a CONTAINER_NAME_ARRAY <<< "$CONTAINER_NAME_RAW"
    CONTAINER_NAME="${CONTAINER_NAME_ARRAY[1]}"

    docker compose --env-file .env.local -f docker-compose.yaml -f docker-compose.dev.yaml -p "$CONTAINER_NAME" up --build -d
else
    echo ""
    printf "%b%s do not exist%b\n" "$WARNING" "$ENV_ABSOLUTE_PATH" "$NC"
    echo ""
    exit
fi