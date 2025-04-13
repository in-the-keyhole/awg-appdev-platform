# private spoke virtual network
resource azurerm_virtual_network platform {
  name = var.default_name
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name
  location = var.resource_location
  address_space = var.vnet_address_prefixes
  dns_servers = var.vnet_dns_servers

  lifecycle {
    ignore_changes = [ tags ]
  }
}

# peer the private spoke virtual network with the hub virtual network
resource azurerm_virtual_network_peering hub {
  name = "${var.default_name}-2-hub"
  resource_group_name = azurerm_resource_group.platform.name
  virtual_network_name = azurerm_virtual_network.platform.name
  remote_virtual_network_id = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
  allow_gateway_transit = true

  lifecycle {
    prevent_destroy = true
  }
}

# default subnet
resource azurerm_subnet default {
  name = "default"
  resource_group_name = azurerm_resource_group.platform.name
  virtual_network_name = azurerm_virtual_network.platform.name
  address_prefixes = var.default_vnet_subnet_address_prefixes
}

# subnet for PrivateLink endpoints
resource azurerm_subnet private {
  name = "private"
  resource_group_name = azurerm_resource_group.platform.name
  virtual_network_name = azurerm_virtual_network.platform.name
  address_prefixes = var.private_vnet_subnet_address_prefixes
  private_link_service_network_policies_enabled = true
}

# subnet for ACI DNS resolver
resource azurerm_subnet dns {
  name = "dns"
  resource_group_name = azurerm_resource_group.platform.name
  virtual_network_name = azurerm_virtual_network.platform.name
  address_prefixes = var.dns_vnet_subnet_address_prefixes
}
