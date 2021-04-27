# Rancher

This document describes how to install Rancher in isolated VM with kind cluster and helm. 

## Prerequisites
1. Kubernetes cluster - [Single cluster creation](./docs/kind-single-node-cluster.md)

2. Helm

## Rancher installation via Helm Chart
Rancher is installed using the Helm package manager for Kubernetes. Helm charts provide templating syntax for Kubernetes YAML manifest documents.

### Add the Helm Chart Repository
Use helm repo add command to add the Helm chart repository that contains charts to install Rancher. For more information about the repository choices and which is best for your use case, see [Choosing a Version of Rancher](https://confluence.ea.com/display/QEAP/3.+Installation).

```bash
$ helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
```

### Create a Namespace for Rancher
We’ll need to define a Kubernetes namespace where the resources created by the Chart should be installed. This should always be cattle-system:

```bash
$ kubectl create namespace cattle-system
```

### Choose your SSL Configuration

The Rancher management server is designed to be secure by default and requires SSL/TLS configuration. 

I don't have any certification at the moment, will use the [cert-manager](https://cert-manager.io/docs/) for our Rancher cluster. 

[Installation document](../cert-manager/README.md)

Our option is:
* Rancher-generated TLS certificate: In this case, you will need to install cert-manager into the cluster. Rancher utilizes cert-manager to issue and maintain its certificates. Rancher will generate a CA certificate of its own, and sign a cert using that CA. cert-manager is then responsible for managing that certificate.


### Install Rancher with Helm and Your Chosen Certificate Option

The default is for Rancher to generate a CA and uses cert-manager to issue the certificate for access to the Rancher server interface.

```bash
$ helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.coolexplorer.io \
  --set ingress.tls.source=letsEncrypt \
  --set letsEncrypt.email=<your-email-address>
```

Wait for Rancher to be rolled out:

```bash
$ kubectl -n cattle-system rollout status deploy/rancher
Waiting for deployment "rancher" rollout to finish: 0 of 3 updated replicas are available...
deployment "rancher" successfully rolled out
```

### Add hostname into `/etc/host`

To connect the Rancher ui using the host name we added when create Rancher, need to add the hostname into `/etc/host`

```bash
$ sudo vi /etc/host
...
127.0.0.1   rancher.coolexplorer.io
...
```

### Connect to Rancher

You can see the Rancher UI when you input `https://rancher.coolexplorer.io:8443`.
