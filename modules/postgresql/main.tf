resource "azurerm_postgresql_flexible_server" "pg-db" {
  name                   = var.server_name
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  version                = var.version 
  administrator_login    = var.admin_login
  administrator_password = var.admin_password

  storage_mb             = 32768 

  sku_name = "Standard_B1ms"
}

