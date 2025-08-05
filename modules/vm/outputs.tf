output "public_ip" {
  value = var.create_public_ip ? azurerm_public_ip.public_ip[0].ip_address : null
}
