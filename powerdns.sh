. ./components/openssl.sh
. ./components/nginx.sh
. ./components/php.sh
. ./components/mysql.sh

# Install PowerDNS and configure it
pkg install -y phpMyAdmin5-php82 php82-mysqli php82-fileinfo php82-session php82-curl dns/powerdns

cd ~/fbsd-scripts
cp -r ./powerdns/usr /
cp -r ./powerdns/root /

# Nginx configuration PHP
cd /root && sh bootstrap.sh
sed -i '' 's%listen = 127.0.0.1:9000%listen = /var/run/php-fpm.sock;%g' /usr/local/etc/php-fpm.d/www.conf
printf '<?php phpinfo(); ?>\n\n' > /usr/local/www/nginx/info.php
rm /root/bootstrap.sh && cd /root 

# Apps configuration PHPMyAdmin
mysql -u root -e "CREATE DATABASE IF NOT EXISTS phpmyadmin;"
mysql -u root -e "CREATE USER IF NOT EXISTS pma@'localhost' identified by 'pmapass'"
mysql -u root -e "GRANT ALL PRIVILEGES on phpmyadmin.* to pma@'localhost'"
mysql -u root -e "FLUSH PRIVILEGES"

cd /usr/local/www/phpMyAdmin/sql && mysql < create_tables.sql
cp /usr/local/etc/apache24/Includes/phpmyadmin.conf.sample /usr/local/etc/apache24/Includes/phpmyadmin.conf
chown -R www:www /usr/local/www/phpMyAdmin

# PowerDNS configuration
mysql -u root -e "CREATE DATABASE IF NOT EXISTS pdnsdb;"
mysql -u root -e "CREATE USER IF NOT EXISTS pdnsuser@'localhost' identified by 'pdnspass';"
mysql -u root -e "GRANT ALL PRIVILEGES on pdnsdb.* to pdnsuser@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"

cd /usr/local/share/doc/powerdns/; mysql -u root pdnsdb < schema.mysql.sql
#pdns_server --daemon=no --guardian=no --loglevel=9
# PowerAdmin configuration
. ./powerdns/config/ui-php.sh

sysrc pdns_enable=yes
service pdns start
service php_fpm restart
service nginx restart
