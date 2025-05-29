variable "name" {
  type    = string
  default = "harbor"
}

variable "namespace" {
  type    = string
  default = "harbor"
}

variable "chart_version" {
  type    = string
  default = "1.14.2" # آخرین نسخه رسمی در زمان نگارش
}

variable "postgresql_password" {
  type      = string
  sensitive = true
}

variable "redis_password" {
  type      = string
  sensitive = true
}

variable "harbor_admin_password" {
  type      = string
  sensitive = true
}