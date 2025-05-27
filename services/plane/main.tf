locals {
  plane_values = templatefile("${path.module}/templates/values.yaml.tmpl", {
    redis_password      = var.redis_password
    postgresql_password = var.postgresql_password
    secret_key          = var.secret_key
    rabbitmq_password   = var.rabbitmq_password
    base_domain         = var.base_domain

    # app_host    = "plane.82.115.21.193.nip.io"
    # minio_host  = "minio.82.115.21.193.nip.io"
    # rabbit_host = "rabbit.82.115.21.193.nip.io"

    # appHost: plane.82.115.21.193.nip.io
    # minioHost: minio.82.115.21.193.nip.io
    # rabbitmqHost: rabbit.82.115.21.193.nip.io
  })
}

module "plane" {
  source                 = "../../modules/helm_release"
  name                   = var.name
  namespace              = var.namespace
  chart                  = "${path.module}/charts/plane-ce-1.1.1.tgz"
  chart_version          = "1.1.1"
  repository             = null
  values_content         = local.plane_values
  set_sensitive_password = null
}
