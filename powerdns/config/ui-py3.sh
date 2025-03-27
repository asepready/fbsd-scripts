pkg install -y node18 yarn-node18 python311 py311-pip py311-pipenv
pkg install -y py311-pkgconfig libxml2 libxslt

# Python Frontend
cd /usr/local/www; git clone https://github.com/ngoduykhanh/PowerDNS-Admin.git
cd /usr/local/www/PowerDNS-Admin; python3.11 -m venv ./venv
. venv/bin/activate
pip install -r requirements.txt
