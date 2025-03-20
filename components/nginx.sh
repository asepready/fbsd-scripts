# Install Apache and configure it
pkg install -y nginx

cp ./config/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf

sysrc nginx_enable=YES
service nginx start
