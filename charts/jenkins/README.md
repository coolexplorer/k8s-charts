# Jenkins Charts

## Get Repo Info
```console
helm repo add jenkins https://charts.jenkins.io
helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Install Chart

```console
# Helm 3
$ helm install -f values.yaml jenkins jenkins/jenkins
```

_See [configuration](#configuration) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Uninstall Chart

```console
# Helm 3
$ helm uninstall jenkins
```

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._


## Upgrade Chart

Run below command after changing the values.yaml
```console
# Helm 3
$ helm upgrade -f values.yaml jenkins/jenkins
```

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

## Pull chart

If you want to pull the chart from repo, run below command.
```console
$ helm pull jenkins/jenkins
```

Extract tgz file
```console
$ tar -xvzf jenkins-<version>.tgz
```
