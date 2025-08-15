resource "azurerm_resource_group" "rg-shared" {
  name     = "rg-shared"
  location = "UK South"
}

resource "azurerm_storage_account" "storage" {
  name                     = "psy-storage-account"
  resource_group_name      = azurerm_resource_group.rg-shared.name
  location                 = azurerm_resource_group.rg-shared.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "psy-container"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}

module "network-shared" {
  source              = "../../modules/network/shared"
  vnet_name           = "shared-vnet"
  address_space       = ["10.1.0.0/16"]
  resource_group_name = azurerm_resource_group.rg-shared.name
  location            = azurerm_resource_group.rg-shared.location

  subnet_name_bastion      = "AzureBastionSubnet"
  address_prefixes_bastion = ["10.1.1.0/24"]

  subnet_name_sonarqube      = "sonarqube-subnet"
  address_prefixes_sonarqube = ["10.1.2.0/24"]
}

module "vm-bastion" {
  source              = "../../modules/vm"
  resource_group_name = azurerm_resource_group.rg-shared.name
  location            = azurerm_resource_group.rg-shared.location
  vm_name             = "bastion-vm"
  vm_size             = "Standard_B2s"
  admin_username      = "azureuser"
  ssh_public_key      = file("~/.ssh/id_rsa.pub")
  subnet_id           = module.network-shared.subnet_id_bastion
  nic_name            = "bastion-nic"
  create_public_ip    = true
  public_ip_name      = "bastion-public-ip"
}

module "vm-sonarqube" {
  source              = "../../modules/vm"
  resource_group_name = azurerm_resource_group.rg-shared.name
  location            = azurerm_resource_group.rg-shared.location
  vm_name             = "sonarqube-vm"
  vm_size             = "Standard_B2s"
  admin_username      = "azureuser"
  ssh_public_key      = file("~/.ssh/id_rsa.pub")
  subnet_id           = module.network-shared.subnet_id_sonarqube
  nic_name            = "sonarqube-nic"
  create_public_ip    = false
  public_ip_name      = "sonarqube-public-ip"
}



data "azurerm_virtual_network" "integration_vnet" {
  name                = "integration-vnet"
  resource_group_name = "rg-int"
}


resource "azurerm_virtual_network_peering" "shared_to_integration" {
  name = "shared-to-integration"
  resource_group_name = azurerm_resource_group.rg-shared.name
  virtual_network_name = module.network-shared.vnet_name
  remote_virtual_network_id = data.azurerm_virtual_network.integration_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
}



data "azurerm_virtual_network" "preprod_vnet" {
  name = "preprod-vnet"
  resource_group_name = "preprod-rg"
}

resource "azurerm_virtual_network_peering" "shared_to_preprod" {
  name = "shared-to-preprod"
  resource_group_name = azurerm_resource_group.rg-shared.name
  virtual_network_name = module.network-shared.vnet_name
  remote_virtual_network_id = data.azurerm_virtual_network.preprod_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
}