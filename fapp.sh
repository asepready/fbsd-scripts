source /root/fbsd-scripts/openssl.sh
source /root/fbsd-scripts/apache.sh
source /root/fbsd-scripts/php.sh
source /root/fbsd-scripts/psql.sh

# Install phpPgAdmin and configure it
pkg install -y phppgadmin-php82 php82-pgsql php82-fileinfo php82-session php82-curl adodb5-php82

cp -r /root/fbsd-scripts/fapp/usr /

sed -i '' '/mod_cgid.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf
sed -i '' '/mod_cgi.so/s/LoadModule/#LoadModule/' /usr/local/etc/apache24/httpd.conf

# Apache configuration PHP
sed -i '' '/mod_mpm_event.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf
sed -i '' '/mod_mpm_prefork.so/s/LoadModule/#LoadModule/' /usr/local/etc/apache24/httpd.conf
sed -i '' '/mod_proxy.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf
sed -i '' '/mod_proxy_fcgi.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf
sed -i '' 's%ServerAdmin you@example.com%ServerAdmin admin@${JAIL_IP}%g' /usr/local/etc/apache24/extra/httpd-ssl.conf
sed -i '' 's%ServerName www.example.com:443%ServerName ${JAIL_IP}:443%g' /usr/local/etc/apache24/extra/httpd-ssl.conf
#cd /root && sh bootstrap.sh
printf '<?php phpinfo(); ?>\n\n' > /usr/local/www/apache24/data/info.php
#rm /root/bootstrap.sh

# SSL
sed -i '' '/mod_socache_shmcb.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf
sed -i '' '/mod_ssl.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf
sed -i '' '/httpd-ssl.conf/s/#Include/Include/' /usr/local/etc/apache24/httpd.conf
sed -i '' '/mod_rewrite.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf
echo '' >> /usr/local/etc/apache24/httpd.conf
echo 'RewriteEngine On' >> /usr/local/etc/apache24/httpd.conf
echo 'RewriteCond %{HTTPS} !=on' >> /usr/local/etc/apache24/httpd.conf
echo 'RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]' >> /usr/local/etc/apache24/httpd.conf

# Apps configuration PHPPgAdmin
sed -i '' 's%Require ip 127.0.0.1 xx.xx.xx.xx%Require ip 127.0.0.1 ${JAIL_IP}%g' /usr/local/etc/apache24/Includes/phppgadmin.conf
cp /usr/local/etc/apache24/Includes/phppgadmin.conf.sample /usr/local/etc/apache24/Includes/phppgadmin.conf
chown -R www:www /usr/local/www/phpPgAdmin

sysrc php_fpm restart
service apache24 restart
service postgresql restart
