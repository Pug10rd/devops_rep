# Lesson-5 Terraform Infrastructure

## 📂 Структура проєкту

lesson-5/
├── main.tf # Підключення модулів
├── backend.tf # Налаштування бекенду для стейтів у S3
├── outputs.tf # Загальні вихідні дані з усіх модулів
└── modules/
├── s3-backend/ # Модуль для S3 та DynamoDB
├── vpc/ # Модуль для мережевої інфраструктури
└── ecr/ # Модуль для ECR репозиторію

---

## 🚀 Команди для запуску

```bash
# Ініціалізація Terraform
terraform init

# Перевірка плану змін
terraform plan

# Застосування конфігурації
terraform apply

# Видалення створених ресурсів
terraform destroy
📌 Опис модулів
1. s3-backend
Створює S3 bucket для збереження Terraform state
Увімкнено versioning для збереження історії змін
Створює DynamoDB таблицю для state locking
Виводить ім’я bucket та DynamoDB таблиці
2. vpc
Створює VPC з заданим CIDR block
Створює 3 public та 3 private subnet
Налаштовує Internet Gateway для public subnet
Налаштовує NAT Gateway для private subnet
Створює route tables та associations
Виводить VPC ID та subnet IDs
3. ecr
Створює Elastic Container Registry (ECR)
Увімкнено автоматичне сканування образів
Базова конфігурація репозиторію
Виводить URL репозиторію
⚠️ Важливо
Переконайтесь, що налаштований AWS CLI та доступні credentials
Перед запуском переконайтесь, що backend S3 bucket існує або закоментований
Використовується DynamoDB для state locking (якщо backend активний)
✅ Використання
terraform init
terraform plan
terraform apply
terraform destroy

Після apply використовуйте outputs для інтеграції з іншими сервісами (VPC, ECR, S3 state backend).
```
