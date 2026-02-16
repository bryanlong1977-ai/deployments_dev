#--------------------------------------------------------------
# Diagnostic Settings Outputs
#--------------------------------------------------------------
output "vnet_diagnostic_setting_id" {
  description = "The ID of the VNet diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.vnet_diagnostics.id
}

output "vnet_diagnostic_setting_name" {
  description = "The name of the VNet diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.vnet_diagnostics.name
}

#--------------------------------------------------------------
# Flow Log Outputs
#--------------------------------------------------------------
output "vnet_flow_log_id" {
  description = "The ID of the VNet flow log"
  value       = azurerm_network_watcher_flow_log.vnet_flow_log.id
}

output "vnet_flow_log_name" {
  description = "The name of the VNet flow log"
  value       = azurerm_network_watcher_flow_log.vnet_flow_log.name
}

output "flow_log_enabled" {
  description = "Whether flow logging is enabled"
  value       = azurerm_network_watcher_flow_log.vnet_flow_log.enabled
}

output "traffic_analytics_enabled" {
  description = "Whether traffic analytics is enabled"
  value       = var.enable_traffic_analytics
}

#--------------------------------------------------------------
# DNS Zone Link Outputs
#--------------------------------------------------------------
output "dns_zone_link_ids" {
  description = "Map of Private DNS Zone names to their VNet link IDs"
  value       = { for zone, link in azurerm_private_dns_zone_virtual_network_link.dns_zone_links : zone => link.id }
}

output "dns_zone_link_names" {
  description = "Map of Private DNS Zone names to their VNet link names"
  value       = { for zone, link in azurerm_private_dns_zone_virtual_network_link.dns_zone_links : zone => link.name }
}

output "linked_dns_zones" {
  description = "List of Private DNS Zones linked to the Management VNet"
  value       = keys(azurerm_private_dns_zone_virtual_network_link.dns_zone_links)
}

#--------------------------------------------------------------
# Reference Outputs (from remote state)
#--------------------------------------------------------------
output "vnet_id" {
  description = "The ID of the Management VNet (from remote state)"
  value       = data.terraform_remote_state.management_network_deployment_1.outputs.vnet_id
}

output "vnet_name" {
  description = "The name of the Management VNet"
  value       = var.vnet_name
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace used for diagnostics (from remote state)"
  value       = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id
}

output "network_storage_account_id" {
  description = "The ID of the Network Storage Account used for flow logs (from remote state)"
  value       = data.terraform_remote_state.management_tools_deployment_2.outputs.network_storage_account_id
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
