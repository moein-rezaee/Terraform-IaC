locals {
  harbor_values = templatefile("${path.module}/templates/values.yaml.tmpl", {
    postgresql_host         = "postgresql.postgresql.svc.cluster.local"
    postgresql_port         = 5432
    postgresql_user         = "postgres"
    postgresql_password     = var.postgresql_password
    postgresql_database     = "harbor"
    redis_host              = "redis-master.redis.svc.cluster.local"
    redis_port              = 6379
    redis_password          = var.redis_password
    harbor_admin_password   = var.harbor_admin_password
  })
}


module "helm_harbor" {
  source         = "../../modules/helm_release"
  name           = var.name
  namespace      = var.namespace
  chart          = "harbor"
  chart_version  = var.chart_version
  repository     = "https://helm.goharbor.io"
  values_content = local.harbor_values
  set_sensitive_password = null
}