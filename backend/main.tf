resource "azurerm_storage_account" "storage" {
  name = "terraform-psy-storage"
  resource_group_name = var.resource_group_name
  location = var.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name = "psy-container"
  storage_account_id = azurerm_storage_account.storage.id
  container_access_type = "private"
}