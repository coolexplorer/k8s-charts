# Single node cluster for Rancher 

In this document, I will describe how to create the single node cluster using kind. I've already written the document related to the Kubernetes playground cluster with 1 master and 2 workers. Refer to [this](../kind/README.md).

## Create the kind config file

I'm going to create the single node cluster config file like below. My playground cluster uses port `80` and `443` for their Ingress so changed the port number for the cluster of Rancher.

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 8080
    protocol: TCP
  - containerPort: 443
    hostPort: 8443
    protocol: TCP
  extraMounts:
  - hostPath: ./kind-pvc-hostpath.yaml
    containerPath: /kind/manifests/default-storage.yaml
  - hostPath: ./data/hostpath-provisioner
    containerPath: /tmp/hostpath-provisioner
```

### Ingress controller - Ingress NGINX
#### Installation
```bash
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
```

Waiting until is ready.

```bash
$ kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
  ```