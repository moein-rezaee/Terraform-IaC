variable "name" {
  type    = string
  default = "gitforge"
}

variable "namespace" {
  type    = string
  default = "gitforge"
}

variable "chart_version" {
  type    = string
  default = "10.1.2"
}

variable "postgresql_password" {
  type      = string
  sensitive = true
}

variable "redis_password" {
  type      = string
  sensitive = true
}
