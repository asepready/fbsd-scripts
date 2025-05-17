pkg install -y wazuh-dashboard wazuh-indexer wazuh-server

# Genarate certificates
cd /root/; fetch "https://people.freebsd.org/~acm/ports/wazuh/wazuh-gen-certs.tar.gz"
cd /root/; tar xvfz wazuh-gen-certs.tar.gz
echo 'dashboard_ip=127.0.0.1' > /root/wazuh-gen-certs/dashboard.lst
echo 'indexer1_ip=127.0.0.1' > /root/wazuh-gen-certs/indexer.lst
echo 'server1_ip=127.0.0.1' > /root/wazuh-gen-certs/server.lst
cd /root/wazuh-gen-certs; echo y | sh gen-certs.sh

mkdir -p /usr/local/etc/opensearch/certs
cp /root/wazuh-gen-certs/wazuh-certificates/admin.pem /usr/local/etc/opensearch/certs/
cp /root/wazuh-gen-certs/wazuh-certificates/admin-key.pem /usr/local/etc/opensearch/certs/
cp /root/wazuh-gen-certs/wazuh-certificates/indexer1.pem /usr/local/etc/opensearch/certs/
cp /root/wazuh-gen-certs/wazuh-certificates/indexer1-key.pem /usr/local/etc/opensearch/certs/
cp /root/wazuh-gen-certs/wazuh-certificates/root-ca.pem /usr/local/etc/opensearch/certs/
chmod -R 640 /usr/local/etc/opensearch/certs
chown -R opensearch:opensearch /usr/local/etc/opensearch/certs

cp /usr/local/etc/wazuh-indexer/wazuh-indexer.yml /usr/local/etc/opensearch/opensearch.yml
sed -e "s,network.host: "10.0.0.10",network.host: "127.0.0.1",g" -i "" /usr/local/etc/opensearch/opensearch.yml

cd /usr/local/etc/opensearch/opensearch-security; sh -c 'for i in $(ls *.sample ) ; do cp -p ${i} $(echo ${i} | sed "s|.sample||g") ; done'
cd /usr/local/lib/opensearch/plugins/opensearch-security/tools; sh -c "OPENSEARCH_JAVA_HOME=/usr/local/openjdk${v_jdk} ./hash.sh -p adminpass"

# enable and start service
SYSRC wazuh_manager_enable=YES
SYSRC filebeat_enable=YES
SYSRC logstash_enable=YES
SYSRC opensearch_enable=YES
SYSRC opensearch_dashboards_enable=YES
SYSRC opensearch_dashboards_syslog_output_enable=YES

SERVICE opensearch start
