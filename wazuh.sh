JAIL_IP=127.0.0.1
# install required packages
pkg install -y wazuh-indexer

# copy files
cp wazuh/etc /
cp wazuh/usr /

sed -e "s,%%SERVER_IP%%,$JAIL_IP,g" -i "" /usr/local/etc/opensearch/opensearch.yml
cd /root/; fetch "https://people.freebsd.org/~acm/ports/wazuh/wazuh-gen-certs.tar.gz"
cd /root/; tar xvfz wazuh-gen-certs.tar.gz
echo 'dashboard_ip="'$JAIL_IP'"' > /root/wazuh-gen-certs/dashboard.lst
echo 'indexer1_ip="'$JAIL_IP'"' > /root/wazuh-gen-certs/indexer.lst
echo 'server1_ip="'$JAIL_IP'"' > /root/wazuh-gen-certs/server.lst
cd /root/wazuh-gen-certs; echo y | sh gen-certs.sh

mkdir -p /usr/local/etc/opensearch/certs
cp /root/wazuh-gen-certs/wazuh-certificates/admin.pem /usr/local/etc/opensearch/certs/
cp /root/wazuh-gen-certs/wazuh-certificates/admin-key.pem /usr/local/etc/opensearch/certs/
cp /root/wazuh-gen-certs/wazuh-certificates/indexer1.pem /usr/local/etc/opensearch/certs/
cp /root/wazuh-gen-certs/wazuh-certificates/indexer1-key.pem /usr/local/etc/opensearch/certs/
cp /root/wazuh-gen-certs/wazuh-certificates/root-ca.pem /usr/local/etc/opensearch/certs/
chmod -R 640 /usr/local/etc/opensearch/certs
chown -R opensearch:opensearch /usr/local/etc/opensearch/certs

cd /usr/local/etc/opensearch/opensearch-security; sh -c 'for i in $(ls *.sample ) ; do cp -p ${i} $(echo ${i} | sed "s|.sample||g") ; done'
cd /usr/local/lib/opensearch/plugins/opensearch-security/tools; sh -c "OPENSEARCH_JAVA_HOME=/usr/local/openjdk${v_jdk} ./hash.sh -p adminpass"

# enable and start service
SYSRC opensearch_enable=YES
SYSRC opensearch_java_home=/usr/local/openjdk${v_jdk}

SERVICE opensearch start
