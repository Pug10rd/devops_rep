output "namespace" {
  description = "Monitoring namespace."
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

output "prometheus_release_name" {
  description = "Prometheus Helm release name."
  value       = helm_release.prometheus.name
}

output "grafana_release_name" {
  description = "Grafana Helm release name."
  value       = helm_release.grafana.name
}

output "grafana_service_name" {
  description = "Grafana service name."
  value       = helm_release.grafana.name
}

output "grafana_admin_password" {
  description = "Grafana admin password."
  value       = random_password.grafana_admin_password.result
  sensitive   = true
}
