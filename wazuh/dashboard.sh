pkg install wazuh-dashboard

cd /root/; fetch "https://people.freebsd.org/~acm/ports/wazuh/freebsd-logo.png"
cd /root/; fetch "https://people.freebsd.org/~acm/ports/wazuh/freebsd-mark-logo.png"
mv /root/freebsd-logo.png /usr/local/www/opensearch-dashboards/src/core/server/core_app/assets/logos/
mv /root/freebsd-mark-logo.png /usr/local/www/opensearch-dashboards/src/core/server/core_app/assets/logos/

cp wazuh/usr/local/etc/opensearch-dashboards/opensearch_dashboards.yml /usr/local/etc/opensearch-dashboards/
chown root:wheel /usr/local/etc/opensearch-dashboards/opensearch_dashboards.yml

mkdir -p /usr/local/etc/opensearch-dashboards/certs/
cp /root/wazuh-gen-certs/wazuh-certificates/dashboard.pem /usr/local/etc/opensearch-dashboards/certs/
cp /root/wazuh-gen-certs/wazuh-certificates/dashboard-key.pem /usr/local/etc/opensearch-dashboards/certs/
cp /root/wazuh-gen-certs/wazuh-certificates/root-ca.pem /usr/local/etc/opensearch-dashboards/certs/
chmod -R 640 /usr/local/etc/opensearch-dashboards/certs
chown -R www:www /usr/local/etc/opensearch-dashboards/certs
