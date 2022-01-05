# [ArgoCD](https://argo-cd.readthedocs.io/en/stable/)
Argo CD is a declarative, [GitOps](https://www.gitops.tech) continuous delivery tool for Kubernetes.

## Installation

### Install ArgoCD
```bash
$ kubectl create namespace argocd
$ kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

If you are not interested in UI, SSO, multi-cluster features then you can install core Argo CD components only:

```bash
$ kubectl create namespace argocd
$ kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/core-install.yaml
```

Use argocd login --core to configure CLI access.


### Download Argo CD CLI
Download the latest Argo CD version from https://github.com/argoproj/argo-cd/releases/latest. More detailed installation instructions can be found via the CLI installation documentation.

Also available in Mac, Linux and WSL Homebrew:
```bash
$ brew install argocd
```

### Access The Argo CD API Server
There are 3 ways to access to the Argo CD API server

#### Service Type Load Balancer
Change the argocd-server service type to LoadBalancer:
This way is useful if you set up your environemt on the cloud and on-promise with Load balancer.

```bash
$ kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

#### Ingress
Follow the [ingress documentation](https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/) on how to configure Argo CD with ingress.

#### Port Forwarding
Kubectl port-forwarding can also be used to connect to the API server without exposing the service. 
This is a good way when you want to test Argo CD on your local environment.

```bash
$ kubectl port-forward svc/argocd-server -n argocd 8081:443
```
The API server can then be accessed using the localhost:8081

## Login into Argo CD

### Password of admin
The initial password for the admin account is auto-generated and stored as clear text in the field password in a secret named argocd-initial-admin-secret in your Argo CD installation namespace. You can simply retrieve this password using kubectl:
```bash
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

Using the username admin and the password from above, login to Argo CD's IP or hostname:
```bash
$ argocd login <ARGOCD_SERVER>
```
> The CLI environment must be able to communicate with the Argo CD controller. If it isn't directly accessible as described above in step 3, you can tell the CLI to access it using port forwarding through one of these mechanisms: 1) add --port-forward-namespace argocd flag to every CLI command; or 2) set ARGOCD_OPTS environment variable: export ARGOCD_OPTS='--port-forward-namespace argocd'.

Change the password using the command:
```bash
$ argocd account update-password
```

## Register A Cluster To Deploy Apps To (Optional)

This step registers a cluster's credentials to Argo CD, and is only necessary when deploying to an external cluster. When deploying internally (to the same cluster that Argo CD is running in), https://kubernetes.default.svc should be used as the application's K8s API server address.

First list all clusters contexts in your current kubeconfig:
```bash
$ kubectl config get-contexts -o name
```

Choose a context name from the list and supply it to argocd cluster add CONTEXTNAME. For example, for docker-desktop context, run:
```bash
$ argocd cluster add docker-desktop
```

The above command installs a ServiceAccount (argocd-manager), into the kube-system namespace of that kubectl context, and binds the service account to an admin-level ClusterRole. Argo CD uses this service account token to perform its management tasks (i.e. deploy/monitoring).

## Create An Application From A Git Repository

### Creating Apps Via CLI
Create the example guestbook application with the following command:
```bash
$ argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default`
```

## Sync (Deploy) The Application

### Syncing via CLI
```bash
$ argocd app get guestbook
Name:               guestbook
Server:             https://kubernetes.default.svc
Namespace:          default
URL:                https://10.97.164.88/applications/guestbook
Repo:               https://github.com/argoproj/argocd-example-apps.git
Target:
Path:               guestbook
Sync Policy:        <none>
Sync Status:        OutOfSync from  (1ff8a67)
Health Status:      Missing

GROUP  KIND        NAMESPACE  NAME          STATUS     HEALTH
apps   Deployment  default    guestbook-ui  OutOfSync  Missing
       Service     default    guestbook-ui  OutOfSync  Missing
```

The application status is initially in OutOfSync state since the application has yet to be deployed, and no Kubernetes resources have been created. To sync (deploy) the application, run:

```bash
$ argocd app sync guestbook
```
This command retrieves the manifests from the repository and performs a kubectl apply of the manifests. The guestbook app is now running and you can now view its resource components, logs, events, and assessed health status.

> You can see the way how to deploy and sync using User Interface [here](https://argo-cd.readthedocs.io/en/stable/getting_started/#3-access-the-argo-cd-api-server).