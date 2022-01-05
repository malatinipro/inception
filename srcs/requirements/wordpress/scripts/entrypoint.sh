#On va modifier le fichier www.conf pour que ca fonctionne en local comme demande
target="/etc/php7/php-fpm.d/www.conf"

# On aurait aussi pu reprendre le fichier dans notre dossier config plutot que de fonctionner comme ca
grep -E "listen = 127.0.0.1" $target > /dev/null 2>&1
if [ $? -eq 0 ]; then
	sed -i "s|.*listen = 127.0.0.1.*|listen = 9000|g" $target
	echo "env[MARIADB_HOST] = \$MARIADB_HOST" >> $target
	echo "env[MARIADB_USER] = \$MARIADB_USER" >> $target
	echo "env[MARIADB_PWD] = \$MARIADB_PWD" >> $target
	echo "env[MARIADB_DB] = \$MARIADB_DB" >> $target
fi

# Va permettre d'eviter de lancer ce script php systematiquement ?
if [ ! -f "wp-config.php" ]; then
	cp /config/wp-config ./wp-config.php

	sleep 5 

	# Attention il y a un vrai pb avec le user sur ubuntu
	wp core download

	#sleep 5
	# Configuration du site wordpress
	wp core install --url="$WP_URL" --title="$WP_TITLE" --admin_user="$WP_ADMIN_USER" \
    	--admin_password="$WP_ADMIN_PWD" --admin_email="$WP_ADMIN_EMAIL" --skip-email

	#wp plugin install redis-cache --activate
	wp plugin update --all

	# Installation de notre theme et "activation"
	wp theme install twentysixteen --activate

	wp user create $WP_USER $WP_USER_EMAIL --role=editor --user_pass=$WP_USER_PWD

	# Creation d'un article pour l'example
	wp post generate --count=5 --post_title="malatini"
fi

# On a besoin de ca pour faire tourner wordpress mais aussi pour que le container keep running
# a revoir 
#php-fpm --nodaemonize