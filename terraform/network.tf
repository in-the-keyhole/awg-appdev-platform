resource "azurerm_dns_zone" "pub" {
  name = var.dns_zone_name
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.appdev.name
}

resource "azurerm_virtual_network" "appdev" {
  name = "${var.default_name}"
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.appdev.name
  location = var.resource_location
  address_space = var.vnet_address_prefixes
}

resource "azurerm_virtual_network_peering" "hub" {
  name = "appdev2hub"
  resource_group_name = azurerm_resource_group.appdev.name
  virtual_network_name = azurerm_virtual_network.appdev.name
  remote_virtual_network_id = var.
}

resource "azurerm_subnet" "default" {
  name = "default"
  resource_group_name = azurerm_resource_group.appdev.name
  virtual_network_name = azurerm_virtual_network.appdev.name
  address_prefixes = var.default_vnet_subnet_address_prefixes
}

resource "azurerm_subnet" "private" {
  name = "private"
  resource_group_name = azurerm_resource_group.appdev.name
  virtual_network_name = azurerm_virtual_network.appdev.name
  address_prefixes = var.private_vnet_subnet_address_prefixes
}

resource "azurerm_subnet" "aks" {
  name = "aks"
  resource_group_name = azurerm_resource_group.appdev.name
  virtual_network_name = azurerm_virtual_network.appdev.name
  address_prefixes = var.aks_vnet_subnet_address_prefixes
}

resource "azurerm_private_dns_zone" "int" {
  name = var.int_dns_zone_name
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.appdev.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "appdev" {
  name = "appdev"
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.appdev.name
  private_dns_zone_name = azurerm_private_dns_zone.int.name
  virtual_network_id = azurerm_virtual_network.appdev.id
}
