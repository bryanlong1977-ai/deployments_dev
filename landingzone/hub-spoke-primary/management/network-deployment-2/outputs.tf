# =============================================================================
# Outputs for downstream deployments
# =============================================================================

output "vnet_diagnostic_setting_id" {
  description = "The ID of the VNet diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "vnet_flow_log_id" {
  description = "The ID of the VNet flow log"
  value       = azurerm_network_watcher_flow_log.this.id
}

output "dns_zone_vnet_link_ids" {
  description = "Map of Private DNS zone names to their VNet link IDs"
  value       = { for k, v in azurerm_private_dns_zone_virtual_network_link.dns_links : k => v.id }
}

# Pass-through outputs from remote state for convenience
output "management_vnet_id" {
  description = "The Management VNet ID (from remote state)"
  value       = data.terraform_remote_state.management_network_deployment_1.outputs.vnet_id
}

output "management_vnet_name" {
  description = "The Management VNet name (from remote state)"
  value       = data.terraform_remote_state.management_network_deployment_1.outputs.vnet_name
}

output "management_resource_group_name" {
  description = "The Management network resource group name (from remote state)"
  value       = data.terraform_remote_state.management_network_deployment_1.outputs.resource_group_name
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
