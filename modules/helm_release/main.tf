resource "helm_release" "this" {
  name             = var.name
  namespace        = var.namespace
  chart            = var.chart
  repository       = var.repository
  version          = var.chart_version
  create_namespace = true

  values = var.values_content != null ? [var.values_content] : [file(var.values_path)]

  dynamic "set_sensitive" {
    for_each = var.set_sensitive_password != null ? [1] : []
    content {
      name  = "auth.password"
      value = var.set_sensitive_password
    }
  }
}
