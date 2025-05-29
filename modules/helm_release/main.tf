resource "helm_release" "this" {
  name             = var.name
  namespace        = var.namespace
  chart            = var.chart
  repository       = var.repository != null ? var.repository : null
  version          = var.chart_version != null ? var.chart_version : null
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
