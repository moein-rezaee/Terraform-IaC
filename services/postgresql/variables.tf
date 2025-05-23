variable "name" {
  default = "postgresql"
}

variable "namespace" {
  default = "postgresql"
}

variable "chart_version" {
  default = "12.5.7"
}

variable "postgresql_password" {
  type      = string
  sensitive = true
}
