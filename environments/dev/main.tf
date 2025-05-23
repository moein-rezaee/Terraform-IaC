module "postgresql" {
  source              = "../../services/postgresql"
  postgresql_password = var.postgresql_password
}

module "redis" {
  source         = "../../services/redis"
  redis_password = var.redis_password
}

module "ingress_nginx" {
  source          = "../../services/ingress-nginx"
  name            = "ingress-nginx"
  namespace       = "ingress-nginx"
  chart_version   = "4.10.0"
  node_port_http  = 30288
  node_port_https = 30333
}

module "plane" {
  source              = "../../services/plane"
  redis_password      = var.redis_password
  postgresql_password = var.postgresql_password
  secret_key          = var.secret_key
}
