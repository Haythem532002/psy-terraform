output "pg_fqdn" {
  value = azurerm_postgresql_flexible_server.pg-server.fqdn
}

output "pg_username" {
  value = azurerm_postgresql_flexible_server.pg-server.administrator_login
}

output "pg_password" {
  value     = azurerm_postgresql_flexible_server.pg-server.administrator_password
  sensitive = true
}