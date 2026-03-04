# =============================================================================
# Outputs - Identity Network Deployment 2
# =============================================================================

output "diagnostic_setting_id" {
  description = "The ID of the diagnostic setting for the Identity VNet."
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "flow_log_id" {
  description = "The ID of the VNet flow log for the Identity VNet."
  value       = azurerm_network_watcher_flow_log.this.id
}

output "identity_vnet_id" {
  description = "The Identity VNet ID (passed through from remote state)."
  value       = data.terraform_remote_state.identity_network_deployment_1.outputs.vnet_id
}

output "identity_vnet_name" {
  description = "The Identity VNet name (passed through from remote state)."
  value       = data.terraform_remote_state.identity_network_deployment_1.outputs.vnet_name
}

# ============================================
# Standard Outputs (auto-generated for cross-deployment compatibility)
# These outputs are required by downstream deployments via terraform_remote_state
# ============================================

output "vnet_id" {
  description = "The ID of the deployed Virtual Network"
  value       = null  # TODO: Set to the correct resource reference
}

output "vnet_name" {
  description = "The name of the deployed Virtual Network"
  value       = null  # TODO: Set to the correct resource reference
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
