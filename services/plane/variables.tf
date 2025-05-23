variable "name" {
  type    = string
  default = "plane"
}

variable "namespace" {
  type    = string
  default = "plane"
}

variable "redis_password" {
  type      = string
  sensitive = true
}

variable "postgresql_password" {
  type      = string
  sensitive = true
}

variable "secret_key" {
  type        = string
  description = "Secret key for Django or Plane application"
}
