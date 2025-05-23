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