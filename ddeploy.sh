#!/bin/bash

SUCCESS='\033[1;32m'
WARNING='\033[1;33m'
ERROR='\033[0;31m'
NC='\033[0m'

ENV_ABSOLUTE_PATH=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.env.local")
if test -f "$ENV_ABSOLUTE_PATH"; then
    CONTAINER_NAME_RAW=$(cat "$ENV_ABSOLUTE_PATH" | grep "CONTAINER_NAME")
    IFS='=' read -r -a CONTAINER_NAME_ARRAY <<< "$CONTAINER_NAME_RAW"
    CONTAINER_NAME="${CONTAINER_NAME_ARRAY[1]}"
    echo ""
    printf "%bdeploying %s%b\n" "$SUCCESS" "$CONTAINER_NAME" "$NC"
    echo ""
else
    echo ""
    printf "%b%s do not exist%b\n" "$WARNING" "$ENV_ABSOLUTE_PATH" "$NC"
    echo ""
    exit
fi

DEPLOY_COMPOSER=false
DEPLOY_YARN_DASHBOARD=false
DEPLOY_YARN_WEBSITE=false
UPDATE_CACHE=false

while getopts "dwcph" option; do
    case $option in
        p)
            DEPLOY_COMPOSER=true
            ;;
        d)
            DEPLOY_YARN_DASHBOARD=true
            ;;
        w)
            DEPLOY_YARN_WEBSITE=true
            ;;
        c)
            UPDATE_CACHE=true
            ;;
        h)
            echo ""
            printf "%bThese shell keys are defined to help in deploying.\n%b" "$SUCCESS" "$NC"
            echo ""
            echo " deploy.sh [-d] deploy dashboard encore"
            echo " deploy.sh [-w] deploy website encore"
            echo " deploy.sh [-c] update php cache"
            echo " deploy.sh [-p] composer install"
            echo ""
            printf "%b© Floy%b\n" "$SUCCESS" "$NC"
            echo ""
            exit
            ;;
        \?)
            echo ""
            printf "%bError: Invalid option %b\n" "$ERROR" "$NC"
            echo ""
            exit
            ;;
    esac
done

if [ $DEPLOY_YARN_DASHBOARD == true ]; then
    docker exec -it "$CONTAINER_NAME-php" bash -c "exec yarn --cwd /var/www/app/dashboard"
    docker exec -it "$CONTAINER_NAME-php" bash -c "exec yarn --cwd /var/www/app/dashboard encore prod"
fi

if [ $DEPLOY_YARN_WEBSITE == true ]; then
    docker exec -it "$CONTAINER_NAME-php" bash -c "exec yarn --cwd /var/www/app/website"
    docker exec -it "$CONTAINER_NAME-php" bash -c "exec yarn --cwd /var/www/app/website encore prod"
fi

if [ $DEPLOY_COMPOSER == true ]; then
    docker exec -it "$CONTAINER_NAME-php" bash -c "exec composer i -d /var/www/app/website"
fi

if [ $UPDATE_CACHE == true ]; then
    docker exec -it "$CONTAINER_NAME-php" bash -c "exec php /var/www/app/website/bin/console c:c"
fi
