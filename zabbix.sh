# Include
. ./famp-mysql.sh

# Install phpPgAdmin and configure it
pkg install -y zabbix7-server zabbix7-agent zabbix7-frontend-php82 php82-mbstring php82-gd php82-bcmath

cp -r ./zabbix/usr /
cp -r ./zabbix/root /

# PHP configuration Zabbix
sed -i '' 's%listen = 127.0.0.1:9000%listen = /var/run/php-fpm.sock;%g' /usr/local/etc/php-fpm.d/www.conf
echo 'php_value[max_execution_time] = 300' >> /usr/local/etc/php-fpm.d/www.conf
echo 'php_value[memory_limit] = 128M' >> /usr/local/etc/php-fpm.d/www.conf
echo 'php_value[post_max_size] = 16M' >> /usr/local/etc/php-fpm.d/www.conf
echo 'php_value[upload_max_filesize] = 2M' >> /usr/local/etc/php-fpm.d/www.conf
echo 'php_value[max_input_time] = 300' >> /usr/local/etc/php-fpm.d/www.conf
echo 'php_value[max_input_vars] = 10000' >> /usr/local/etc/php-fpm.d/www.conf
echo 'php_value[always_populate_raw_post_data] = -1' >> /usr/local/etc/php-fpm.d/www.conf
echo 'php_value[date.timezone] = Asia/Jakarta' >> /usr/local/etc/php-fpm.d/www.conf
echo 'php_value[session.save_path] = /tmp' >> /usr/local/etc/php-fpm.d/www.conf

cp /usr/local/etc/apache24/Includes/zabbix.conf.sample /usr/local/etc/apache24/Includes/zabbix.conf
chown -R www:www /usr/local/www/zabbix7
cd /root && sh bootstrap.sh
rm /root/bootstrap.sh

# Service
service zabbix_server enable
service zabbix_server start
service zabbix_agentd enable
service zabbix_agentd start
service php_fpm restart
service apache24 restart
