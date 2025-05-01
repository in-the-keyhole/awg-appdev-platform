resource azurerm_monitor_workspace platform {
  name = var.default_name
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name
  location = var.resource_location
  
  public_network_access_enabled = false

  lifecycle {
    ignore_changes = [tags]
  }
}

locals {
  azure_monitor_location_to_geo = {
    "southcentralus" = "southcentralus"
    "northcentralus" = "northcentralus"
  }
}

locals {
  monitor_subresources = {
    "prometheusMetrics" = "privatelink.${local.azure_monitor_location_to_geo[azurerm_monitor_workspace.platform.location]}.prometheus.monitor.azure.com"
  }
}

# expose each subresource of the monitor to the private VNet
resource azurerm_private_endpoint monitor {
  for_each = local.monitor_subresources

  name = "${azurerm_monitor_workspace.platform.name}-${each.key}-2-${azurerm_virtual_network.platform.name}"
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name
  location = azurerm_virtual_network.platform.location

  subnet_id = azurerm_subnet.private.id

  private_service_connection {
    name = "${azurerm_monitor_workspace.platform.name}-${each.key}-2-${azurerm_virtual_network.platform.name}"
    private_connection_resource_id = azurerm_monitor_workspace.platform.id
    subresource_names = [each.key]
    is_manual_connection = false
  }

  lifecycle {
    ignore_changes = [tags, private_dns_zone_group]
  }
}

resource azurerm_monitor_private_link_scope monitor {
  name = azurerm_monitor_workspace.platform.name
  tags = var.default_tags
  resource_group_name = azurerm_monitor_workspace.platform.resource_group_name

  ingestion_access_mode = "PrivateOnly"
  query_access_mode = "PrivateOnly"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource azurerm_private_endpoint monitor_link_scope {
  name = "${azurerm_monitor_private_link_scope.monitor.name}-azuremonitor-2-${azurerm_virtual_network.platform.name}"
  tags = var.default_tags
  resource_group_name = azurerm_monitor_private_link_scope.monitor.resource_group_name
  location = azurerm_monitor_workspace.platform.location

  subnet_id = azurerm_subnet.private.id

  private_service_connection {
    name = "${azurerm_monitor_private_link_scope.monitor.name}-azuremonitor-2-${azurerm_virtual_network.platform.name}"
    private_connection_resource_id = azurerm_monitor_private_link_scope.monitor.id
    subresource_names = ["azuremonitor"]
    is_manual_connection = false
  }

  lifecycle {
    ignore_changes = [ tags ]
  }
}
