variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "helm_release_name" {
  type = string
}

variable "envs" {
  description = "Map of environment variables to be stored in the Secret"
  type        = map(string)
  sensitive   = true
}