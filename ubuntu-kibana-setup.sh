#!/bin/bash

app_user=kibana
kibana_ver=5.4.0

useradd -m -k /etc/skel $app_user

curl https://artifacts.elastic.co/downloads/kibana/kibana-${kibana_ver}-linux-x86_64.tar.gz|tar xz -C /usr/local/lib

app_dir=/usr/local/lib/kibana-${kibana_ver}-linux-x86_64

ln -s ${app_dir}/bin/kibana /usr/local/bin/

chown -R $app_user: /usr/local/lib/elasticsearch-5.0.2

cat >/etc/systemd/system/kibana.service <<EOF
[Unit]
Description=Kibana
[Service]
Type=simple
ExecStart=/usr/local/bin/kibana
User=$app_user
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start kibana.service
