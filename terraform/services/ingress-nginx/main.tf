locals {
  ingress_nginx_values = templatefile("${path.module}/templates/values.yaml.tmpl", {
    node_port_http  = var.node_port_http
    node_port_https = var.node_port_https
  })
}

module "helm_ingress_nginx" {
  source                 = "../../modules/helm_release"
  name                   = var.name
  namespace              = var.namespace
  chart                  = "ingress-nginx"
  chart_version          = var.chart_version
  repository             = "https://kubernetes.github.io/ingress-nginx"
  values_content         = local.ingress_nginx_values
  set_sensitive_password = null
}
