resource "azurerm_recovery_services_vault" "vault" {
  name = var.default_name
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name
  location = var.resource_location
  sku = "Standard"
  soft_delete_enabled = true
  public_network_access_enabled = false
  cross_region_restore_enabled = true
}
