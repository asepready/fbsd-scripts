=====
Message from wazuh-manager-4.12.0:

--
Wazuh Manager was installed

1) Copy /etc/locatime to /var/ossec/etc directory

   # cp /etc/localtime /var/ossec/etc

2) You must edit /var/ossec/etc/ossec.conf.sample for your setup and rename/copy
   it to ossec.conf.

   Take a look wazuh manager configuration at the following url:

   https://documentation.wazuh.com/current/user-manual/manager/index.html

3) Move /var/ossec/etc/client.keys.sample to /var/ossec/etc/client.keys. This
   file is used to store all agents credentials connected to wazuh-manager

   # mv /var/ossec/etc/client.keys.sample /var/ossec/etc/client.keys

4) You can find additional useful files installed at

  # /var/ossec/packages_files/manager_installation_scripts

5) Do not forget generate auth certificate

  # openssl req -x509 -batch -nodes -days 365 -newkey rsa:2048 \
	-subj "/C=US/ST=California/CN=Wazuh/" \
	-keyout /var/ossec/etc/sslmanager.key -out /var/ossec/etc/sslmanager.cert
  # chmod 640 /var/ossec/etc/sslmanager.key
  # chmod 640 /var/ossec/etc/sslmanager.cert

6) FreeBSD rules, decoders and SCA files are installed by default. For more
   information about updates take a look at:

   https://github.com/alonsobsd/wazuh-freebsd
 
   Decoders and rules are used for extract some /var/log/userlog and 
   /var/log/messages entries from FreeBSD agents. It is necessary add a localfile
   entry to /var/ossec/etc/ossec.conf

  <localfile>
    <log_format>syslog</log_format>
    <location>/var/log/userlog</location>
  </localfile>
  
7) Add Wazuh manager to /etc/rc.conf

  # sysrc wazuh_manager_enable="YES"

  or
  
  # service wazuh-manager enable

8) Start Wazuh manager

  # service wazuh-manager start

9) Enjoy it ;)
=====
Message from wazuh-server-4.12.0:

--
Wazuh server components were installed

1) Wazuh server componenets are based on Wazuh manager and Filebeat projects.
   This guide help you to adapt wazuh configuration for it works on FreeBSD
   using apps are part of ports tree. We are using an alternative way to
   configure wazuh server components on FreeBSD. It is necessary configure
   logstash between filebeat and opensearch because FreeBSD does not include
   versions lesser or equal to 7.16.x of Filebeat into ports tree.

2) Do not forget take a look to wazuh-manager post install message to configure
   the wazuh-server component.

   # pkg info -D -x wazuh-manager | less

3) Copy /usr/local/etc/wazuh-server/filebeat.yml to /usr/local/etc/beats/
   directory

4) Copy /usr/local/etc/wazuh-server/logstash.yml and /usr/local/etc/wazuh-server/wazuh-template.json
   files to /usr/local/etc/logstash/ directory

5) You can use my own version of wazuh certificates generator for generate
   root, admin, indexer, server and dashboard certificates used by wazuh
   components.

   https://people.freebsd.org/~acm/ports/wazuh/wazuh-gen-certs.tar.gz

6) Edit filebeat.yml and logstash.yml files and changes options accord to your
   setup. For example host, ssl, filter, etc. Sample files can give you a good
   guide about that.

7) Install logstash-output-opensearch plugin

   # cd /usr/local/logstash/bin
   # sh -c "JAVA_HOME=/usr/local/openjdk11 ./logstash-plugin install logstash-output-opensearch"

8) Check if logstash-output-opensearch plugin was installed

   # sh -c "JAVA_HOME=/usr/local/openjdk11 ./logstash-plugin list | grep logstash-output-opensearch"

9) Add Filebeat and Logstash to /etc/rc.conf

   # sysrc filebeat_enable="YES"
   # sysrc logstash_enable="YES"

10) Start Filebeat and Logstash services
   
   # service filebeat start
   # service logstash start

11) You can look more useful information at the following link:

    https://documentation.wazuh.com/current/installation-guide/wazuh-server/step-by-step.html

    Take on mind wazuh arquitecture on FreeBSD is configurated not similar like
    you can read at wazuh guide. Some times you could decided configure logstash
    on another host. If it is your case you must adapt some points in this guide.

12) Enjoy it
