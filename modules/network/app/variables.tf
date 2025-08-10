variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "subnet_name_app" {
  type = string
}

variable "address_prefixes_app" {
  type = list(string)
}

variable "dns_zone_name" {
  type = string
}

variable "dns_vnet_link" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

