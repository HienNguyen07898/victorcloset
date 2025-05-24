#!/bin/bash
cd /var/www/html

# Laravel Setup
composer install
php artisan key:generate
# php artisan migrate
# php artisan db:seed
npm install
npm run build

# Clear cache for events, views, cache, route, config, compiled
php artisan optimize:clear

# Add Permission
chown -R www-data:www-data /var/www/html/storage
chown -R www-data:www-data /var/www/html/bootstrap/cache
chown -R www-data:www-data /var/www/html/resources/images/logo.png
chown -R www-data:www-data /var/www/html/resources/images/favicon.png
chown -R www-data:www-data /var/www/html/resources/sass/_configuration.scss
chmod -R ugo+rw /var/www/html/storage
chmod -R ugo+rw /var/www/html/bootstrap/cache
chown -R 777 /var/www/html/resources/sass/_configuration.scss

# Execute other command from cmd
exec $@
