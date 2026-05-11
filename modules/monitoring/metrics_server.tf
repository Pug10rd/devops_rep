resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"

  wait    = true
  timeout = 900

  values = [
    yamlencode({
      args = [
        "--kubelet-preferred-address-types=InternalIP",
        "--kubelet-use-node-status-port",
        "--metric-resolution=15s"
      ]

      resources = {
        requests = {
          cpu    = "50m"
          memory = "64Mi"
        }
        limits = {
          cpu    = "300m"
          memory = "256Mi"
        }
      }
    })
  ]
}
