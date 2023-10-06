#!/bin/sh

while ! mariadb -hMARIADB_HOST -u$MARIADB_USER -p$MARIADB_PWD $MARIADB_DB &>/dev/null; do
    sleep 3
done


wp core install --url="$WP_URL" --title="$WP_TITLE" --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PWD" --admin_email="$WP_ADMIN_EMAIL" --skip-email

wp plugin update --all

wget https://raw.githubusercontent.com/Niyko/Hydra-Dark-Theme-for-Adminer/master/adminer.css -O /var/www/html/adminer.css &> /dev/null

wp theme install inspiro --activate --allow-root

wp user create $WP_USER $WP_USER_EMAIL --role=editor --user_pass=$WP_USER_PWD --allow-root

wp post generate --count=5 --post_title="malatini" --allow-root

echo "Wordpress started on :9000"

php-fpm7 --nodaemonize