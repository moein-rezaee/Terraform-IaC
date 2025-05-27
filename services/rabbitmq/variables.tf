variable "name" {
  type        = string
  default     = "rabbitmq"
}

variable "namespace" {
  type        = string
  default     = "rabbitmq"
}

variable "chart_version" {
  type        = string
  default     = "12.0.5" # با توجه به نسخه رسمی Bitnami
}

variable "rabbitmq_password" {
  type        = string
  sensitive   = true
}

variable "base_domain" {
  type        = string
  description = "Base domain for ingress, like 'example.com'"
}
