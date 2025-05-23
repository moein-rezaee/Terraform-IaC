locals {
  redis_values = templatefile("${path.module}/templates/values.yaml.tmpl", {
    redis_password = var.redis_password
  })
}

module "redis" {
  source                 = "../../modules/helm_release"
  name                   = var.name
  namespace              = var.namespace
  chart                  = "redis"
  chart_version          = var.chart_version
  repository             = "https://charts.bitnami.com/bitnami"
  values_content         = local.redis_values
  set_sensitive_password = null
}