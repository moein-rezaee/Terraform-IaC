resource "helm_release" "this" {
  name             = var.name
  namespace        = var.namespace
  repository       = var.repository
  chart            = "${path.module}/charts/local-path-provisioner-0.0.24"
  version          = "0.0.24"
  create_namespace = true

  values = [templatefile("${path.module}/templates/values.yaml.tmpl", {
    storage_path = var.storage_path
  })]
}