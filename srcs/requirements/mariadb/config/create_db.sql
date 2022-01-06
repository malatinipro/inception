/** On met tout au propre pour eviter les valeurs par defaut **/
DELETE FROM	mysql.user WHERE User='';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MARIADB_ROOT_PWD');

CREATE DATABASE $MARIADB_DB;
CREATE USER '$MARIADB_USER'@'%' IDENTIFIED by '$MARIADB_PWD';
/**CREATE USER '$WP_USER'@'%' IDENTIFIED by '$WP_USER_PWD';**/
GRANT ALL PRIVILEGES ON $MARIADB_DB.* TO $MARIADB_USER@'%';
/**GRANT CREATE ON $MARIADB_DB.* TO $WP_USER@'%'; **/

FLUSH PRIVILEGES;