resource "azurerm_storage_account" "appdev" {
  name = replace(var.default_name, "-", "")
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.appdev.name
  location = var.resource_location
  account_tier = "Standard"
  account_kind = "StorageV2"
  account_replication_type = "LRS"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_private_endpoint" "azurerm_storage_account" {
  name = azurerm_storage_account.appdev.name
  resource_group_name = azurerm_resource_group.appdev.name
  location = azurerm_virtual_network.appdev.location
  subnet_id = azurerm_subnet.default.id

  private_service_connection {
    name = azurerm_storage_account.appdev.name
    private_connection_resource_id = azurerm_storage_account.appdev.id
    is_manual_connection = false
  }
}
