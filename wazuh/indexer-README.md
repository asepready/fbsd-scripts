=====
Message from libinotify-20240724_1:

--
You might want to consider increasing the kern.maxfiles tunable if you plan
to use this library for applications that need to monitor activity of a lot
of files.
=====
Message from freetype2-2.13.3:

--
The 2.7.x series now uses the new subpixel hinting mode (V40 port's option) as
the default, emulating a modern version of ClearType. This change inevitably
leads to different rendering results, and you might change port's options to
adapt it to your taste (or use the new "FREETYPE_PROPERTIES" environment
variable).

The environment variable "FREETYPE_PROPERTIES" can be used to control the
driver properties. Example:

FREETYPE_PROPERTIES=truetype:interpreter-version=35 \
	cff:no-stem-darkening=1 \
	autofitter:warping=1

This allows to select, say, the subpixel hinting mode at runtime for a given
application.

If LONG_PCF_NAMES port's option was enabled, the PCF family names may include
the foundry and information whether they contain wide characters. For example,
"Sony Fixed" or "Misc Fixed Wide", instead of "Fixed". This can be disabled at
run time with using pcf:no-long-family-names property, if needed. Example:

FREETYPE_PROPERTIES=pcf:no-long-family-names=1

How to recreate fontconfig cache with using such environment variable,
if needed:
# env FREETYPE_PROPERTIES=pcf:no-long-family-names=1 fc-cache -fsv

The controllable properties are listed in the section "Controlling FreeType
Modules" in the reference's table of contents
(/usr/local/share/doc/freetype2/reference/index.html, if documentation was installed).
=====
Message from dejavu-2.37_3:

--
Make sure that the freetype module is loaded.  If it is not, add the following
line to the "Modules" section of your X Windows configuration file:

	Load "freetype"

Add the following line to the "Files" section of X Windows configuration file:

	FontPath "/usr/local/share/fonts/dejavu/"

Note: your X Windows configuration file is typically /etc/X11/XF86Config
if you are using XFree86, and /etc/X11/xorg.conf if you are using X.Org.
=====
Message from python311-3.11.12:

--
Note that some standard Python modules are provided as separate ports
as they require additional dependencies. They are available as:

py311-gdbm       databases/py-gdbm@py311
py311-sqlite3    databases/py-sqlite3@py311
py311-tkinter    x11-toolkits/py-tkinter@py311
=====
Message from openjdk17-17.0.15+6.1:

--
This OpenJDK implementation may require fdescfs(5) mounted on /dev/fd
and procfs(5) mounted on /proc for some applications.

If you have not done it yet, please do the following:

	mount -t fdescfs fdesc /dev/fd
	mount -t procfs proc /proc

To make it permanent, you need the following lines in /etc/fstab:

	fdesc	/dev/fd		fdescfs		rw	0	0
	proc	/proc		procfs		rw	0	0
=====
Message from opensearch219-2.19.1:

--
Opensearch was installed

Please see /usr/local/etc/opensearch for a sample version of
opensearch.yml.

OpenSearch requires memory locking of large amounts of RAM.
You may need to set:

sysctl security.bsd.unprivileged_mlock=1

When running within a jail, it's highly advisable to set:

enforce_statfs = 1

for the jail running opensearch instance.

If OpenSearch was built with the PLUGINS option enabled (default) it will not
start until the security plugin is properly configured.  Please refer to the
OpenSearch documentation for setting-up TLS:

https://opensearch.org/docs/security-plugin/configuration/tls
=====
Message from wazuh-indexer-4.12.0:

--
Wazuh indexer components were installed

1) Wazuh indexer is based on opensearch project. This guide help you for adapt
   wazuh configuration for it works on FreeBSD using apps are part of ports
   tree.

2) Copy /usr/local/etc/wazuh-indexer/wazuh-indexer.yml to /usr/local/etc/opensearch/opensearch.yml

3) Edit /usr/local/etc/opensearch/opensearch.yml and changes options accord to your
   setup. For example host, ssl, nodes options, etc. On this guide we will use
   like host 10.0.0.10

4) If you want use a simple way to generate wazuh infrastructure certificates
   you can use a simplified version of certificates generator script located at:

   https://people.freebsd.org/~acm/ports/wazuh/wazuh-gen-certs.tar.gz

5) Wazuh needs opensearch-security features. Rename or copy samples files
   into /usr/local/etc/opensearch/opensearch-security

   # cd /usr/local/etc/opensearch/opensearch-security
   # sh -c 'for i in $(ls *.sample ) ; do cp -p ${i} $(echo ${i} | sed "s|.sample||g") ; done'

6) You can define a custom admin password modifying internal_users.yml file into 
   /usr/local/etc/opensearch/opensearch-security/

   admin:
     hash: "$2a$12$VcCDgh2NDk07JGN0rjGbM.Ad41qVR/YFJcgHp0UGns5JDymv..TOG"

   Hash password can be generated using opensearch-security hash script tool

   # cd /usr/local/lib/opensearch/plugins/opensearch-security/tools/
   # sh -c "OPENSEARCH_JAVA_HOME=/usr/local/openjdk11 ./hash.sh -p adminpass"
   $2y$12$XaEXmp4kGQpd6t8kNH03quyvpHDQZh.nywLLp9.b0NF2DxGl8FpJK

7) Add OpenSearch to /etc/rc.conf

   # sysrc opensearch_enable="YES"

8) Start OpenSearch

  # service opensearch start

9) Finally you must initialize opensearch cluster

  # cd /usr/local/lib/opensearch/plugins/opensearch-security/tools/
  # sh -c "OPENSEARCH_JAVA_HOME=/usr/local/openjdk11 ./securityadmin.sh \
    -cd /usr/local/etc/opensearch/opensearch-security/ -cacert /usr/local/etc/opensearch/certs/root-ca.pem \
    -cert /usr/local/etc/opensearch/certs/admin.pem -key /usr/local/etc/opensearch/certs/admin-key.pem -h 10.0.0.10 -p 9200 -icl -nhnv"

10) You can look more useful information at the following link:

    https://documentation.wazuh.com/current/installation-guide/wazuh-indexer/step-by-step.html

    Take on mind wazuh arquitecture on FreeBSD is configurated not similar like
    you can read at wazuh guide

11) Testing your server installation

   # curl -k -u admin:adminpass https://10.0.0.10:9200
   # curl -k -u admin:adminpass https://10.0.0.10:9200/_cat/nodes?v

12) Enjoy it
