resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet_bastion" {
  name                 = var.subnet_name_bastion
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes_bastion
}

resource "azurerm_subnet" "subnet_sonarqube" {
  name                 = var.subnet_name_sonarqube
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes_sonarqube
}

resource "azurerm_network_security_group" "nsg_bastion" {
  name                = "nsg-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "assoc_bastion" {
  subnet_id                 = azurerm_subnet.subnet_bastion.id
  network_security_group_id = azurerm_network_security_group.nsg_bastion
}
