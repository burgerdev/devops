#!/bin/bash

apt-get install default-jdk

useradd -m -k /etc/skel elasticsearch

curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.0.2.tar.gz | tar xz -C /usr/local/lib/

ln -s /usr/local/lib/elasticsearch-5.0.2/bin/elasticsearch /usr/local/bin/

chown -R elasticsearch: /usr/local/lib/elasticsearch-5.0.2

cat >/etc/systemd/system/elasticsearch.service <<EOF
[Unit]
Description=Elasticsearch

[Service]
Type=simple
ExecStart=/usr/local/bin/elasticsearch
User=elasticsearch
WorkingDirectory=/tmp

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start elasticsearch.service
