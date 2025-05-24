#PHP
FROM composer:2.7.6 AS composer
FROM public.ecr.aws/docker/library/php:8.3-fpm-alpine

ARG BUILD_ARGUMENT_ENV=development
ENV ENV=${BUILD_ARGUMENT_ENV}
ENV APP_HOME /var/www/html
ARG HOST_UID=1000
ARG HOST_GID=1000
ENV USERNAME=www-data

# check environment
RUN if [ "$BUILD_ARGUMENT_ENV" = "default" ]; then echo "Set BUILD_ARGUMENT_ENV in docker build-args like --build-arg BUILD_ARGUMENT_ENV=dev" && exit 2; \
    elif [ "$BUILD_ARGUMENT_ENV" = "development" ]; then echo "Building development environment."; \
    elif [ "$BUILD_ARGUMENT_ENV" = "testing" ]; then echo "Building test environment."; \
    elif [ "$BUILD_ARGUMENT_ENV" = "staging" ]; then echo "Building staging environment."; \
    elif [ "$BUILD_ARGUMENT_ENV" = "production" ]; then echo "Building production environment."; \
    else echo "Set correct BUILD_ARGUMENT_ENV in docker build-args like --build-arg BUILD_ARGUMENT_ENV=dev. Available choices are dev,test,staging,prod." && exit 2; \
    fi

# install all the dependencies and enable PHP modules
RUN set -eux \
    && apk add -U shadow \
    && apk add --no-cache git g++ libtool composer npm make libzip-dev \
    && apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add icu-dev \
        linux-headers \
        php-tokenizer \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        php-gd \
        php-dom \
        php-session \
        php-fileinfo \
        php-xml \
        php-xmlreader \
        php-xmlwriter \
        php-simplexml \
    && apk del autoconf g++ libtool make \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) gd opcache bcmath intl pdo_mysql exif zip

# create document root, fix permissions for www-data user and change owner to www-data
RUN rm -r $APP_HOME
RUN mkdir -p $APP_HOME/public && \
    mkdir -p /home/$USERNAME && chown $USERNAME:$USERNAME /home/$USERNAME \
    && usermod -o -u $HOST_UID $USERNAME -d /home/$USERNAME \
    && groupmod -o -g $HOST_GID $USERNAME \
    && chown -R ${USERNAME}:${USERNAME} $APP_HOME

COPY ./docker/configs/${BUILD_ARGUMENT_ENV}/php/php.ini /usr/local/etc/php/php.ini

# install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN chmod +x /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH="${PATH}:/root/.composer/vendor/bin"

# set working directory
WORKDIR $APP_HOME

# copy source files
COPY --chown=${USERNAME}:${USERNAME} . $APP_HOME/

USER ${USERNAME}

RUN if [ "${BUILD_ARGUMENT_ENV}" = "testing" ] || [ "${BUILD_ARGUMENT_ENV}" = "staging" ] || [ "${BUILD_ARGUMENT_ENV}" = "production" ]; then \
        composer install && \
        php artisan key:generate && \
        npm install && \
        npm run build && \
        php artisan optimize:clear && \
        chown -R www-data:www-data /var/www/html/storage && \
        chown -R www-data:www-data /var/www/html/bootstrap/cache && \
        chown -R www-data:www-data /var/www/html/resources/images/logo.png && \
        chown -R www-data:www-data /var/www/html/resources/images/favicon.png && \
        chown -R www-data:www-data /var/www/html/resources/images/sidebar_expanded_logo.png && \
        chown -R www-data:www-data /var/www/html/resources/sass/_configuration.scss && \
        chmod -R ugo+rw /var/www/html/storage && \
        chmod -R ugo+rw /var/www/html/bootstrap/cache && \
        chown -R 777 /var/www/html/resources/sass/_configuration.scss; \
    fi

CMD ["php-fpm","-F"]
