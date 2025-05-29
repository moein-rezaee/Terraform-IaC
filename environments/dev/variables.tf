variable "redis_password" {
  type      = string
  sensitive = true
}

variable "postgresql_password" {
  type      = string
  sensitive = true
}

variable "secret_key" {
  type      = string
  sensitive = true
}

variable "rabbitmq_password" {
  type      = string
  sensitive = true
}

variable "base_domain" {
  type        = string
  description = "Base domain for ingress, like 'example.com'"
}

variable "harbor_admin_password" {
  type      = string
  sensitive = true
}


variable "woodpecker_agent_secret" {
  type = string
}

variable "woodpecker_admin" {
  type = string
}

variable "gitea_server" {
  type = string
}

variable "gitea_client_id" {
  type = string
}

variable "gitea_client_secret" {
  type = string
}
