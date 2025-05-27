locals {
  gitea_values = templatefile("${path.module}/templates/values.yaml.tmpl", {
    postgresql_password = var.postgresql_password
    redis_password      = var.redis_password
  })
}

module "helm_gitea" {
  source                 = "../../modules/helm_release"
  name                   = var.name
  namespace              = var.namespace
  chart                  = "gitea"
  chart_version          = var.chart_version
  repository             = "https://dl.gitea.io/charts/"
  values_content         = local.gitea_values
  set_sensitive_password = null
}
