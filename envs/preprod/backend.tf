terraform {
  backend "azurerm" {
    resource_group_name = "psy-shared-rg"
    storage_account_name = "psy-storage-account"
    container_name = "psy-container"
    key = "preprod.terraform.tfstate"
  }
}