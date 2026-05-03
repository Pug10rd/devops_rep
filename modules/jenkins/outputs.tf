output "namespace" {
  value = var.namespace
}

output "release_name" {
  value = helm_release.jenkins.name
}
