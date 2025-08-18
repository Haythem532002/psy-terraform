terraform {
  backend "azurerm" {
    resource_group_name = "rg-shared"
    storage_account_name = "psy-storage-account"
    container_name = "psy-container"
    key = "preprod.terraform.tfstate"
  }
}