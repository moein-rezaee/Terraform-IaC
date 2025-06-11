locals {
  woodpecker_values = templatefile("${path.module}/templates/values.yaml.tmpl", {
    hostname              = "woodpecker.mafialegends.site"
    woodpecker_agent_secret = var.woodpecker_agent_secret
    woodpecker_admin      = var.woodpecker_admin
    gitea_server          = var.gitea_server
    gitea_client_id       = var.gitea_client_id
    gitea_client_secret   = var.gitea_client_secret
  })
}

module "helm_woodpecker" {
  source  = "../../modules/helm_release"
  name    = "woodpecker"
  chart   = "${path.module}/charts/woodpecker" # ⬅ مسیر چارت محلی
  namespace = "woodpecker"
  chart_version = null                         # ⬅ چون محلیه، نیازی به ورژن نیست
  repository = null                            # ⬅ و نیازی به ریپو هم نیست
  values_content = local.woodpecker_values
  set_sensitive_password = null
}
