# k3d
k3d is a lightweight wrapper to run k3s (Rancher Lab’s minimal Kubernetes distribution) in docker.

k3d makes it very easy to create single- and multi-node k3s clusters in docker, e.g. for local development on Kubernetes.

## Requirements

[docker](https://docs.docker.com/engine/install/)

## Installation (on macOS)

```bash
$ brew install k3d

$ k3d version
k3d version v4.4.2
k3s version latest (default)
```

## Cluster creation

Create a cluster named rancher with just a single server node:

```bash
$ k3d cluster create rancher --config single-node-config.yaml

INFO[0000] Prep: Network                                
INFO[0001] Created network 'k3d-rancher' (6748704ac43c0a7982cf3e6756edcd1166634a1af3b721e91341c1ac7713f3e5) 
INFO[0001] Created volume 'k3d-rancher-images'          
INFO[0002] Creating node 'k3d-rancher-server-0'         
INFO[0008] Pulling image 'docker.io/rancher/k3s:latest' 
INFO[0062] Creating LoadBalancer 'k3d-rancher-serverlb' 
INFO[0066] Pulling image 'docker.io/rancher/k3d-proxy:v4.4.2' 
INFO[0081] Starting cluster 'rancher'                   
INFO[0081] Starting servers...                          
INFO[0081] Starting Node 'k3d-rancher-server-0'         
INFO[0099] Starting agents...                           
INFO[0099] Starting helpers...                          
INFO[0100] Starting Node 'k3d-rancher-serverlb'         
INFO[0102] (Optional) Trying to get IP of the docker host and inject it into the cluster as 'host.k3d.internal' for easy access 
INFO[0109] Successfully added host record to /etc/hosts in 2/2 nodes and to the CoreDNS ConfigMap 
INFO[0109] Cluster 'rancher' created successfully!      
INFO[0109] --kubeconfig-update-default=false --> sets --kubeconfig-switch-context=false 
WARN[0113] Multiple kubeconfigs specified via KUBECONFIG env var: Please reduce to one entry, unset KUBECONFIG or explicitly choose an output 
INFO[0113] You can now use it like this:                
kubectl config use-context k3d-rancher
kubectl cluster-info
```

Get the new cluster’s connection details merged into your default kubeconfig (usually specified using the KUBECONFIG environment variable or the default path $HOME/.kube/config) and directly switch to the new context:

```bash
$ k3d kubeconfig merge rancher --kubeconfig-merge-default
```

Use the new cluster with kubectl, e.g.:

```bash
$ kubectl get nodes
```

> It takes some time to run all pods in your cluster, so check the status for a while.

```bash
$ kubectl get pods --all-namespaces --watch
```

## Cluster deletion

```bash
$ k3d cluster delete rancher                               
INFO[0000] Deleting cluster 'rancher'                   
INFO[0002] Deleted k3d-rancher-serverlb                 
INFO[0005] Deleted k3d-rancher-server-0                 
INFO[0005] Deleting cluster network 'k3d-rancher'       
INFO[0009] Deleting image volume 'k3d-rancher-images'   
INFO[0009] Removing cluster details from default kubeconfig... 
WARN[0009] Failed to remove cluster details from default kubeconfig 
WARN[0009] Multiple kubeconfigs specified via KUBECONFIG env var: Please reduce to one entry, unset KUBECONFIG or explicitly choose an output 
INFO[0009] Removing standalone kubeconfig file (if there is one)... 
INFO[0009] Successfully deleted cluster rancher!      
```
