# kind 
kind is a tool for running local Kubernetes clusters using Docker container “nodes”.
kind was primarily designed for testing Kubernetes itself, but may be used for local development or CI.

If you have go (1.11+) and docker installed `GO111MODULE="on" go get sigs.k8s.io/kind@v0.10.0 && kind create cluster` is all you need!

## kind Installation

### On Linux
```console
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.10.0/kind-linux-amd64
chmod +x ./kind
mv ./kind /some-dir-in-your-PATH/kind
```

### On Mac
```console
brew install kind
```

## Usage
### Creating Cluster
Run the kind command to create the cluster - 1 master node and 2 worker nodes 
```console
kind create cluster --config multi-nodes-config.yaml
```

``` yaml
# multi-nodes-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  # Configuration for Ingress
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
- role: worker
```

Check the nodes
```console
kubectl get nodes

NAME                 STATUS   ROLES                  AGE   VERSION
kind-control-plane   Ready    control-plane,master   23m   v1.20.2
kind-worker          Ready    <none>                 22m   v1.20.2
kind-worker2         Ready    <none>                 22m   v1.20.2
```

### Ingress controller - Ingress NGINX
#### Installation
```console
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
```

Waiting until is ready.
```console
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
  ```


### Load balancer - Metallb
#### Create metallb namespace
```console
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/namespace.yaml
```
#### Create the memberlist secrets
```console
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" 
```
#### Apply metallb menifest
```console
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/metallb.yaml
```
### Wait for metallb pods
```console
kubectl get pods -n metallb-system --watch
```

#### Setup address pool used by loadbalancers
To complete layer2 configuration, we need to provide metallb a range of IP addresses it controls. We want this range to be on the docker kind network.
```console
docker network inspect -f '{{.IPAM.Config}}' kind
```

The output will contain a cidr such as 172.19.0.0/16. We want our loadbalancer IP range to come from this subclass. We can configure metallb, for instance, to use 172.19.255.200 to 172.19.255.250 by creating the configmap.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 172.19.255.200-172.19.255.250
```

Apply this contents
```console
kubectl apply -f https://kind.sigs.k8s.io/examples/loadbalancer/metallb-configmap.yaml
```

**Load balancer sample**
```yaml
kind: Service
apiVersion: v1
metadata:
  name: foo-service
spec:
  type: LoadBalancer
  selector:
    app: http-echo
  ports:
  # Default port used by the image
  - port: 5678
```
