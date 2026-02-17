# =============================================================================
# Diagnostic Setting Outputs
# =============================================================================

output "vnet_diagnostic_setting_id" {
  description = "ID of the VNet diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.vnet_diagnostics.id
}

output "vnet_diagnostic_setting_name" {
  description = "Name of the VNet diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.vnet_diagnostics.name
}

# =============================================================================
# Flow Log Outputs
# =============================================================================

output "vnet_flow_log_id" {
  description = "ID of the VNet flow log"
  value       = azurerm_network_watcher_flow_log.vnet_flow_log.id
}

output "vnet_flow_log_name" {
  description = "Name of the VNet flow log"
  value       = azurerm_network_watcher_flow_log.vnet_flow_log.name
}

output "vnet_flow_log_enabled" {
  description = "Whether flow logging is enabled"
  value       = azurerm_network_watcher_flow_log.vnet_flow_log.enabled
}

# =============================================================================
# Reference Outputs (from remote state)
# =============================================================================

output "vnet_id" {
  description = "ID of the Identity VNet (from remote state)"
  value       = data.terraform_remote_state.identity_network_deployment_1.outputs.vnet_id
}

output "vnet_name" {
  description = "Name of the Identity VNet (from remote state)"
  value       = data.terraform_remote_state.identity_network_deployment_1.outputs.vnet_name
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace used for diagnostics"
  value       = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id
}

output "network_storage_account_id" {
  description = "ID of the network storage account used for flow logs"
  value       = data.terraform_remote_state.identity_tools_deployment_1.outputs.network_storage_account_id
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
