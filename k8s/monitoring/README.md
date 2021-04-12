# Prometheus

This is the document for installing Kubernetes monitoring system with Prometheus.

## Get Repo Info
```console
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics
helm repo update
```

## Install Chart
```console
# Helm
$ helm install prometheus prometheus-community/prometheus
```

## Dependency
By default this chart installs additional, dependent charts:

* stable/kube-state-metrics

To disable the dependency during installation, set kubeStateMetrics.enabled to false.

## Uninstal Chart
```console
# Helm
$ helm uninstall prometheus
```

## Upgrade Chart
```console
$ helm upgrade prometheus prometheus-community/prometheus --install
```

