# Cert Renew

Obtain a fresh `admin.conf` for a `kubeadm` Kubernetes installation.

```sh
kubectl apply -f ./renew-admin-conf.yaml

umask 077
kubectl cp serve-admin-conf-0:/etc/kubernetes/admin.conf /dev/shm/admin.conf

kubectl delete -f ./renew-admin-conf.yaml
```
