resource "azurerm_container_registry" "appdev" {
  name = replace(var.default_name, "-", "")
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.appdev.name
  location = var.resource_location
  sku = "Basic"
  admin_enabled = false

  lifecycle {
    prevent_destroy = true
  }
}
