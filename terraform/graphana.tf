resource azurerm_dashboard_grafana grafana {
  name = var.default_name
  tags = var.default_tags
  resource_group_name = azurerm_resource_group.platform.name
  location = var.resource_location
  grafana_major_version = "11"

  identity {
    type = "SystemAssigned"
  }

  azure_monitor_workspace_integrations {
    resource_id = azurerm_monitor_workspace.platform.id
  }

  lifecycle {
    ignore_changes = [ tags ]
  }
}

resource azurerm_role_assignment monitoring_data_reader_role {
  role_definition_name = "Monitoring Data Reader"
  scope = azurerm_monitor_workspace.platform.id
  principal_id = azurerm_dashboard_grafana.grafana.identity[0].principal_id
}

resource azurerm_role_assignment grafana_admin_role {
  role_definition_name = "Grafana Admin"
  scope = azurerm_dashboard_grafana.grafana.id
  principal_id = data.azurerm_client_config.current.object_id
}
