#!/bin/sh

github_user="${GITHUB_USER:-burgerdev}"
home="${HOME:-/root}"

mkdir -p "$home/.ssh"
chmod g=,o= "$home/.ssh"

curl -s "https://api.github.com/users/${github_user}/keys"|grep key|awk  '{print $2 " " $3}'|sed 's/"//g' >> "${home}/.ssh/authorized_keys"
