pkg install -y php82-gettext php82-intl php82-composer php82-dom php82-pdo php82-simplexml php82-tokenizer php82-pdo_mysql
# PHP Frontend
cd /usr/local/www; git clone https://github.com/poweradmin/poweradmin.git
chown -R www:www /usr/local/www/poweradmin