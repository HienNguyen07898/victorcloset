FROM mysql:8.0.37

ARG BUILD_ARGUMENT_ENV=development
ENV APP_HOME /var/www/html

ADD ./docker/configs/${BUILD_ARGUMENT_ENV}/mysql/my.cnf /etc/mysql/conf.d/my.cnf
RUN chmod 644 /etc/mysql/conf.d/my.cnf
RUN mkdir /var/log/mysql
RUN chown mysql:mysql /var/log/mysql
