locals {
  postgresql_values = templatefile("${path.module}/templates/values.yaml.tmpl", {
    postgresql_password = var.postgresql_password
  })
}


module "postgresql" {
  source                 = "../../modules/helm_release"
  name                   = var.name
  namespace              = var.namespace
  chart                  = "postgresql"
  chart_version          = var.chart_version
  repository             = "https://charts.bitnami.com/bitnami"
  values_content         = local.postgresql_values
  set_sensitive_password = null
}