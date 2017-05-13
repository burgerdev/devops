#!/bin/bash

cat >>/etc/security/limits.conf <<EOF
root soft nofile 65536
root hard nofile 65536
* soft nofile 65536
* hard nofile 65536
EOF

curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-xenial-td-agent2.sh | sh

