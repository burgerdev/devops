#!/bin/bash

## !!!! this file retrieves the pod network insecurely !!!!

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-$(lsb_release -cs) main" >/etc/apt/sources.list.d/kubernetes.list
apt-get update -qq
apt-get install -qq kubelet kubeadm kubectl kubernetes-cni

if [[ "$KUBEROLE" == "master" ]];
then
    kubeadm init --pod-network-cidr=192.168.0.0/16
    export KUBECONFIG=/etc/kubernetes/admin.conf
    echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /root/.bashrc
    kubectl taint nodes --all node-role.kubernetes.io/master-
    kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
    kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
fi
