variable "subscription_id" {
  type = string
}

variable "default_name" {
  type = string
  default = "awg-app"
}

variable "release_name" {
  type = string
  default = "1.0.0"
}

variable "default_tags" {
  type = map(string)
  default = {}
}

variable "metadata_location" {
  type = string
  default = "westus"
  description = "Location of the resource groups and other metadata items."
}

variable "resource_location" {
  type = string
  default = "eastus"
  description = "Location of other resource items."
}

variable "vnet_hub_id" {
  type = string
}

variable "vnet_address_prefixes" {
  type = list(string)
  default = ["10.224.0.0/16"]
}

variable "default_vnet_subnet_address_prefixes" {
  type = list(string)
  default = ["10.224.0.0/24"]
}

variable "dns_zone_name" {
  type = string
  default = "appdev.az.awginc.com"
}

variable "int_dns_zone_name" {
  type = string
  default = "appdev.az.int.awginc.com"
}

variable "private_vnet_subnet_address_prefixes" {
  type = list(string)
  default = ["10.224.1.0/24"]
}

variable "aks_vnet_subnet_address_prefixes" {
  type = list(string)
  default = ["10.224.2.0/24"]
}
