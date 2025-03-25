# Package 
pkg install -y mongodb60 npm

# enable and start
sysrc mongod_enable="YES"
service mongod start

npm install mongosh
npx mongosh mongodb://127.0.0.1:27017