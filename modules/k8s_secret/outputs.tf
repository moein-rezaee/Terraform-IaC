output "secret_name" {
  description = "The name of the created secret"
  value       = kubernetes_secret.this.metadata[0].name
}
