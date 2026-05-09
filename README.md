Terraform Database Module (RDS & Aurora)
This project implements a flexible and reusable Terraform module for provisioning relational databases in AWS.

The module supports two modes:

Standard RDS instance (PostgreSQL / MySQL)
Aurora cluster (PostgreSQL-compatible)
The database type is controlled by a single variable: use_aurora

🚀 Features
Conditional creation of RDS or Aurora
Reusable Terraform module
Clean modular architecture
Automatic creation of:
DB Subnet Group
Security Group
Parameter Group
Minimal configuration required to switch database type
📁 Project Structure
Project/
├── lesson-db-module/
│ ├── README.md
│ ├── backend.hcl
│ ├── backend.tf
│ ├── main.tf
│ ├── outputs.tf
│ ├── terraform.tfvars.example
│ ├── variables.tf
│ ├── versions.tf
│ └── modules/
│ ├── rds/
│ │ ├── aurora.tf
│ │ ├── outputs.tf
│ │ ├── rds.tf
│ │ ├── shared.tf
│ │ └── variables.tf
│ └── vpc/
│ ├── main.tf
│ ├── outputs.tf
│ └── variables.tf
│
└── lesson-db-module-bootstrap/
├── README.md
├── main.tf
├── outputs.tf
├── variables.tf
├── versions.tf
└── modules/
└── s3-backend/
├── dynamodb.tf
├── outputs.tf
├── s3.tf
└── variables.tf
⚙️ Usage Example
module "rds" {
source = "./modules/rds"

use_aurora = false
engine = "postgres"
engine_version = "16.12"
instance_class = "db.t3.micro"

db_name = "appdb"
username = "dbadmin"
password = "YourStrongPassword"

subnet_ids = module.vpc.private_subnet_ids
vpc_id = module.vpc.vpc_id
}
🔄 Switching Between RDS and Aurora
To switch database type, change only one variable:

RDS:
use_aurora = false

Aurora:
use_aurora = true

No other changes are required.

🧩 Variables
Variable Description Type Default
use_aurora Enable Aurora cluster bool false
engine Database engine string "postgres"
engine_version Engine version string "16.12"
instance_class Instance type string "db.t3.micro"
db_name Database name string "appdb"
username Master username string "dbadmin"
password Master password string n/a
subnet_ids Private subnet IDs list n/a
vpc_id VPC ID string n/a
🏗️ Created Resources
Depending on configuration, the module creates:

Common resources:
aws_db_subnet_group
aws_security_group
parameter group
RDS mode:
aws_db_instance
Aurora mode:
aws_rds_cluster
aws_rds_cluster_instance (writer)
🧪 Testing Strategy
RDS validation:
terraform apply
terraform destroy
Aurora validation:
terraform plan
Aurora configuration is validated using plan to avoid unnecessary cloud costs.

⚠️ Important Notes
Aurora is NOT included in AWS Free Tier
It may incur additional costs even for short usage
Always run:
terraform destroy
after testing

🔧 Backend Setup
Terraform remote state is managed using S3 and DynamoDB.

Before running the main module, you must deploy the backend:

cd lesson-db-module-bootstrap
terraform init
terraform apply
Then configure backend in the main module using: backend.hcl

💡 Summary
This project demonstrates:

Conditional infrastructure provisioning
Reusable Terraform module design
Separation of bootstrap and main infrastructure
Production-style architecture
The module can be reused across different environments with minimal changes.
