variable "name" {
  type        = string
  default     = "ingress-nginx"
}

variable "namespace" {
  type        = string
  default     = "ingress-nginx"
}

variable "chart_version" {
  type        = string
  default     = "4.10.0"
}

variable "node_port_http" {
  type        = number
  default     = 30288
}

variable "node_port_https" {
  type        = number
  default     = 30333
}
