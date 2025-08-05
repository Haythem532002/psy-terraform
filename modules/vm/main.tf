resource "azurerm_public_ip" "public_ip" {
  count = var.create_public_ip ? 1 : 0
  name = var.public_ip_name
  resource_group_name = var.resource_group_name
  location = var.location
  allocation_method = "Dynamic"
  sku = "Basic"
}

resource "azurerm_network_interface" "nic" {
  name = var.nic_name
  resource_group_name = var.resource_group_name
  location = var.location
  ip_configuration {
    name = "internal"
    subnet_id = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = var.create_public_ip ? azurerm_public_ip.public_ip[0].id : null 
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name = var.vm_name
  resource_group_name = var.resource_group_name
  location = var.location
  size                  = var.vm_size
  admin_username = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic.id]
  admin_ssh_key {
    username = var.admin_username
    public_key = var.ssh_public_key
  }
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = var.disk_size_gb
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
