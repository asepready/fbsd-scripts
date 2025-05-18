pkg install -y bash wazuh-indexer openjdk17

cp /usr/local/etc/wazuh-indexer/wazuh-indexer.yml /usr/local/etc/opensearch/opensearch.yml
sed -e "s,10.0.0.10,127.0.0.1,g" -i "" /usr/local/etc/opensearch/opensearch.yml
#chown root:wheel /usr/local/etc/opensearch/opensearch.yml

mkdir -p /usr/local/etc/opensearch/certs/
cp /root/wazuh-gen-certs/wazuh-certificates/admin.pem /usr/local/etc/opensearch/certs/
cp /root/wazuh-gen-certs/wazuh-certificates/admin-key.pem /usr/local/etc/opensearch/certs/
cp /root/wazuh-gen-certs/wazuh-certificates/indexer1.pem /usr/local/etc/opensearch/certs/
cp /root/wazuh-gen-certs/wazuh-certificates/indexer1-key.pem /usr/local/etc/opensearch/certs/
cp /root/wazuh-gen-certs/wazuh-certificates/root-ca.pem /usr/local/etc/opensearch/certs/
chown -R opensearch:opensearch /usr/local/etc/opensearch/certs
chmod -R 640 /usr/local/etc/opensearch/certs

cd /usr/local/etc/opensearch/opensearch-security; sh -c 'for i in $(ls *.sample ) ; do cp -p ${i} $(echo ${i} | sed "s|.sample||g") ; done'

sysctl security.bsd.unprivileged_mlock=1