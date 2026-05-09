## Lesson 7 — Kubernetes (EKS) + Helm + Django

### Опис

Проєкт демонструє повний DevOps-цикл розгортання Django застосунку в AWS Kubernetes (EKS) з використанням Terraform для інфраструктури, Docker для контейнеризації та Helm для деплою.

Інфраструктура побудована модульно: VPC → EKS → ECR → Jenkins → ArgoCD, з інтеграцією Kubernetes через `helm` та `kubernetes` провайдери Terraform.

---

## Функціональність

- Створення інфраструктури AWS через Terraform (VPC, EKS, ECR)
- Підключення до Kubernetes кластера (EKS)
- Збірка Docker образу Django застосунку
- Публікація Docker image в AWS ECR
- Деплой застосунку через Helm chart
- Використання ConfigMap для конфігурацій
- Використання Secret для чутливих даних
- Автоматичне масштабування (HPA)
- Доступ до застосунку через AWS LoadBalancer
- Інтеграція Jenkins (CI/CD pipeline)
- Інтеграція ArgoCD (GitOps деплой)

---

## Архітектура

- **AWS VPC** — мережева інфраструктура
- **AWS EKS** — Kubernetes кластер
- **AWS ECR** — Docker registry
- **Terraform** — інфраструктура як код
- **Helm** — деплой Kubernetes ресурсів
- **Jenkins** — CI/CD pipeline
- **ArgoCD** — GitOps деплоймент
- **Django** — backend застосунок
- **AWS LoadBalancer** — зовнішній доступ до сервісу

---

## Структура проєкту

```
.
├── main.tf
├── backend.tf
├── outputs.tf
├── variables.tf
├── terraform.tfvars
├── versions.tf
├── Dockerfile
├── Jenkinsfile
├── docker-compose.yml
├── requirements.txt
├── manage.py
├── nginx/
├── myproject/
├── charts/
│   └── django-app/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── configmap.yaml
│           ├── secret.yaml
│           └── hpa.yaml
└── modules/
    ├── vpc/
    ├── eks/
    ├── ecr/
    ├── jenkins/
    ├── argo_cd/
    └── s3-backend/
```

---

## Деплой

### 1. Ініціалізація Terraform

```bash
terraform init
terraform plan
terraform apply
```

---

### 2. Підключення до EKS

```bash
aws eks update-kubeconfig --region us-west-2 --name <cluster-name>

kubectl get nodes
```

---

### 3. Встановлення metrics-server (HPA)

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

---

### 4. Збірка Docker image

```bash
docker build -t django-app .
```

---

### 5. Логін в AWS ECR

```bash
aws ecr get-login-password --region us-west-2 \
| docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-west-2.amazonaws.com
```

---

### 6. Push image в ECR

```bash
docker tag django-app:latest <account-id>.dkr.ecr.us-west-2.amazonaws.com/<repo>:latest

docker push <account-id>.dkr.ecr.us-west-2.amazonaws.com/<repo>:latest
```

---

### 7. Деплой через Helm

```bash
cd charts/django-app

helm lint .
helm install django-app .
```

---

### 8. Перевірка стану

```bash
kubectl get pods
kubectl get svc
kubectl get hpa
kubectl top pods
kubectl top nodes
```

---

## Доступ до застосунку

Застосунок доступний через AWS LoadBalancer:

```
http://<loadbalancer-url>
```

---

## ConfigMap

Використовується для не чутливих змінних середовища:

- POSTGRES_DB
- POSTGRES_USER
- POSTGRES_HOST
- POSTGRES_PORT

---

## Secret

Використовується для чутливих даних:

- SECRET_KEY
- POSTGRES_PASSWORD

---

## HPA (Horizontal Pod Autoscaler)

- min replicas: 2
- max replicas: 6
- target CPU utilization: 70%

---

## ECR Image

```
<account-id>.dkr.ecr.us-west-2.amazonaws.com/<repository>:latest
```

---

## Jenkins

- Автоматизація build & deploy
- Trigger pipeline при зміні коду
- Build Docker image → Push to ECR → Deploy via Helm

---

## ArgoCD

- GitOps підхід
- Автоматичний sync Kubernetes manifests з Git репозиторію
- Деплой Helm chart через ArgoCD Application

---

## Висновок

Реалізовано повний DevOps pipeline:

- інфраструктура через Terraform
- Kubernetes кластер на AWS EKS
- CI/CD через Jenkins
- GitOps через ArgoCD
- контейнеризація через Docker
- деплой через Helm
- масштабування через HPA
- зовнішній доступ через LoadBalancer
