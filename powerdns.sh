. ./components/openssl.sh
. ./components/nginx.sh
. ./components/php.sh
. ./components/mysql.sh

# Install PowerDNS and configure it
pkg install -y phpMyAdmin5-php82 php82-mysqli php82-fileinfo php82-session php82-curl dns/powerdns

cd ~/fbsd-scripts
cp -r ./powerdns/usr /
cp -r ./powerdns/root /

mysql -u root -e "CREATE DATABASE IF NOT EXISTS powerdns;"
mysql -u root -e "CREATE USER IF NOT EXISTS dns@'localhost' identified by 'dnspass';"
mysql -u root -e "GRANT ALL PRIVILEGES on powerdns.* to dns@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"

cd /usr/local/share/doc/powerdns/; mysql -u root powerdns < schema.mysql.sql
cd /usr/local/www; git clone https://github.com/poweradmin/poweradmin.git

chown -R www:www /usr/local/www/poweradmin

sysrc pdns_enable=yes
service pdns start