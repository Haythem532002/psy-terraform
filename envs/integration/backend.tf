terraform {
  backend "azurerm" {
    resource_group_name = "psy-int-rg"
    storage_account_name = "psy-storage-account"
    container_name = "psy-container"
    key = "integration.terraform.tfstate"
  }
}