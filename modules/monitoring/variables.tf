variable "namespace" {
  description = "Kubernetes namespace for monitoring tools."
  type        = string
  default     = "monitoring"
}

variable "prometheus_release_name" {
  description = "Helm release name for Prometheus."
  type        = string
  default     = "prometheus"
}

variable "grafana_release_name" {
  description = "Helm release name for Grafana."
  type        = string
  default     = "grafana"
}

variable "prometheus_chart_version" {
  description = "Prometheus Helm chart version."
  type        = string
  default     = null
}

variable "grafana_chart_version" {
  description = "Grafana Helm chart version."
  type        = string
  default     = null
}
