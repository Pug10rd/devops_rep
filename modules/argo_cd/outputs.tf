output "namespace" {
  value = var.namespace
}

output "release_name" {
  value = helm_release.argocd.name
}

output "apps_release_name" {
  value = helm_release.argocd_apps.name
}
