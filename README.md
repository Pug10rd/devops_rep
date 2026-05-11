# Final DevOps Project: AWS Infrastructure and CI/CD Platform

**Author:** Ivan Zarichnyi
**Repository:** https://github.com/Pug10rd/devops_rep
**Branch:** `final-project`
**AWS Region:** `us-west-2`

---

## Overview

This project implements a complete DevOps infrastructure and CI/CD workflow on AWS using Terraform, Kubernetes, Jenkins, Argo CD, Prometheus, and Grafana.

The project provisions cloud infrastructure, deploys platform services, builds and publishes a Dockerized Django application, and deploys the application to Amazon EKS using GitOps principles.

Main technologies used:

- Terraform
- AWS VPC
- Amazon EKS
- Amazon RDS PostgreSQL
- Amazon ECR
- Jenkins + Kaniko
- Argo CD
- Helm
- Prometheus + Grafana
- Kubernetes HPA + Metrics Server
- Django

---

## Architecture Summary

The infrastructure consists of the following components:

- VPC with public subnets, private application subnets, and private database subnets
- Internet Gateway for public subnet internet access
- NAT Gateway for outbound internet access from private subnets
- Amazon EKS cluster with managed node group
- Amazon RDS PostgreSQL database deployed in private subnets
- Amazon ECR repository for Django application images
- Jenkins installed into EKS via Helm and Terraform
- Argo CD installed into EKS via Helm and Terraform, managing the Django app via GitOps
- Prometheus and Grafana installed into EKS via Helm and Terraform
- Metrics Server for Kubernetes resource metrics
- Django application deployed with Helm chart and synchronized by Argo CD

---

## CI/CD Flow

1. Developer pushes code to the GitHub repository.
2. Jenkins pipeline is triggered manually or via SCM polling.
3. Jenkins creates a Kubernetes agent pod with Kaniko and Git containers.
4. The pipeline checks out the repository from GitHub (`final-project` branch).
5. Kaniko builds the Django Docker image inside Kubernetes (no Docker daemon required).
6. Kaniko pushes the image to Amazon ECR with two tags:
   - Jenkins build number tag, for example `2`
   - `latest`
7. The pipeline updates `charts/django-app/values.yaml` with the new image tag.
8. Changes are committed and pushed back to the repository.
9. Argo CD detects the change and automatically synchronizes the Django application in EKS.

---

## Project Structure

```text
devops_rep/
├── README.md
├── backend.tf
├── main.tf
├── outputs.tf
├── Dockerfile
├── Jenkinsfile
├── requirements.txt
│
├── modules/
│   ├── s3-backend/
│   │   ├── s3.tf
│   │   ├── dynamodb.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── vpc/
│   │   ├── vpc.tf
│   │   ├── routes.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── ecr/
│   │   ├── ecr.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── eks/
│   │   ├── eks.tf
│   │   ├── node.tf
│   │   ├── aws_ebs_csi_driver.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── rds/
│   │   ├── rds.tf
│   │   ├── aurora.tf
│   │   ├── shared.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── jenkins/
│   │   ├── jenkins.tf
│   │   ├── providers.tf
│   │   ├── values.yaml
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── argo_cd/
│   │   ├── argo_cd.tf
│   │   ├── providers.tf
│   │   ├── values.yaml
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── monitoring/
│       ├── monitoring.tf
│       ├── metrics_server.tf
│       ├── providers.tf
│       ├── values.yaml
│       ├── variables.tf
│       └── outputs.tf
│
├── charts/
│   └── django-app/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── configmap.yaml
│           ├── deployment.yaml
│           ├── hpa.yaml
│           ├── secret.yaml
│           └── service.yaml
│
└── myproject/
    ├── manage.py
    ├── settings.py
    ├── urls.py
    └── wsgi.py
```

---

## Prerequisites

The following tools must be installed and configured before running this project:

- AWS CLI (configured with appropriate credentials)
- Terraform
- kubectl
- Helm
- Git

AWS credentials must have permissions to manage:

- VPC, subnets, route tables, gateways
- EKS clusters and node groups
- RDS instances
- ECR repositories
- IAM roles and policies
- S3 buckets and DynamoDB tables

---

## Deployment

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Validate configuration

```bash
terraform validate
```

### 3. Review the plan

```bash
terraform plan
```

### 4. Apply infrastructure

```bash
terraform apply
```

### 5. Configure kubectl

```bash
aws eks update-kubeconfig \
  --region us-west-2 \
  --name lesson-7-eks
```

---

## Verify Deployment

### Check all namespaces

```bash
kubectl get all -n jenkins
kubectl get all -n argocd
kubectl get all -n monitoring
```

### Check Argo CD application

```bash
kubectl get applications -n argocd
```

Expected result:

```text
NAME         SYNC STATUS   HEALTH STATUS
django-app   Synced        Healthy
```

### Check node and pod metrics

```bash
kubectl top nodes
kubectl top pods -n django-app
```

### Check HPA

```bash
kubectl describe hpa -n django-app
```

---

## Port Forwarding

### Jenkins

```bash
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
```

Open: http://127.0.0.1:8080
Username: `admin`
Password: `admin123`

### Argo CD

```bash
kubectl port-forward svc/argocd-server 8081:443 -n argocd
```

Open: https://127.0.0.1:8081
Username: `admin`

Get password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

### Grafana

```bash
kubectl port-forward svc/grafana 3000:80 -n monitoring
```

Open: http://127.0.0.1:3000
Username: `admin`

---

## Jenkins Pipeline

The pipeline is defined in `Jenkinsfile` at the repository root.

Pipeline stages:

1. **Checkout** — clones the repository from GitHub
2. **Build & Push Image (Kaniko)** — builds the Docker image and pushes to ECR with build number and `latest` tags
3. **Update Helm values.yaml** — updates the image tag in `charts/django-app/values.yaml`
4. **Commit & Push changes** — commits and pushes the updated values file back to GitHub

Jenkins credentials required:

- `github-creds` — GitHub username and token for SCM access and push

---

## Monitoring

Prometheus and Grafana are deployed in the `monitoring` namespace.

Prometheus scrapes metrics from:

- Kubernetes nodes (via node-exporter)
- Kubernetes cluster state (via kube-state-metrics)

Grafana is pre-configured with Prometheus as the default datasource.

Metrics Server is installed in `kube-system` and enables `kubectl top` and HPA functionality.

---

## Autoscaling

The Django application includes a Horizontal Pod Autoscaler configured with:

- Minimum replicas: 1
- Maximum replicas: 3
- CPU target utilization: 80%

HPA requires Metrics Server to be running, which is deployed as part of the monitoring module.

---

## Security

- RDS is deployed in private subnets with no public access
- Security groups restrict database access to the VPC CIDR only
- EKS nodes are in private subnets
- NAT Gateway provides outbound internet access for private subnets without exposing them
- Sensitive Terraform outputs are marked as `sensitive`
- No credentials are committed to the repository

---

## Cleanup

To avoid ongoing AWS costs, destroy the infrastructure after the project is checked.

```bash
terraform destroy
```

---

## Project Status

| Component            | Status                                    |
| -------------------- | ----------------------------------------- |
| Terraform validation | Successful                                |
| VPC + Subnets + NAT  | Deployed                                  |
| EKS Cluster          | Deployed                                  |
| RDS PostgreSQL       | Deployed                                  |
| ECR Repository       | Deployed                                  |
| Jenkins              | Deployed                                  |
| Jenkins Pipeline     | Successful                                |
| ECR Image Push       | Successful (tags: `latest`, build number) |
| Argo CD              | Synced and Healthy                        |
| Django Application   | Running                                   |
| Prometheus + Grafana | Deployed                                  |
| HPA + Metrics Server | Active                                    |
