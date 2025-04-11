resource "azurerm_key_vault" "appdev" {
  name = var.default_name
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.appdev.name
  location = var.resource_location
  sku_name = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id

  network_acls {
    default_action = "Deny"
    bypass = "AzureServices"
  }

  lifecycle {
    prevent_destroy = true
  }
}
