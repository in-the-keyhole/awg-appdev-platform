# container registry for the appdev platform
resource azurerm_container_registry platform {
  name = replace(var.default_name, "-", "")
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name
  location = var.resource_location
  sku = "Premium"
  admin_enabled = false
  anonymous_pull_enabled = true
  public_network_access_enabled = true

  lifecycle {
    ignore_changes = [ tags ]
    prevent_destroy = true
  }
}

# grant ourselves push permissions
resource azurerm_role_assignment self_acr_push {
  role_definition_name = "AcrPush"
  scope = azurerm_container_registry.platform.id
  principal_id = data.azurerm_client_config.current.object_id
}

locals {
  container-registry-subresources = {
    registry = "privatelink.azurecr.io"
  }
}

# expose each service of the container registry to the private VNet
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

  lifecycle {
    ignore_changes = [tags, private_dns_zone_group]
  }
}
