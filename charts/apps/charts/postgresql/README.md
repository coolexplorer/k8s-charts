# Postgresql
This document describes how to install PostgreSQL using helm chart which made by bitnami.
I will create my own values.yaml file to change some configurations of PostgreSQL. 

## Configuration
I've changed some configuration for my test environment. First of all, I created Persistence Volume and Persistence Volume claim for PostgreSQL. 
I often turn on and off my DB because of limited resources, so managed volume by me is essential for me. 

```yaml
persistence:
    existingClaim: "postgresql-pvc"
    size: 1Gi
```

Also, I set up my own password. If not, helm chart makes random secret for password. This random password is hard to manage because I should update this on my service configuration. 

```yaml
global:
    postgresql:
    auth:
      postgresPassword: "password"
      username: "coolexplorer"
      password: "password"
      database: "auth"
```

## Installation

```shell
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install postgresql -f values.yaml bitnami/postgresql
```