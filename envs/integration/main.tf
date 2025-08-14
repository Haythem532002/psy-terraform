resource "azurerm_resource_group" "rg-int" {
  name = "rg-int"
  location = "UK South"
}

module "network-int-app" {
  source                = "../../modules/network/app"
  vnet_name             = "integration-vnet"
  address_space         = ["10.0.0.0/16"]
  resource_group_name   = azurerm_resource_group.rg-int.name
  location              = azurerm_resource_group.rg-int.location
  address_prefixes_app  = ["10.0.0.0/24"]
  subnet_name_app       = "integration-subnet-app"
  dns_zone_name         = "pg.postgres.database.azure.com"
  dns_vnet_link         = "integration-dns-link"
}

module "vm-int-app" {
  source              = "../../modules/vm"
  vm_name             = "integration-vm"
  public_ip_name      = "integration-vm-pip"
  admin_username      = "adminuser"
  subnet_id           = module.network-int-app.subnet_id
  location            = azurerm_resource_group.rg-int.location
  ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD..."
  vm_size             = "Standard_B2s"
  resource_group_name = azurerm_resource_group.rg-int.name
  create_public_ip    = false
  nic_name            = "integration-vm-nic"
}

module "postgres-int-app" {
  source         = "../../modules/postgresql"
  subnet_id      = module.network-int-app.subnet_id_app
  admin_login    = "postgres"
  admin_password = "haythem"
  collation      = "en_US.utf8"
  dns_zone_id    = module.network-int-app.dns_zone_id
  server_name    = "psy-server"
  db_name        = "psy_project"
  version        = "16"
}


data "azurerm_virtual_network" "shared_vnet" {
  name                = "shared-vnet"
  resource_group_name = "rg-shared"
}


resource "azurerm_virtual_network_peering" "integration_to_shared" {
  name = "integration-to-shared"
  resource_group_name = azurerm_resource_group.rg-int.name
  virtual_network_name = module.network-int-app.vnet_name
  remote_virtual_network_id = data.azurerm_virtual_network.shared_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
}