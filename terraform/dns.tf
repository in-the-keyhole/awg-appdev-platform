# public DNS zone
resource azurerm_dns_zone platform {
  name = var.dns_zone_name
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name

  lifecycle {
    ignore_changes = [ tags ]
  }
}

# internal DNS zone
resource azurerm_private_dns_zone internal {
  name = var.internal_dns_zone_name
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name

  lifecycle {
    ignore_changes = [ tags ]
  }
}

# link the internal DNS zone to the VNet
resource azurerm_private_dns_zone_virtual_network_link internal {
  name = "${azurerm_private_dns_zone.internal.name}-2-${azurerm_virtual_network.platform.name}"
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name
  private_dns_zone_name = azurerm_private_dns_zone.internal.name
  virtual_network_id = azurerm_virtual_network.platform.id

  lifecycle {
    ignore_changes = [ tags ]
  }
  
  depends_on = [ 
    azurerm_private_dns_zone.internal
  ]
}


locals {
  privatelink_zone_names = toset([
    "${var.default_name}.privatelink.southcentralus.azmk8s.io"
  ])
}

# generate a private DNS zone for each item in the name table
resource azurerm_private_dns_zone privatelink_zones {
  for_each = local.privatelink_zone_names

  name = each.key
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name

  lifecycle {
    ignore_changes = [tags]
  }
}

# calculate map of private zone name to resource
locals {
  privatelink_zones_by_name = {
    for i in azurerm_private_dns_zone.privatelink_zones : i.name => i
  }
}

# link each private DNS zone with the platform network
resource azurerm_private_dns_zone_virtual_network_link privatelink {
  for_each = local.privatelink_zone_names

  name = "${local.privatelink_zones_by_name[each.key].name}-2-${azurerm_virtual_network.platform.name}"
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name
  private_dns_zone_name = local.privatelink_zones_by_name[each.key].name
  virtual_network_id = azurerm_virtual_network.platform.id

  lifecycle {
    ignore_changes = [tags]
  }
}

module dns_resolver {
  source = "../../awg-appdev-modules/terraform/dns-resolver"
  name = "${var.default_name}"
  tags = var.default_tags
  resource_group = azurerm_resource_group.platform
  location = var.resource_location
  subnet = azurerm_subnet.dns
  addresses = var.dns_resolver_addresses
}

output dns_resolver_password {
  value = nonsensitive(module.dns_resolver.password)
}
