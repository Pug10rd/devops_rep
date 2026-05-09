variable "name_prefix" {
  description = "Prefix used for naming RDS resources"
  type        = string
}

variable "use_aurora" {
  description = "If true, create Aurora cluster; otherwise create standard RDS instance"
  type        = bool
  default     = false
}

variable "engine" {
  description = "Database engine, for example postgres or aurora-postgresql"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "instance_class" {
  description = "Instance class for RDS or Aurora writer"
  type        = string
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Database port"
  type        = number
}

variable "multi_az" {
  description = "Enable Multi-AZ for standard RDS instance"
  type        = bool
  default     = false
}

variable "allocated_storage" {
  description = "Allocated storage in GB for standard RDS instance"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type for standard RDS instance"
  type        = string
  default     = "gp2"
}

variable "subnet_ids" {
  description = "Subnet IDs for DB subnet group"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for security group"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to the database"
  type        = list(string)
  default     = []
}

variable "parameter_group_family" {
  description = "Parameter group family, for example postgres17 or aurora-postgresql15"
  type        = string
}

variable "max_connections" {
  description = "Value for max_connections"
  type        = string
  default     = "100"
}

variable "log_statement" {
  description = "Value for log_statement"
  type        = string
  default     = "ddl"
}

variable "work_mem" {
  description = "Value for work_mem"
  type        = string
  default     = "4096"
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy"
  type        = bool
  default     = true
}
