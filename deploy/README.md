# Setup and Deployment with Kubernetes

To deploy the currently checked out commit, you can use the Rake task: `rake deployment:deploy`

## Required Tools

* Docker: https://docs.docker.com/install/
* Google Cloud SDK: https://cloud.google.com/sdk/docs/quickstarts
* Kubernetes: `gcloud components install kubectl`
* Cloud Project Setup for K8s: https://cloud.google.com/kubernetes-engine/docs/quickstart

## Google Cloud Project

```yaml
name: oxon-infrastructure
properties:
  compute:
    region: europe-west1
    zone: europe-west1-d
  core:
    account: <youraccount>@oxon.ch
    project: oxon-infrastructure
```

## Kubernetes Setup

### Creating a Cluster

```bash
gcloud container clusters create shared-cluster \
	--zone=europe-west1-d \
	--machine-type=g1-small \
	--num-nodes=3 \
	--scopes=gke-default,storage-rw,sql-admin,logging-write,monitoring,cloud-platform,service-control,service-management,trace,cloud-source-repos-ro
```

### Secrets

```bash
kubectl create secret generic oxomine-database --from-literal=username=oxomine --from-literal=password=dbpassword
kubectl create secret generic oxomine-app-secrets --from-literal=secret-key-base=supersecretkey

```

Establish connection to Cloud SQL instance (https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine) via 
"OXON DB service account" (use key in JSON format):

```bash
kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=/path/to/oxon-infrastructure-cloudsql.json
```

The same for Google Cloud Storage:

```bash
kubectl create secret generic storage-credentials --from-file=credentials.json=/path/to/oxon-infrastructure-storage.json
```

... and the generic Compute service account:

```bash
kubectl create secret generic compute-credentials --from-file=credentials.json=/path/to/oxon-infrastructure-service-account.json
```

### Basic Setup (Deployments, Services, Ingress)

#### Oxomine (Redmine, Rails)

```bash
kubectl create -f oxomine-service.yaml 
# kubectl create -f oxomine.yaml   # The app itself has to be deployed with the rake task 'deployment:apply', see next line
rails deployment:deploy
```

#### Ingress (Load Balancer)

```bash
kubectl create -f ingress.yaml
```
