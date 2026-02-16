output "vnet_diagnostic_setting_id" {
  description = "The ID of the VNet diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.identity_vnet_diag.id
}

output "vnet_diagnostic_setting_name" {
  description = "The name of the VNet diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.identity_vnet_diag.name
}

output "vnet_flow_log_id" {
  description = "The ID of the VNet flow log"
  value       = azurerm_network_watcher_flow_log.identity_vnet_flow_log.id
}

output "vnet_flow_log_name" {
  description = "The name of the VNet flow log"
  value       = azurerm_network_watcher_flow_log.identity_vnet_flow_log.name
}

output "vnet_id" {
  description = "The ID of the Identity VNet (from remote state)"
  value       = data.azurerm_virtual_network.identity_vnet.id
}

output "vnet_name" {
  description = "The name of the Identity VNet"
  value       = data.azurerm_virtual_network.identity_vnet.name
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace used for diagnostics"
  value       = data.azurerm_log_analytics_workspace.management_law.id
}

output "storage_account_id" {
  description = "The ID of the storage account used for flow logs"
  value       = data.azurerm_storage_account.identity_network_storage.id
}

output "network_watcher_name" {
  description = "The name of the Network Watcher"
  value       = data.azurerm_network_watcher.identity_nw.name
}

output "network_watcher_resource_group_name" {
  description = "The resource group name of the Network Watcher"
  value       = data.azurerm_network_watcher.identity_nw.resource_group_name
}

# ============================================
# Standard Outputs (auto-generated for cross-deployment compatibility)
# These outputs are required by downstream deployments via terraform_remote_state
# ============================================

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
