Lesson 7 — Kubernetes (EKS) + Helm + Django
Опис

Проєкт демонструє деплой Django застосунку в Kubernetes кластері на AWS EKS з використанням Terraform, Docker, AWS ECR та Helm.

Функціональність
Створення Kubernetes кластера через Terraform
Використання існуючого VPC (lesson-5)
Збірка Docker образу Django
Публікація образу в AWS ECR
Деплой застосунку через Helm
Використання ConfigMap для змінних середовища
Використання Secret для чутливих даних
Horizontal Pod Autoscaler (HPA)
Доступ через AWS LoadBalancer
Архітектура
AWS EKS — Kubernetes кластер
AWS ECR — Docker registry
Terraform — інфраструктура
Helm — деплоймент
Django — backend застосунок
AWS LoadBalancer — зовнішній доступ
Структура проєкту
lesson-7/
├── main.tf
├── backend.tf
├── outputs.tf
├── variables.tf
├── terraform.tfvars
├── versions.tf
├── .gitignore
├── modules/
│ ├── eks/
│ └── ecr/
└── charts/
└── django-app/
├── Chart.yaml
├── values.yaml
└── templates/
├── deployment.yaml
├── service.yaml
├── configmap.yaml
├── secret.yaml
└── hpa.yaml
Деплой

1. Ініціалізація Terraform
   terraform init
   terraform plan
   terraform apply
2. Підключення до EKS
   aws eks update-kubeconfig --region us-west-2 --name lesson-7-eks-cluster
   kubectl get nodes
3. Встановлення metrics-server (HPA)
   kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
4. Збірка Docker image
   docker build -t lesson-7-django-ecr .
5. Авторизація в ECR
   aws ecr get-login-password --region us-west-2 \
   | docker login --username AWS --password-stdin 660619595389.dkr.ecr.us-west-2.amazonaws.com
6. Push образу в ECR
   docker tag lesson-7-django-ecr:latest 660619595389.dkr.ecr.us-west-2.amazonaws.com/ivan-lesson-5-ecr:latest
   docker push 660619595389.dkr.ecr.us-west-2.amazonaws.com/ivan-lesson-5-ecr:latest
7. Деплой через Helm
   cd charts/django-app

helm lint .
helm install django-app . 8. Перевірка стану
kubectl get pods
kubectl get svc
kubectl get hpa
kubectl top pods
kubectl top nodes
Доступ до застосунку

Застосунок доступний через AWS LoadBalancer:

http://<EXTERNAL-LOADBALANCER-DNS>
ConfigMap

Використовується для не чутливих змінних середовища:

POSTGRES_DB
POSTGRES_USER
POSTGRES_HOST
POSTGRES_PORT

У поточній реалізації POSTGRES_HOST=db використовується як Docker Compose підхід і потребує окремого Kubernetes Service або зовнішньої БД.

Secret

Використовується для чутливих даних:

SECRET_KEY
POSTGRES_PASSWORD
HPA (Horizontal Pod Autoscaler)
min replicas: 2
max replicas: 6
target CPU utilization: 70%
ECR Image
660619595389.dkr.ecr.us-west-2.amazonaws.com/ivan-lesson-5-ecr:latest
Висновок

Реалізовано повний цикл:

інфраструктура через Terraform
Kubernetes кластер на EKS
Docker образ у ECR
деплой через Helm
ConfigMap + Secret
HPA
доступ через LoadBalancer
