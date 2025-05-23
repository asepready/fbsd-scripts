DEFAULT_IF=$(route -n get default | awk '/interface:/ {print $2}')
SERVER_IP=$(ifconfig "$DEFAULT_IF" | grep 'inet ' | awk '{print $2}')
export SERVER_IP

cp wazuh/fstab /etc/
sed -e "s|quarterly|latest|g" -i.bak /etc/pkg/FreeBSD.conf; pkg update

pkg install -y bash wazuh-indexer wazuh-server wazuh-dashboard openjdk17

openssl req -x509 -batch -nodes -days 365 -newkey rsa:2048 -subj "/C=US/ST=California/CN=Wazuh/" -keyout /var/ossec/etc/sslmanager.key -out /var/ossec/etc/sslmanager.cert
chmod 640 /var/ossec/etc/sslmanager.key
chmod 640 /var/ossec/etc/sslmanager.cert

cp /etc/localtime /var/ossec/etc
cp /usr/local/etc/wazuh-server/wazuh-template.json /usr/local/etc/logstash/

cp wazuh/var/ossec/etc/ossec.conf /var/ossec/etc
cp wazuh/var/ossec/etc/ossec.conf /var/ossec/etc
cp wazuh/usr/local/etc/beats/filebeat.yml /usr/local/etc/beats/
cp wazuh/usr/local/etc/logstash/logstash.conf /usr/local/etc/logstash/
cp wazuh/usr/local/etc/opensearch/opensearch.yml /usr/local/etc/opensearch/opensearch.yml
cp wazuh/usr/local/etc/opensearch-dashboards/opensearch_dashboards.yml /usr/local/etc/opensearch-dashboards/
cp wazuh/etc/hosts /etc/
cp wazuh/root/pre-opensearch-init.sh /root/
cp wazuh/root/post-opensearch-init.sh /root/

echo "${SERVER_IP} wazuh.bsd.com" > /etc/hosts
sed -e "s,%%SERVER_IP%%,${SERVER_IP},g" -i "" /usr/local/etc/beats/filebeat.yml
sed -e "s,%%SERVER_IP%%,${SERVER_IP},g" -i "" /usr/local/etc/logstash/logstash.conf
sed -e "s,%%SERVER_IP%%,${SERVER_IP},g" -i "" /usr/local/etc/opensearch/opensearch.yml
sed -e "s,%%SERVER_IP%%,${SERVER_IP},g" -i "" /usr/local/etc/opensearch-dashboards/opensearch_dashboards.yml
sed -e "s,%%SERVER_IP%%,${SERVER_IP},g" -i "" /root/post-opensearch-init.sh

chown root:wheel /etc/hosts
chown root:wheel /usr/local/etc/beats/filebeat.yml
chown root:wheel /usr/local/etc/logstash/logstash.conf
chown -R opensearch:opensearch /usr/local/etc/opensearch/
chmod 640 /usr/local/etc/opensearch/opensearch.yml
chown root:wheel /usr/local/etc/opensearch-dashboards/opensearch_dashboards.yml

chown root:wheel /root/pre-opensearch-init.sh
chown root:wheel /root/post-opensearch-init.sh

sh /root/pre-opensearch-init.sh
rm /root/pre-opensearch-init.sh

mkdir -p /usr/local/etc/opensearch-dashboards/certs/
mkdir -p /usr/local/etc/opensearch/certs/
cd /root/; fetch "https://people.freebsd.org/~acm/ports/wazuh/freebsd-logo.png"
cd /root/; fetch "https://people.freebsd.org/~acm/ports/wazuh/freebsd-mark-logo.png"
cd /root/; fetch "https://people.freebsd.org/~acm/ports/wazuh/wazuh-gen-certs.tar.gz"
cd /root/; tar xvfz wazuh-gen-certs.tar.gz
echo "dashboard_ip=${SERVER_IP}" > /root/wazuh-gen-certs/dashboard.lst
echo "indexer1_ip=${SERVER_IP}" > /root/wazuh-gen-certs/indexer.lst
echo "server1_ip=${SERVER_IP}" > /root/wazuh-gen-certs/server.lst
cd /root/wazuh-gen-certs; echo y | sh gen-certs.sh

chmod 660 /var/ossec/etc/ossec.conf
chown root:wazuh /var/ossec/etc/ossec.conf

cp /root/wazuh-gen-certs/wazuh-certificates/admin.pem /usr/local/etc/opensearch/certs/
chmod 640 /usr/local/etc/opensearch/certs/admin.pem
chown opensearch:opensearch /usr/local/etc/opensearch/certs/admin.pem
cp /root/wazuh-gen-certs/wazuh-certificates/admin-key.pem /usr/local/etc/opensearch/certs/
chmod 640 /usr/local/etc/opensearch/certs/admin-key.pem
chown opensearch:opensearch /usr/local/etc/opensearch/certs/admin-key.pem
cp /root/wazuh-gen-certs/wazuh-certificates/indexer1.pem /usr/local/etc/opensearch/certs/
chmod 640 /usr/local/etc/opensearch/certs/indexer1.pem
chown opensearch:opensearch /usr/local/etc/opensearch/certs/indexer1.pem
cp /root/wazuh-gen-certs/wazuh-certificates/indexer1-key.pem /usr/local/etc/opensearch/certs/
chmod 640 /usr/local/etc/opensearch/certs/indexer1-key.pem
chown opensearch:opensearch /usr/local/etc/opensearch/certs/indexer1-key.pem
cp /root/wazuh-gen-certs/wazuh-certificates/root-ca.pem /usr/local/etc/opensearch/certs/
chmod 640 /usr/local/etc/opensearch/certs/root-ca.pem
chown opensearch:opensearch /usr/local/etc/opensearch/certs/root-ca.pem

cp /root/wazuh-gen-certs/wazuh-certificates/dashboard.pem /usr/local/etc/opensearch-dashboards/certs/
chmod 640 /usr/local/etc/opensearch-dashboards/certs/dashboard.pem
chown www:www /usr/local/etc/opensearch-dashboards/certs/dashboard.pem
cp /root/wazuh-gen-certs/wazuh-certificates/dashboard-key.pem /usr/local/etc/opensearch-dashboards/certs/
chmod 640 /usr/local/etc/opensearch-dashboards/certs/dashboard-key.pem
chown www:www /usr/local/etc/opensearch-dashboards/certs/dashboard-key.pem
cp /root/wazuh-gen-certs/wazuh-certificates/root-ca.pem /usr/local/etc/opensearch-dashboards/certs/
chmod 640 /usr/local/etc/opensearch-dashboards/certs/root-ca.pem
chown www:www /usr/local/etc/opensearch-dashboards/certs/root-ca.pem

cp /root/freebsd-logo.png /usr/local/www/opensearch-dashboards/src/core/server/core_app/assets/logos/
cp /root/freebsd-mark-logo.png /usr/local/www/opensearch-dashboards/src/core/server/core_app/assets/logos/

sysrc wazuh_manager_enable=YES
sysrc filebeat_enable=YES
sysrc logstash_enable=YES
sysrc opensearch_enable=YES
sysrc opensearch_dashboards_enable=YES
sysrc opensearch_dashboards_syslog_output_enable=YES

service opensearch start

sh /root/post-opensearch-init.sh
rm /root/post-opensearch-init.sh

chmod 640 /var/ossec/etc/authd.pass
chown root:wazuh /var/ossec/etc/authd.pass

service wazuh-manager start
service filebeat start
service logstash start
service opensearch-dashboards start
