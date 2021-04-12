#!/bin/bash

# kind installation
brew install kind

### Cluster 
# cluster installation with default (Latest kubenetes version)
kind create cluster --config multi-nodes-config.yaml

# check the clusters
kind get clusters


### Ingress
# install ingres NGINX
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

# Wait for creating ingress NGINX components
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

### Load balancer
## Metallb
# Create Metallb namespace
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/namespace.yaml

# Create the memberlist secrets
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" 

# Apply metallb manifest 
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/metallb.yaml

# Apply metallb configuration
kubectl apply -f https://kind.sigs.k8s.io/examples/loadbalancer/metallb-configmap.yaml

