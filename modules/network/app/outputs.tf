output "subnet_id" {
  value = azurerm_subnet.subnet_app.id
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.postgres_dns.id
}
