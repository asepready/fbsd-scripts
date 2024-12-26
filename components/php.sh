# Install PHP and configure it
pkg install -y php82

cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini
sed -i '' 's%;listen.owner = www%listen.owner = www%g' /usr/local/etc/php-fpm.d/www.conf
sed -i '' 's%;listen.group = www%listen.group = www%g' /usr/local/etc/php-fpm.d/www.conf
sed -i '' 's%;listen.mode = 0660%listen.mode = 0660%g' /usr/local/etc/php-fpm.d/www.conf

sysrc php_fpm_enable=YES
service php_fpm start
