#!/bin/bash

## !!!! this file retrieves the pod network insecurely !!!!

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-$(lsb_release -cs) main" >/etc/apt/sources.list.d/kubernetes.list
apt-get update -qq
apt-get install -qq kubelet kubeadm kubectl kubernetes-cni

if [[ "$KUBEROLE" == "master" ]];
then
    kubeadm init
    export KUBECONFIG=/etc/kubernetes/admin.conf
    echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /root/.bashrc
    kubectl taint nodes --all node-role.kubernetes.io/master-
    kubectl apply -f http://docs.projectcalico.org/v2.1/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml
    # defunct
    # kubectl create -f https://git.io/kube-dashboard
    # enable helm by disabling RBAC, see https://stackoverflow.com/a/43513182
    kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --user=admin --user=kubelet --group=system:serviceaccounts
    kubectl apply --namespace kube-system -f https://raw.githubusercontent.com/meltwater/docker-cleanup/master/contrib/k8s-daemonset.yml
fi
