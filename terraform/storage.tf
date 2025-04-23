# general use storage account for the appdev platform
resource azurerm_storage_account platform {
  name = replace(var.default_name, "-", "")
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name
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
  storage_subresources = {
    "blob" = "privatelink.blob.core.windows.net",
    "file" = "privatelink.file.core.windows.net",
  }
}

# expose each service of the general use storage account to the private VNet
resource azurerm_private_endpoint storage_account {
  for_each = local.storage_subresources

  name = "${azurerm_storage_account.platform.name}-${each.key}-2-${azurerm_virtual_network.platform.name}"
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name
  location = azurerm_virtual_network.platform.location
  subnet_id = azurerm_subnet.private.id

  private_service_connection {
    name = "${azurerm_storage_account.platform.name}-${each.key}-2-${azurerm_virtual_network.platform.name}"
    private_connection_resource_id = azurerm_storage_account.platform.id
    subresource_names = [each.key]
    is_manual_connection = false
  }

  lifecycle {
    ignore_changes = [tags, private_dns_zone_group]
  }
}
