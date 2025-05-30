locals {
  portainer_values = templatefile("${path.module}/templates/values.yaml.tmpl", {
    hostname = "portainer.mafialegends.site"
  })
}

module "helm_portainer" {
  source               = "../../modules/helm_release"
  name                 = "portainer"
  namespace            = "portainer"
  chart                = "portainer"
  repository           = "https://portainer.github.io/k8s/"
  chart_version        = "1.0.63"
  values_content       = local.portainer_values
  set_sensitive_password = null
}
