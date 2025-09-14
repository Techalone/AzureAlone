# outputs.tf

output "public_ip" {
  description = "L'adresse IP publique de la VM"
  value       = azurerm_public_ip.main.ip_address
}

output "public_dns" {
  description = "Le nom DNS complet de la VM"
  value       = azurerm_public_ip.main.fqdn
}
