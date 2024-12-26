# Install Apache and configure it
pkg install -y apache24 

sed -i '' 's%ServerAdmin you@example.com%ServerAdmin admin@$localhost%g' /usr/local/etc/apache24/httpd.conf
sed -i '' 's%#ServerName www.example.com:80%ServerName $localhost:80%g' /usr/local/etc/apache24/httpd.conf
sed -i '' 's%Options Indexes FollowSymLinks%Options FollowSymLinks%g' /usr/local/etc/apache24/httpd.conf
sed -i '' 's%AllowOverride None%AllowOverride All%g' /usr/local/etc/apache24/httpd.conf
sed -i '' 's%DirectoryIndex index.html%DirectoryIndex index.html index.php index.cgi%g' /usr/local/etc/apache24/httpd.conf
sed -i '' 's/CustomLog "\/var\/log\/httpd-access.log" common/#CustomLog "\/var\/log\/httpd-access.log" common/g' /usr/local/etc/apache24/httpd.conf
sed -i '' 's/#CustomLog "\/var\/log\/httpd-access.log" combined/CustomLog "\/var\/log\/httpd-access.log" combined/g' /usr/local/etc/apache24/httpd.conf
sed -i '' '/httpd-default.conf/s/#Include/Include/g' /usr/local/etc/apache24/httpd.conf
sed -i '' 's%ServerTokens Full%ServerTokens Prod%g' /usr/local/etc/apache24/extra/httpd-default.conf

sysrc apache24_enable=YES
service apache24 start
