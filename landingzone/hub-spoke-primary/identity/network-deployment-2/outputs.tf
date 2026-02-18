# VNet diagnostic settings outputs
output "vnet_diagnostic_setting_id" {
  description = "The ID of the VNet diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.identity_vnet_diagnostics.id
}

output "vnet_diagnostic_setting_name" {
  description = "The name of the VNet diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.identity_vnet_diagnostics.name
}

# VNet flow log outputs
output "vnet_flow_log_id" {
  description = "The ID of the VNet flow log"
  value       = azurerm_network_watcher_flow_log.identity_vnet_flow_log.id
}

output "vnet_flow_log_name" {
  description = "The name of the VNet flow log"
  value       = azurerm_network_watcher_flow_log.identity_vnet_flow_log.name
}

# Referenced resource outputs for downstream deployments
output "identity_vnet_id" {
  description = "The ID of the Identity VNet"
  value       = data.azurerm_virtual_network.identity_vnet.id
}

output "identity_vnet_name" {
  description = "The name of the Identity VNet"
  value       = data.azurerm_virtual_network.identity_vnet.name
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace used for diagnostics"
  value       = data.azurerm_log_analytics_workspace.management_law.id
}

output "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace used for diagnostics"
  value       = data.azurerm_log_analytics_workspace.management_law.name
}

output "network_storage_account_id" {
  description = "The ID of the network storage account used for flow logs"
  value       = data.azurerm_storage_account.identity_network_storage.id
}

output "network_storage_account_name" {
  description = "The name of the network storage account used for flow logs"
  value       = data.azurerm_storage_account.identity_network_storage.name
}

# ============================================
# Standard Outputs (auto-generated for cross-deployment compatibility)
# These outputs are required by downstream deployments via terraform_remote_state
# ============================================

output "vnet_id" {
  description = "The ID of the deployed Virtual Network"
  value       = azurerm_virtual_network.identity_vnet.id
}

output "vnet_name" {
  description = "The name of the deployed Virtual Network"
  value       = azurerm_virtual_network.identity_vnet.name
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = null  # TODO: Set to the correct resource reference
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = null  # TODO: Set to the correct resource reference
}

output "location" {
  description = "The Azure region of the deployment"
  value       = null  # TODO: Set to the correct resource reference
}
