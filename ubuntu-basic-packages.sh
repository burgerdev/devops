#!/bin/sh

export DEBIAN_FRONTEND=noninteractive

apt-get update -qq
apt-get upgrade -qq

apt-get install -qq \
    vim most screen htop pv \
    curl wget net-tools netcat \
    make git etckeeper

# set up git
git config --global user.name "${GIT_AUTHOR_NAME:-Markus Rudy}"
git config --global user.email "${GIT_AUTHOR_EMAIL:-markus@rudymentaer.de}"
