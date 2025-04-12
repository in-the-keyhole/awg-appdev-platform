# general use storage account for the appdev platform
resource azurerm_storage_account appdev {
  name = replace(var.default_name, "-", "")
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.appdev.name
  location = var.resource_location
  account_tier = "Standard"
  account_kind = "StorageV2"
  account_replication_type = "LRS"
  public_network_access_enabled = false

  lifecycle {
    ignore_changes = [ tags ]
    prevent_destroy = true
  }
}

locals {
  storage-subresources = {
    "blob" = "privatelink.blob.core.windows.net",
    "file" = "privatelink.file.core.windows.net",
    "table" = "privatelink.table.core.windows.net",
    "queue" = "privatelink.queue.core.windows.net",
    "web" = "privatelink.web.core.windows.net",
    "dfs" = "privatelink.dfs.core.windows.net",
  }
}

# expose each service of the general use storage account to the private VNet
resource azurerm_private_endpoint storage_account {
  for_each = local.storage-subresources

  name = "${azurerm_storage_account.appdev.name}-${each.key}-2-${azurerm_virtual_network.appdev.name}"
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.appdev.name
  location = azurerm_virtual_network.appdev.location
  subnet_id = azurerm_subnet.private.id

  private_service_connection {
    name = "${azurerm_storage_account.appdev.name}-${each.key}-2-${azurerm_virtual_network.appdev.name}"
    private_connection_resource_id = azurerm_storage_account.appdev.id
    subresource_names = [each.key]
    is_manual_connection = false
  }

  private_dns_zone_group {
    name = "${azurerm_storage_account.appdev.name}-${each.key}-2-hub"
    private_dns_zone_ids = [
      "${var.privatelink_zone_resource_group_id}/providers/Microsoft.Network/privateDnsZones/${each.value}"
    ]
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
