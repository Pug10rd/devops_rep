terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

variable "kubeconfig" {
  type = string
}

provider "aws" {
  region = "us-west-2"
}

module "rds" {
  source = "./modules/rds"

  name_prefix    = "lesson-7"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnets

  # RDS or Aurora toggle
  use_aurora     = false   # set true for Aurora

  engine         = "postgres"
  engine_version = "17.2"
  instance_class = "db.t3.micro"

  db_name        = "mydb"
  username       = "dbadmin"
  password       = "changeme123"   # move to secrets manager later
  port           = 5432

  parameter_group_family = "postgres17"
  allowed_cidr_blocks    = ["10.0.0.0/16"]  # your VPC CIDR
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "ivan-terraform-state-bucket-001001"
  table_name  = "terraform-locks"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_name           = "ivan-lesson-5-vpc"
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "ivan-lesson-5-ecr"
  scan_on_push = true
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = "lesson-7-eks"
  subnet_ids   = module.vpc.private_subnets
}

data "aws_eks_cluster" "eks" {
  name = module.eks.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.eks_cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

module "jenkins" {
  source       = "./modules/jenkins"
  cluster_name = module.eks.eks_cluster_name
  kubeconfig = var.kubeconfig
  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
  
  depends_on = [module.eks]
}


module "argo_cd" {
  source        = "./modules/argo_cd"
  namespace     = "argocd"
  chart_version = "5.46.4"

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }

  depends_on = [module.eks]
}