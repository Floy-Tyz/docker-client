#!/bin/bash

SUCCESS='\033[1;32m'
WARNING='\033[1;33m'
ERROR='\033[0;31m'
NC='\033[0m'

WEBSITE_ABSOLUTE_PATH=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../website")
DASHBOARD_ABSOLUTE_PATH=$(realpath "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../dashboard")

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

if [ -d "$DASHBOARD_ABSOLUTE_PATH" ]; then
    if [ $DEPLOY_YARN_DASHBOARD == true ]; then
        yarn --cwd "$DASHBOARD_ABSOLUTE_PATH"
        yarn encore prod --cwd "$DASHBOARD_ABSOLUTE_PATH"
    fi
else
    echo ""
    printf "%b%s do not exist%b\n" "$WARNING" "$DASHBOARD_ABSOLUTE_PATH" "$NC"
    echo ""
fi

if [ -d "$WEBSITE_ABSOLUTE_PATH" ]; then
    if [ $DEPLOY_COMPOSER == true ]; then
        composer i -d "$WEBSITE_ABSOLUTE_PATH"
    fi
    if [ $DEPLOY_YARN_WEBSITE == true ]; then
        yarn --cwd "$WEBSITE_ABSOLUTE_PATH"
        yarn encore prod --cwd "$WEBSITE_ABSOLUTE_PATH"
    fi
    if [ $UPDATE_CACHE == true ]; then
        php "$WEBSITE_ABSOLUTE_PATH/bin/console" c:c
    fi
else
    echo ""
    printf "%b%s do not exist%b\n" "$WARNING" "$WEBSITE_ABSOLUTE_PATH" "$NC"
    echo ""
fi