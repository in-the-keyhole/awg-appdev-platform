# locals {
#   aks_prometheus_dce_name = "${azurerm_kubernetes_cluster.aks.name}-prometheus"
# }

# # data collection endpoint for Managed Prometheus
# resource azurerm_monitor_data_collection_endpoint prometheus {
#   name = substr(local.aks_prometheus_dce_name, 0, min(44, length(local.aks_prometheus_dce_name)))
#   tags = var.default_tags
#   resource_group_name = azurerm_resource_group.platform.name
#   location = azurerm_monitor_workspace.platform.location
#   kind = "Linux"

#   lifecycle {
#     ignore_changes = [ tags ]
#   }
# }

# resource azurerm_monitor_data_collection_rule prometheus {
#   description = "DCR for Azure Monitor Metrics Profile (Managed Prometheus)"
#   name = substr(local.aks_prometheus_dce_name, 0, min(64, length(local.aks_prometheus_dce_name)))
#   tags = var.default_tags
#   resource_group_name = azurerm_resource_group.aks.name
#   location = datazurerm_monitor_workspace.platform.location
#   data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.prometheus.id
#   kind = "Linux"

#   destinations {
#     monitor_account {
#       monitor_account_id = azurerm_monitor_workspace.platform.id
#       name = "MonitoringAccount1"
#     }
#   }

#   data_flow {
#     streams = ["Microsoft-PrometheusMetrics"]
#     destinations = ["MonitoringAccount1"]
#   }

#   data_sources {
#     prometheus_forwarder {
#       streams = ["Microsoft-PrometheusMetrics"]
#       name = "PrometheusDataSource"
#     }
#   }

#   lifecycle {
#     ignore_changes = [ tags ]
#   }
# }
