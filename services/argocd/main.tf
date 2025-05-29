locals {
  argocd_values = templatefile("${path.module}/templates/values.yaml.tmpl", {
    hostname = "argocd.mafialegends.site"
  })
}

module "helm_argocd" {
  source               = "../../modules/helm_release"
  name                 = "argocd"
  namespace            = "argocd"
  chart                = "argo-cd"
  repository           = "https://argoproj.github.io/argo-helm"
  chart_version        = "5.51.6"
  values_content       = local.argocd_values
  set_sensitive_password = null
}
