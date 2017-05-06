#!/bin/sh

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -yq

apt-get install -yq \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install -yq docker-ce

systemctl restart docker.service
