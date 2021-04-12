# ingress-controller

To use Ingress in Kubernetes, I'm going to use the nginx [ingress controller](https://kubernetes.github.io/ingress-nginx/).

## Get Repo Info
```console
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```

## Install Chart

```console
# Helm 3
$ helm install ingress-nginx ingress-nginx/ingress-nginx
```

## Uninstall Chart

```console
# Helm 3
$ helm uninstall ingress-nginx
```
