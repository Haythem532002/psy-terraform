# Create the VNet
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Create a subnet for app/db VMs (no SSH here)
resource "azurerm_subnet" "subnet_app" {
  name                 = var.subnet_name_app
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes_app
}

# Create a subnet for Bastion VM (SSH allowed here)
resource "azurerm_subnet" "subnet_bastion" {
  name                 = var.subnet_name_bastion
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes_bastion
}

# NSG for Bastion only (SSH allowed)
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

# Associate NSG only to Bastion subnet
resource "azurerm_subnet_network_security_group_association" "assoc_bastion" {
  subnet_id                 = azurerm_subnet.subnet_bastion.id
  network_security_group_id = azurerm_network_security_group.nsg_bastion.id
}
