# cert-manager

## Create the namespace for cert-manager

```bash
$ kubectl create namespace cert-manager
```

## Add the Jetstack Helm repository

```bash
$ helm repo add jetstack https://charts.jetstack.io
$ helm repo update
```

## Install cert-manager via Helm

Install the CustomResourceDefinition resources using kubectl

```bash
$ kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.3.1/cert-manager.crds.yaml
```

To install the cert-manager Helm chart:

```bash
$ helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.0.4
```

Once you’ve installed cert-manager, you can verify it is deployed correctly by checking the cert-manager namespace for running pods

```bash
$ kubectl get pods -n cert-manager 

NAME                                       READY   STATUS    RESTARTS   AGE
cert-manager-7998c69865-cvvr2              1/1     Running   0          2m44s
cert-manager-cainjector-7b744d56fb-vtwgt   1/1     Running   0          2m44s
cert-manager-webhook-7d6d4c78bc-jrfs9      1/1     Running   0          2m44s
```
