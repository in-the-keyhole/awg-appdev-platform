variable subscription_id {
  description = "ID of the Azure Subscription to which resources are to be deployed."
  type = string
}

variable default_name {
  description = "Default Name or name prefix of Azure resources."
  type = string
}

variable release_name {
  description = "Name of the release."
  type = string
}

variable default_tags {
  description = "Default tags to be applied to Azure resources."
  type = map(string)
  default = {}
}

variable metadata_location {
  description = "Location of the resource groups and other metadata items."
  type = string
}

variable resource_location {
  description = "Location of resource items."
  type = string
}

variable root_ca_certs {
  type = string
}

variable hub_subscription_id {
  description = "ID of the Azure subscription hosting the hub network."
  type = string
}

variable dns_zone_name {
  description = "External DNS zone name for the platform."
  type = string
}

variable internal_dns_zone_name {
  description = "Internal DNS zone name for the platform."
  type = string
}

variable hub_vnet_id {
  description = "ID of the VNet in the hub subscription"
  type = string
}

variable dns_resolver_addresses {
  description = "Addresses of the DNS resolvers to be deployed."
  type = list(string)
}

variable vnet_dns_servers {
  description = "Addresses to configure as the default DNS servers of the Virtual Network."
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

variable aci_vnet_subnet_address_prefixes {
  type = list(string)
}
