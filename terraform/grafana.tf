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

locals {
  azurerm_dashboard_grafana_managed_private_endpoint_fullname = "${azurerm_dashboard_grafana.grafana.name}-prometheusMetrics-2-${azurerm_virtual_network.platform.name}"
  azurerm_dashboard_grafana_managed_private_endpoint_name = "${substr(local.azurerm_dashboard_grafana_managed_private_endpoint_fullname, 0, min(14, length((local.azurerm_dashboard_grafana_managed_private_endpoint_fullname))))}-${substr(sha1(local.azurerm_dashboard_grafana_managed_private_endpoint_fullname), 0, 5)}"
}

# allows grafana to reach out to prometheus metrics
resource azurerm_dashboard_grafana_managed_private_endpoint grafana {
  name = local.azurerm_dashboard_grafana_managed_private_endpoint_name
  tags = var.default_tags
  location = azurerm_virtual_network.platform.location

  grafana_id = azurerm_dashboard_grafana.grafana.id
  group_ids = ["prometheusMetrics"]

  private_link_resource_id = azurerm_monitor_workspace.platform.id
  private_link_resource_region = azurerm_monitor_workspace.platform.location

  lifecycle {
    ignore_changes = [ tags ]
  }
}

resource azurerm_role_assignment grafana_monitoring_data_reader_role {
  role_definition_name = "Monitoring Data Reader"
  scope = azurerm_monitor_workspace.platform.id
  principal_id = azurerm_dashboard_grafana.grafana.identity[0].principal_id
}

resource azurerm_role_assignment grafana_monitoring_reader_role {
  role_definition_name = "Monitoring Reader"
  scope = azurerm_monitor_workspace.platform.id
  principal_id = azurerm_dashboard_grafana.grafana.identity[0].principal_id
}

resource azurerm_role_assignment self_grafana_admin_role {
  role_definition_name = "Grafana Admin"
  scope = azurerm_dashboard_grafana.grafana.id
  principal_id = data.azurerm_client_config.current.object_id
}
