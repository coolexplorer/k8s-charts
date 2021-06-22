# istio service mesh

Istio extends Kubernetes to establish a programmable, application-aware network using the powerful Envoy service proxy. Working with both Kubernetes and traditional workloads, Istio brings standard, universal traffic management, telemetry, and security to complex deployments.

## Set up

### Download

1. Download files
```shell
$ curl -L https://istio.io/downloadIstio | sh -

# Installation with the specific version
$ curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.10.0 TARGET_ARCH=x86_64 sh -
```

2. Move to the folder downloaded
```shell
$ cd istio-1.10.0
```

3. Add the `istioctl` client
```shell
$ export PATH=$PWD/bin:$PATH
```

### Installation

Accoring to the istio documents, they give the demo configuration for the installation of istio. So, I'm going to follow their recommendation for my test application. After that, I will make my own configuration fitting my application environment. 

```shell
$ istioctl install --set profile=demo -y
✔ Istio core installed
✔ Istiod installed
✔ Egress gateways installed
✔ Ingress gateways installed
✔ Installation complete
```