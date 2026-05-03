variable "namespace" {
  description = "Namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "helm_chart_version" {
  description = "Argo CD Helm chart version"
  type        = string
  default     = "9.5.1"
}
