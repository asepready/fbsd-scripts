sed -e "s|quarterly|latest|g" -i.bak /etc/pkg/FreeBSD.conf

cd /root/; fetch "https://people.freebsd.org/~acm/ports/wazuh/wazuh-gen-certs.tar.gz"
cd /root/; tar xvfz wazuh-gen-certs.tar.gz
echo "dashboard_ip=0.0.0.0" > /root/wazuh-gen-certs/dashboard.lst
echo "indexer1_ip=127.0.0.1" > /root/wazuh-gen-certs/indexer.lst
echo "server1_ip=127.0.0.1" > /root/wazuh-gen-certs/server.lst
cd /root/wazuh-gen-certs; echo y | sh gen-certs.sh

sh /wazuh/indexer.sh
sh /wazuh/server.sh
sh /wazuh/dashboard.sh

cp wazuh/root/pre-opensearch-init.sh /root/; chown root:wheel /root/pre-opensearch-init.sh
cp wazuh/root/post-opensearch-init.sh /root/; chown root:wheel /root/post-opensearch-init.sh

sh /root/pre-opensearch-init.sh
rm /root/pre-opensearch-init.sh

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
