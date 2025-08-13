resource "azurerm_resource_group" "rg-preprod" {
  name = "rg-preprod"
  location = "UK South"
}

module "network-preprod-app" {
  source                = "../../modules/network/app"
  vnet_name             = "preprod-vnet"
  address_space         = ["10.0.0.0/16"]
  resource_group_name   = azurerm_resource_group.rg-preprod.name
  location              = azurerm_resource_group.rg-preprod.location
  address_prefixes_app  = ["10.0.1.0/24"]
  subnet_name_app       = "preprod-subnet-app"
  dns_zone_name         = "pg.postgres.database.azure.com"
  dns_vnet_link         = "preprod-dns-link"
}

module "vm-preprod-app" {
  source              = "../../modules/vm"
  vm_name             = "preprod-vm"
  public_ip_name      = "preprod-vm-pip"
  admin_username      = "adminuser"
  subnet_id           = module.network-preprod-app.subnet_id
  location            = azurerm_resource_group.rg-preprod.location
  ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD..."
  vm_size             = "Standard_B2s"
  resource_group_name = azurerm_resource_group.rg-preprod.name
  create_public_ip    = false
  nic_name            = "preprod-vm-nic"
}

module "postgres-preprod-app" {
  source         = "../../modules/postgresql"
  subnet_id      = module.network-preprod-app.subnet_id_app
  admin_login    = "postgres"
  admin_password = "haythem"
  collation      = "en_US.utf8"
  dns_zone_id    = module.network-preprod-app.dns_zone_id
  server_name    = "psy-server"
  db_name        = "psy_project"
  version        = "16"
}