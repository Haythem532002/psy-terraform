resource "azurerm_virtual_network" "vnet" {
  name = var.vnet_name
  address_space = var.address_space
  location = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name = var.subnet_name
  resource_group_name = var.resource_group_name
  address_prefixes = var.subnet_prefixes
  virtual_network_name = azurerm_virtual_network.vnet.name
  
}

resource "azurerm_network_security_group" "nsg" {
  name = var.nsg_name
  location = var.location
  resource_group_name = var.resource_group_name


    security_rule {
        name                       = "RDP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

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

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}