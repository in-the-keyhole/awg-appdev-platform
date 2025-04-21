resource azurerm_recovery_services_vault platform {
  name = var.default_name
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name
  location = var.resource_location
  sku = "Standard"
  soft_delete_enabled = true
  public_network_access_enabled = false
  cross_region_restore_enabled = true

  
}

locals {
  azure_backup_location_to_geo = {
    "southcentralus" = "scus"
    "northcentralus" = "ncus"
  }
}

locals {
  recovery_services_vault_subresources = {
    "AzureBackup" = "privatelink.${local.azure_backup_location_to_geo[var.resource_location]}.backup.windowsazure.com"
  }
}

# expose each service of the container registry to the private VNet
resource azurerm_private_endpoint recovery_services_vault {
  for_each = local.recovery_services_vault_subresources

  name = "${azurerm_recovery_services_vault.platform.name}-${each.key}-2-${azurerm_virtual_network.platform.name}"
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name
  location = azurerm_virtual_network.platform.location
  subnet_id = azurerm_subnet.private.id

  private_service_connection {
    name = "${azurerm_recovery_services_vault.platform.name}-${each.key}-2-${azurerm_virtual_network.platform.name}"
    private_connection_resource_id = azurerm_recovery_services_vault.platform.id
    subresource_names = [each.key]
    is_manual_connection = false
  }

  lifecycle {
    ignore_changes = [tags]
  }
}