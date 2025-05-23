# modules/k8s_secret/main.tf
resource "kubernetes_secret" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-name"      = var.helm_release_name
      "meta.helm.sh/release-namespace" = var.namespace
    }
  }

  type = "Opaque"
  data = var.envs   
}