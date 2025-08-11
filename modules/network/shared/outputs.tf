output "subnet_id_bastion" {
  value = azurerm_subnet.subnet_bastion.id
}

output "subnet_id_sonarqube" {
  value = azurerm_subnet.subnet_sonarqube.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}