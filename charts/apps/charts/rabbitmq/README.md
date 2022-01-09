# RabbitMQ
RabbitMQ is the most widely deployed open source message broker.
With tens of thousands of users, RabbitMQ is one of the most popular open source message brokers.

## Installation in kubernetes
RabbitMQ can be installed in kubernetes easily using RabbitMQ Cluster Kubernetes Operator. 
So, in this document, I will install RabbitMQ Cluster Kubernetes Operator on my local kubernetes environment and
then install RabbitMQ Cluster on the kubernetes. 

### RabbitMQ Cluster Kubernetes Operator Installation 
#### Using the latest configuration file
Operator installation is pretty easy. 

```shell
$ kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"
# namespace/rabbitmq-system created
# customresourcedefinition.apiextensions.k8s.io/rabbitmqclusters.rabbitmq.com created
# serviceaccount/rabbitmq-cluster-operator created
# role.rbac.authorization.k8s.io/rabbitmq-cluster-leader-election-role created
# clusterrole.rbac.authorization.k8s.io/rabbitmq-cluster-operator-role created
# rolebinding.rbac.authorization.k8s.io/rabbitmq-cluster-leader-election-rolebinding created
# clusterrolebinding.rbac.authorization.k8s.io/rabbitmq-cluster-operator-rolebinding created
# deployment.apps/rabbitmq-cluster-operator created
```

Then, you can see the components for RabbitMQ Cluster Kubernetes Operator.
```shell
$ kubectl get all -n rabbitmq-system

NAME                                             READY   STATUS    RESTARTS   AGE
pod/rabbitmq-cluster-operator-7cbf865f89-hkjlm   1/1     Running   0          22s

NAME                                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/rabbitmq-cluster-operator   1/1     1            1           22s

NAME                                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/rabbitmq-cluster-operator-7cbf865f89   1         1         1       22s
```

#### Using kubectl plugin
To install RabbitMQ using the kubectl plugin, you need to install `Krew` which is the plugin manager for kubectl command-line tool. 
You can see the way how to install all of them using plugin [here](https://www.rabbitmq.com/kubernetes/operator/kubectl-plugin.html).
> In this document, I will use the configuration file. 


### RabbitMQ Cluster Installation
> This sample is referenced from [RabbitMQ Cluster Operator repository](https://github.com/rabbitmq/cluster-operator/tree/main/docs/examples/hello-world). 

#### Crate RabbitMQ Cluster Configuration
This is the very simple example to create RabbitMQ Cluster. I will update other configurations for my project. 

```yaml
apiVersion: rabbitmq.com/v1beta1
kind: RabbitmqCluster
metadata:
    name: spring-micro
```

## Uninstallation in kubernetes

```shell
$ kubectl delete rabbitmqclusters.rabbitmq.com spring-micro 
```

