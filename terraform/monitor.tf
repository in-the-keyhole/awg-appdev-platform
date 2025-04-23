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
