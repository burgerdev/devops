#!/bin/bash

## !!!! this file retrieves the pod network insecurely !!!!

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl kubernetes-cni

if [[ "$KUBEROLE" == "master" ]];
then
    kubeadm init
    export KUBECONFIG=/etc/kubernetes/admin.conf
    echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /root/.bashrc
    kubectl taint nodes --all node-role.kubernetes.io/master-
    kubectl apply -f http://docs.projectcalico.org/v2.1/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml
fi
