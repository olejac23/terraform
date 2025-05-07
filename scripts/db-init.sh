#!/bin/bash
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
# Allow remote MySQL connections
sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql
# Initialize database and table
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS demo;
USE demo;
CREATE TABLE IF NOT EXISTS test_table (
    id INT PRIMARY KEY AUTO_INCREMENT,
    message VARCHAR(255)
);
INSERT INTO test_table (message) VALUES ('Dette er et tegn på at databasen fungerer');
EOF
