#!/bin/bash

cat >>/etc/security/limits.conf <<EOF
root soft nofile 65536
root hard nofile 65536
* soft nofile 65536
* hard nofile 65536
EOF

curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-xenial-td-agent2.sh | sh

es=`which elasticsearch`

if [[ "$es" != "" ]];
then
cat >>/etc/td-agent/td-agent.conf <<EOF

<match *.**>
  @type elasticsearch
  logstash_format true
  flush_interval 10s # for testing
</match>
EOF

td-agent-gem install fluent-plugin-elasticsearch --no-document
systemctl restart td-agent.service
fi
