#!/bin/bash

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
kubectl create namespace cattle-system

kubectl -n cattle-system create secret generic tls-ca \
  --from-file=cacerts.pem=./tls.crt.pem
helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.coolexplorer.io \
  --set ingress.tls.source=secret \
  --set privateCA=true