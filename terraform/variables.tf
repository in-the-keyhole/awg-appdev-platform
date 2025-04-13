variable subscription_id {
  type = string
}

variable default_name {
  type = string
}

variable release_name {
  type = string
}

variable default_tags {
  type = map(string)
  default = {}
}

variable metadata_location {
  type = string
  description = "Location of the resource groups and other metadata items."
}

variable resource_location {
  type = string
  description = "Location of other resource items."
}

variable dns_zone_name {
  type = string
}

variable internal_dns_zone_name {
  type = string
}

variable hub_vnet_id {
  description = "ID of the VNet in the hub subscription"
  type = string
}

variable privatelink_zone_resource_group_id {
  description = "ID of the resource group of the hub that holds the privatelink zones"
  type = string
}

variable dns_resolver_addresses {
  type = list(string)
}

variable vnet_dns_servers {
  type = list(string)
}

variable vnet_address_prefixes {
  type = list(string)
}

variable default_vnet_subnet_address_prefixes {
  type = list(string)
}

variable private_vnet_subnet_address_prefixes {
  type = list(string)
}

variable dns_vnet_subnet_address_prefixes {
  type = list(string)
}
