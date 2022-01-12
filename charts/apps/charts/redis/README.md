# Redis
This document describe how to install Redis in the kubernetes. 
There are two options to install it, using helm chart of bitnami and using kubernetes operator. 
In this documet, I will use bitnami helm chart. About the volume, my environment is local with docker kubernetes.
So, I will create my own PV for this. 

> Redis supports the cluster environment - if you should use large data (over 100GB) then, you need to use the cluster and shards data to multiple instances. In this environemnt is for setting up the development environment for me, so I will use the master-slave architecture. 

## Installation
### Add Helm repository
```shell
$ helm repo add bitnami https://charts.bitnami.com/bitnami
```

### Installation
This is the default installation command.

```shell
$ helm install my-release bitnami/redis
```

However, I will use my own PV and will create 1 replica(3 is a default option.). For this, I wil craete my own [values.yaml](./values.yaml) file.
```shell
$ helm install -f values.yaml my-release bitnami/redis
```

### Uninstallation
```shell
$ helm delete my-release
```

## Persistance volume
### Storage class
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: redis-local-storage
reclaimPolicy: Retain
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: Immediate
```

### PersistentVolumeClaim
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: redis-pvc
spec:
  storageClassName: redis-local-storage
  resources:
    requests:
      storage: 5Gi
  accessModes:
    - ReadWriteOnce
```

### PersistentVolume
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mypv
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: reids-local-storage
  local:
    path: /Users/kimseunghwan/pv/redis-data
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - docker-desktop
```

## Get Password
Bitnami helm chart creates the password automatically and you can see that with below command.

```shell
$ export REDIS_PASSWORD=$(kubectl get secret --namespace default redis -o jsonpath="{.data.redis-password}" | base64 --decode)
```

## Test client
```shell
To connect to your Redis&trade; server:

1. Run a Redis&trade; pod that you can use as a client:

   kubectl run --namespace default redis-client --restart='Never'  --env REDIS_PASSWORD=$REDIS_PASSWORD  --image docker.io/bitnami/redis:6.2.6-debian-10-r94 --command -- sleep infinity

   Use the following command to attach to the pod:

   kubectl exec --tty -i redis-client \
   --namespace default -- bash

2. Connect using the Redis&trade; CLI:
   REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h redis-master
   REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h redis-replicas
```