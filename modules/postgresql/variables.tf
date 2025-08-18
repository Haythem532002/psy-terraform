variable "server_name" {}
variable "version" {}

variable "admin_login" {}

variable "admin_password" {}

variable "subnet_id" {}

variable "dns_zone_id" {}

variable "db_name" {}
variable "collation" {}

# Missing variables - FIX
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}
