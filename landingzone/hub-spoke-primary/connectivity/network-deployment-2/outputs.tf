# =============================================================================
# Outputs - Connectivity Network Deployment 2
# =============================================================================

output "vnet_diagnostic_setting_id" {
  description = "ID of the hub VNet diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "vnet_flow_log_id" {
  description = "ID of the hub VNet flow log"
  value       = azurerm_network_watcher_flow_log.this.id
}

output "dns_zone_link_ids" {
  description = "Map of private DNS zone names to their VNet link IDs"
  value       = { for k, v in azurerm_private_dns_zone_virtual_network_link.dns_zone_links : k => v.id }
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

output "hub_vnet_id" {
  description = "The ID of the hub Virtual Network (alias for vnet_id)"
  value       = null  # TODO: Set to the correct resource reference
}

output "hub_vnet_name" {
  description = "The name of the hub Virtual Network (alias for vnet_name)"
  value       = null  # TODO: Set to the correct resource reference
}

output "hub_resource_group_name" {
  description = "The name of the hub resource group (alias for resource_group_name)"
  value       = null  # TODO: Set to the correct resource reference
}
