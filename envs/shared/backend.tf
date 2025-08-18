# Backend configuration - COMMENTED OUT for initial deployment
# Uncomment after storage account is created and update storage_account_name
# 
# terraform {
#   backend "azurerm" {
#     resource_group_name = "rg-shared"
#     storage_account_name = "psystorageaccount0818"  # Update with actual name after creation
#     container_name = "psy-container"
#     key = "shared.terraform.tfstate"
#   }
# }