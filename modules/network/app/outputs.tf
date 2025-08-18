output "subnet_id" {
  value = azurerm_subnet.subnet_app.id
}

output "subnet_id_app" {
  value = azurerm_subnet.subnet_app.id
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.postgres_dns.id
}

output "dns_zone_id" {
  value = azurerm_private_dns_zone.postgres_dns.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
