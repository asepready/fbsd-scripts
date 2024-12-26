Change Password
```sh
# Password User System Account Management
root@fbsd14:~ # passwd postgres
Changing local password for postgres
New Password: psql
Retype New Password: psql
root@www:~ # su - postgres

# Login Databases;
postgres@www:~ $ psql
postgres=# ALTER USER postgres PASSWORD 'yourpasswd';
ALTER ROLE
postgres=# \q

# Managemen User;
postgres@www:~ $ createuser admin -P
postgres@www:~ $ dropuser admin

# Managemen Database;
postgres@www:~ $ createdb testdb -O admin
postgres@www:~ $ dropdb testdb

# show users and databases
postgres@www:~ $ psql -c "select usename from pg_user;"
postgres@www:~ $ psql -l

# connect to testdb
postgres@www:~ $ psql testdb
```