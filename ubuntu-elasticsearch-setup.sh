#!/bin/bash

es_ver=5.4.0
es_user=elasticsearch

apt-get install default-jdk

useradd -m -k /etc/skel ${es_user}

curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${es_ver}.tar.gz | tar xz -C /usr/local/lib/

rm -f /usr/local/bin/elasticsearch
ln -s /usr/local/lib/elasticsearch-${es_ver}/bin/elasticsearch /usr/local/bin/

chown -R ${es_user}: /usr/local/lib/elasticsearch-${es_ver}

cat >/etc/systemd/system/elasticsearch.service <<EOF
[Unit]
Description=Elasticsearch

[Service]
Type=simple
ExecStart=/usr/local/bin/elasticsearch
User=${es_user}
WorkingDirectory=/tmp

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start elasticsearch.service
