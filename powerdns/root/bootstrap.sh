SECRET=$(uuidgen | tr -d '-' | head -c64)
sed -i -e "s|\$cfg\['blowfish_secret'\] = .*;|\$cfg['blowfish_secret'] = \\\sodium_hex2bin('$SECRET');|" /usr/local/www/phpMyAdmin/config.inc.php

echo 'Verify .....'
grep "blowfish_secret" /usr/local/www/phpMyAdmin/config.inc.php

# Configuration PHP
cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini
sed -i '' 's|;date.timezone =|date.timezone ="Asia/Jakarta"|' /usr/local/etc/php.ini
#sed -i '' 's|mysqli.default_socket =|mysqli.default_socket =\/var\/run\/mysql\/mysql.sock|' /usr/local/etc/php.ini
