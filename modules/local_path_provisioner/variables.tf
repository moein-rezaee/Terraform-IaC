variable "name" {
  description = "Name for the Helm release"
  type        = string
  default     = "local-path-provisioner"
}

variable "namespace" {
  description = "Namespace to deploy local-path-provisioner"
  type        = string
  default     = "local-path-provisioner"
}

variable "repository" {
  description = "Helm chart repository URL"
  type        = string
  default     = "https://charts.rancher.io"
}

variable "chart" {
  description = "Helm chart name"
  type        = string
  default     = "local-path-provisioner"
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "0.0.31"
}

variable "storage_path" {
  description = "Path on host for storing persistent volumes"
  type        = string
  default     = "/opt/local-path-provisioner"
}
