variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "subnet_name_bastion" {
  type = string
}

variable "address_prefixes_bastion" {
  type = list(string)
}

variable "subnet_name_sonarqube" {
  type = string
}

variable "address_prefixes_sonarqube" {
  type = list(string)
}
