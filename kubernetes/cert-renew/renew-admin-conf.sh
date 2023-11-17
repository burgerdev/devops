#!/bin/sh

set -ex

cleanup() {
    : kubectl delete -f ./renew-admin-conf.yaml >&2
}

trap cleanup EXIT

kubectl apply -f ./renew-admin-conf.yaml --wait >&2
kubectl wait --for=condition=complete job/renew-admin-conf >&2

kubectl cp serve-admin-conf-0:/etc/kubernetes/admin.conf "${1:-/dev/stdout}"
