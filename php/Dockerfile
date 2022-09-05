ARG PHP
ARG NAME
FROM $PHP

ENV MUSL_LOCPATH="/usr/share/i18n/locales/musl"

RUN set -xe \
    ###> BASE UTILS ###
    && apk add --update --no-cache \
        git \
        openrc \
        bash \
        vim \
        yarn \
        icu \
        openssh-client \
    ###> LOCALE EXTENSION ### \
        musl-locales \
        musl-locales-lang \
    ###> GD EXTENSION ###
        freetype \
        libjpeg-turbo \
        libpng \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libwebp-dev \
    ###> DEV EXTENSION ###
        make \
        $PHPIZE_DEPS \
        zlib-dev \
        icu-dev \
        g++

RUN \
    ###> CONFIGURE PHP EXTENSIONS
        ###> CONFIGURE GD EXTENSION
            docker-php-ext-configure gd \
                --with-freetype=/usr/include/ \
                --with-jpeg=/usr/include/ \
                --with-webp=/usr/include/ \
        ###< CONFIGURE GD EXTENSION \
        \
        ###> CONFIGURE INTL EXTENSION
            && docker-php-ext-configure intl \
        ###< CONFIGURE INTL EXTENSION
    ###< CONFIGURE PHP EXTENSIONS
    \
    ###> INSTALL PHP EXTENSIONS
        && docker-php-ext-install -j$(nproc)  \
            gd \
            intl \
            pdo_mysql \
            opcache \
            exif \
    ###< INSTALL PHP EXTENSIONS \
    \
    ###> CACHE CLEAR ### \
    && apk del --no-cache \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        make \
        $PHPIZE_DEPS \
        zlib-dev \
        icu-dev \
        g++ \
    && rm -rf /tmp/* \
    && { find /usr/local/lib -type f -print0 | xargs -0r strip --strip-all -p 2>/dev/null || true; } \
    && rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/*
    ###< CACHE CLEAR ###

COPY --from=composer:2.1 /usr/bin/composer /usr/bin/composer
