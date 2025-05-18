pkg install -y wazuh-server

cp /etc/localtime /var/ossec/etc
openssl req -x509 -batch -nodes -days 365 -newkey rsa:2048 -subj "/C=US/ST=California/CN=Wazuh/" -keyout /var/ossec/etc/sslmanager.key -out /var/ossec/etc/sslmanager.cert
chmod 640 /var/ossec/etc/sslmanager.key
chmod 640 /var/ossec/etc/sslmanager.cert

cp wazuh/var/ossec/etc/ossec.conf /var/ossec/etc
cp wazuh/var/ossec/etc/ossec.conf /var/ossec/etc
chmod 660 /var/ossec/etc/ossec.conf
chown root:wazuh /var/ossec/etc/ossec.conf

cp /usr/local/etc/wazuh-server/filebeat.yml /usr/local/etc/beats/
chown root:wheel /usr/local/etc/beats/filebeat.yml

cp wazuh/usr/local/etc/logstash/logstash.conf /usr/local/etc/logstash/
cp /usr/local/etc/wazuh-server/wazuh-template.json /usr/local/etc/logstash/
chown root:wheel /usr/local/etc/logstash/logstash.conf