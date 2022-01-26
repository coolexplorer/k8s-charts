# Kafka

## Prerequisites
- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart
To install the chart with the release name my-release:

```shell
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/kafka
```

## Uninstalling the Chart
To uninstall/delete the my-release deployment:

```shell
helm delete my-release
```