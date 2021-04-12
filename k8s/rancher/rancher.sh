#!/bin/bash
# https://confluence.ea.com/display/QEAP/3.+Installation

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
kubectl create namespace cattle-system

# refer to `Add TLS Secrets` part - https://confluence.ea.com/display/QEAP/3.+Installation
kubectl -n cattle-system create secret generic tls-ca \
  --from-file=cacerts.pem=./tls.crt.pem
helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.coolexplorer.io \
  --set ingress.tls.source=secret \
  --set privateCA=true