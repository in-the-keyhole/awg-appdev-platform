# general use container registry for the appdev platform
resource azurerm_container_registry platform {
  name = replace(var.default_name, "-", "")
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name
  location = var.resource_location
  sku = "Premium"
  admin_enabled = false

  lifecycle {
    ignore_changes = [ tags ]
    prevent_destroy = true
  }
}

locals {
  container-registry-subresources = {
    "registry" = "privatelink.azurecr.io"
  }
}

# expose each service of the general use container registry to the private VNet
resource azurerm_private_endpoint container_registry {
  for_each = local.container-registry-subresources

  name = "${azurerm_container_registry.platform.name}-${each.key}-2-${azurerm_virtual_network.platform.name}"
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name
  location = azurerm_virtual_network.platform.location
  subnet_id = azurerm_subnet.private.id

  private_service_connection {
    name = "${azurerm_container_registry.platform.name}-${each.key}-2-${azurerm_virtual_network.platform.name}"
    private_connection_resource_id = azurerm_container_registry.platform.id
    subresource_names = [each.key]
    is_manual_connection = false
  }

  private_dns_zone_group {
    name = "${azurerm_container_registry.platform.name}-${each.key}-2-hub"
    private_dns_zone_ids = [
      "${var.privatelink_zone_resource_group_id}/providers/Microsoft.Network/privateDnsZones/${each.value}"
    ]
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
