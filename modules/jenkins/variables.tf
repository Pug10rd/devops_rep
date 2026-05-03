variable "namespace" {
  description = "Namespace for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "helm_chart_version" {
  description = "Jenkins Helm chart version"
  type        = string
  default     = "5.8.104"
}

variable "admin_user" {
  description = "Jenkins admin username"
  type        = string
  default     = "admin"
}

variable "admin_password" {
  description = "Jenkins admin password"
  type        = string
  sensitive   = true
}
