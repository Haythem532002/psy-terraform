resource "azurerm_postgresql_flexible_server" "pg-server" {
  name                   = var.server_name
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  version                = var.version 
  administrator_login    = var.admin_login
  administrator_password = var.admin_password
  delegated_subnet_id = var.subnet_id
  private_dns_zone_id = var.dns_zone_id
  public_network_access_enabled = false
  
  authentication {
    password_auth_enabled         = true
    active_directory_auth_enabled = false
  }
  

  storage_mb             = 32768 

  sku_name = "Standard_B2s"
}


resource "azurerm_postgresql_flexible_server_database" "pg-db" {
  name = var.db_name
  server_id = azurerm_postgresql_flexible_server.pg-server.id
  collation = var.collation
  charset = "UTF8"
}

