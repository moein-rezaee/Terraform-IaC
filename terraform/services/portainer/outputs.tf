output "portainer_release_name" {
  value = module.helm_portainer.helm_release_name
}

output "portainer_hostname" {
  value = var.hostname
}
