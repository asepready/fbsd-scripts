# Include
. ./femp-mariadb.sh

# Install phpPgAdmin and configure it
pkg install -y php82-ctype php82-curL php82-dom php82-fileinfo php82-filter php82-mbstring php82-pdo php82-session php82-tokenizer php82-xml php82-xmlwriter php82-composer php82-mysqli php82-pdo_mysql php82-sqlite3 php82-pdo_sqlite

cd /usr/local/www; composer create-project --prefer-dist laravel/laravel laravel "11.*"
chown -R www:www /usr/local/www/laravel

service php_fpm restart