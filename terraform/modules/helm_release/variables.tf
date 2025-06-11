variable "name" {}
variable "namespace" {}
variable "chart" {}
variable "chart_version" {}
variable "repository" {}
variable "values_path" {
  description = "Full path to values.yaml file"
  type        = string
  default = null
}
variable "set_sensitive_password" {
  sensitive = true
}
variable "values_content" {
  type    = string
  default = null
}
