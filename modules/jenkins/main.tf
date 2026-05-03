resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = kubernetes_namespace.jenkins.metadata[0].name
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = var.helm_chart_version

  create_namespace = false
  timeout          = 1200

  values = [
    file("${path.module}/values.yaml")
  ]

set = [
  {
    name  = "adminPassword"
    value = var.admin_user
  }
]

set_sensitive = [
  {
    name  = "adminPassword"
    value = var.admin_password
  }
]
}
