variable "vnet_name" {}
variable "address_space" {
  type = list(string)
}
variable "subnet_name_app" {}
variable "address_prefixes_app" {
  type = list(string)
}
variable "subnet_name_bastion" {}
variable "address_prefixes_bastion" {
  type = list(string)
}
variable "location" {}
variable "resource_group_name" {}
