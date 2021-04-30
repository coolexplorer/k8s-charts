#!/bin/bash

## cert-manager
echo "Install Rancher namespaces ..."

kubectl create namespace cattle-system

echo "Install cert-manager ..."

kubectl create namespace cert-manager

sleep 1

helm repo add jetstack https://charts.jetstack.io
helm repo update

kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.4/cert-manager.crds.yaml

sleep 1

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.0.4

sleep 60

## rancher

echo "Install rancher ...."
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update

helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.coolexplorer.cf \
  --set ingress.tls.source=letsEncrypt \
  --set letsEncrypt.email=corono1004@gmail.com \
  --version 2.5.4

kubectl -n cattle-system rollout status deploy/rancher