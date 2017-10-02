#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get update -qq
apt-get upgrade -qq

apt-get install -qq \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update -qq
apt-get install -qq docker-ce docker-compose

systemctl restart docker.service

cat >/usr/local/bin/docker-cleanup <<EOF
#!/bin/bash
docker ps -q | xargs -r docker kill
docker ps -aq | xargs -r docker rm
EOF

chmod a+x /usr/local/bin/docker-cleanup
