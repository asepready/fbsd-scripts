# Package 
pkg install mysql80-server

# enable and start apache
sysrc mysql_enable=YES
sysrc mysql_args="--bind-address=127.0.0.1"
service mysql-server start

# harden mysql
mysql -u root -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -e "DROP DATABASE IF EXISTS test"
mysql -u root -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
mysql -u root -e "FLUSH PRIVILEGES"

