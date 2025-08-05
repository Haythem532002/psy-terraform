variable "location" {}
variable "resource_group_name" {}
variable "vm_name" {}
variable "vm_size" {}
variable "admin_username" {}
variable "ssh_public_key" {}
variable "subnet_id" {}
variable "nic_name" {}
variable "public_ip_name" {}
variable "create_public_ip" {}
variable "disk_size_gb" {
    type = number
    default = 30
    description = "This is the size of the disk"
}
