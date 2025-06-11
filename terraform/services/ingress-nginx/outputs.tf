output "ingress_namespace" {
  value = var.namespace
}

output "ingress_nginx_node_ports" {
  value = {
    http  = var.node_port_http
    https = var.node_port_https
  }
}
