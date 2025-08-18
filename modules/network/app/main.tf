resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet_app" {
  name                 = var.subnet_name_app
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes_app

  delegation {
    name = "psql-delegation"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_private_dns_zone" "postgres_dns" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_vnet_link" {
  name                  = var.dns_vnet_link
  private_dns_zone_name  = azurerm_private_dns_zone.postgres_dns.name
  resource_group_name    = var.resource_group_name
  virtual_network_id     = azurerm_virtual_network.vnet.id
  depends_on            = [azurerm_subnet.subnet_app]
}



resource "azurerm_network_security_group" "app_ngs" {
  name = "app-nsg"
  resource_group_name = var.resource_group_name
  location = var.location

  security_rule {
    name = "AppToSonarqube"
    priority = 110
    access = "Allow"
    direction = "Outbound"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "9000"
    source_address_prefix = "*"
    destination_address_prefix = "10.1.2.0/24"
  }

  # Allow HTTP/HTTPS traffic for application
  security_rule {
    name = "AllowHTTP"
    priority = 120
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name = "AllowHTTPS"
    priority = 130
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "443"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

  # Allow SSH from bastion subnet
  security_rule {
    name = "AllowSSHFromBastion"
    priority = 140
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "10.1.1.0/24"
    destination_address_prefix = "*"
  }
}

# Associate NSG with app subnet
resource "azurerm_subnet_network_security_group_association" "app_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet_app.id
  network_security_group_id = azurerm_network_security_group.app_ngs.id
}
