# NGINX
FROM public.ecr.aws/nginx/nginx:1.26.0

ARG BUILD_ARGUMENT_ENV=development
ENV APP_HOME /var/www/html
ARG BASIC_AUTH_USER=dimageshare
ARG BASIC_AUTH_PASSWORD=dimage01dimage01

ADD  ./public $APP_HOME/public

# install all the dependencies and enable PHP modules
RUN apt-get update && apt-get -y install apache2-utils

# create basic authen file
RUN if [ "${BUILD_ARGUMENT_ENV}" = "testing" ]; then \
        printf "${BASIC_AUTH_PASSWORD}\n${BASIC_AUTH_PASSWORD}\n" | htpasswd -c /etc/nginx/.htpasswd ${BASIC_AUTH_USER}; \
    fi

# put nginx config and listen port config.
ADD ./docker/configs/${BUILD_ARGUMENT_ENV}/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
