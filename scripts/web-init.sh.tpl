#!/bin/bash
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-pip
pip3 install flask mysql-connector-python
cat > /home/azureuser/app.py <<EOF
from flask import Flask
import mysql.connector

app = Flask(__name__)

@app.route("/")
def index():
    conn = mysql.connector.connect(
        host="${db_host}",
        port=3306,
        user="root",
        database="demo"
    )
    cursor = conn.cursor()
    cursor.execute("SELECT message FROM test_table LIMIT 1")
    row = cursor.fetchone()
    conn.close()
    return row[0] if row else "Ingen melding funnet"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
EOF
chown azureuser:azureuser /home/azureuser/app.py
cat > /etc/systemd/system/myflask.service <<SYS
[Unit]
Description=Flask App
After=network.target

[Service]
WorkingDirectory=/home/azureuser
ExecStart=/usr/bin/python3 /home/azureuser/app.py
Restart=always

[Install]
WantedBy=multi-user.target
SYS
systemctl daemon-reload
systemctl enable myflask
systemctl start myflask
