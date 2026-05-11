resource "random_password" "grafana_admin_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "prometheus" {
  name       = var.prometheus_release_name
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = var.prometheus_chart_version

  values = [
    yamlencode(yamldecode(file("${path.module}/values.yaml")).prometheus)
  ]

  wait    = true
  timeout = 1500

  depends_on = [
    kubernetes_namespace.monitoring
  ]
}

resource "helm_release" "grafana" {
  name       = var.grafana_release_name
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = var.grafana_chart_version

  values = [
    yamlencode(yamldecode(file("${path.module}/values.yaml")).grafana)
  ]

  set {
    name  = "adminPassword"
    value = random_password.grafana_admin_password.result
  }

  wait    = true
  timeout = 1500

  depends_on = [
    helm_release.prometheus
  ]
}
