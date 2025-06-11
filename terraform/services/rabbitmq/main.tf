locals {
  rabbitmq_values = templatefile("${path.module}/templates/values.yaml.tmpl", {
    rabbitmq_password = var.rabbitmq_password
    base_domain       = var.base_domain
  })
}

module "rabbitmq" {
  source                 = "../../modules/helm_release"
  name                   = var.name
  namespace              = var.namespace
  chart                  = "rabbitmq"
  chart_version          = var.chart_version
  repository             = "https://charts.bitnami.com/bitnami"
  values_content         = local.rabbitmq_values
  set_sensitive_password = null
}
