#!/bin/bash

set -e

for f in ubuntu-basic-packages add-dotfiles add-github-public-keys ubuntu-docker-setup ubuntu-kubernetes-setup
do
    curl https://raw.githubusercontent.com/burgerdev/devops/master/$f.sh | bash
done
