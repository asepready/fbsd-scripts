# Install PostgreSQL and configure it
pkg install -y postgresql16-server

sysrc postgresql_enable=YES
service postgresql initdb
service postgresql start
