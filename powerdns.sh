. ./components/mysql.sh

# Install PowerDNS and configure it
pkg install -y dns/powerdns

sysrc pdns_enable=yes
service pdns start