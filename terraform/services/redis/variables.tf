variable "name" {
  default = "redis"
}

variable "namespace" {
  default = "redis"
}

variable "chart_version" {
  default = "19.5.2"
}

variable "redis_password" {
  type      = string
  sensitive = true
}
