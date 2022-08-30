#!/bin/bash
set -me

APP_ENV=$1

/usr/local/bin/docker-php-entrypoint

#if [ $APP_ENV == 'dev' ]; then
#    yarn & yarn encore dev --watch & php-fpm
#else
#    yarn
#    yarn encore prod
    php-fpm
#fi

fg %1