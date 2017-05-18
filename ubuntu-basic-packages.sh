#!/bin/sh

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -y

apt-get install -yq vim most git htop pv jq curl wget net-tools make
