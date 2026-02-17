#--------------------------------------------------------------
# Diagnostic Settings Outputs
#--------------------------------------------------------------

output "vnet_diagnostic_setting_id" {
  description = "The ID of the VNet diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.mgmt_vnet_diagnostics.id
}

output "vnet_diagnostic_setting_name" {
  description = "The name of the VNet diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.mgmt_vnet_diagnostics.name
}

#--------------------------------------------------------------
# DNS Link Outputs
#--------------------------------------------------------------

output "private_dns_zone_vnet_link_ids" {
  description = "Map of Private DNS Zone virtual network link IDs"
  value       = { for k, v in azurerm_private_dns_zone_virtual_network_link.mgmt_vnet_dns_links : k => v.id }
}

output "dns_resolver_vnet_link_id" {
  description = "The ID of the DNS resolver virtual network link"
  value       = azurerm_private_dns_resolver_virtual_network_link.mgmt_vnet_dns_resolver_link.id
}

output "dns_resolver_vnet_link_name" {
  description = "The name of the DNS resolver virtual network link"
  value       = azurerm_private_dns_resolver_virtual_network_link.mgmt_vnet_dns_resolver_link.name
}

#--------------------------------------------------------------
# Flow Log Outputs
#--------------------------------------------------------------

output "vnet_flow_log_id" {
  description = "The ID of the VNet flow log"
  value       = azurerm_network_watcher_flow_log.mgmt_vnet_flow_log.id
}

output "vnet_flow_log_name" {
  description = "The name of the VNet flow log"
  value       = azurerm_network_watcher_flow_log.mgmt_vnet_flow_log.name
}

#--------------------------------------------------------------
# Resource Reference Outputs
#--------------------------------------------------------------

output "vnet_id" {
  description = "The ID of the Management VNet (from remote state)"
  value       = local.mgmt_vnet_id
}

output "vnet_name" {
  description = "The name of the Management VNet (from remote state)"
  value       = local.mgmt_vnet_name
}

output "resource_group_name" {
  description = "The resource group name for the Management VNet (from remote state)"
  value       = local.mgmt_resource_group_name
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace used for diagnostics"
  value       = local.log_analytics_workspace_id
}

# ============================================
# Standard Outputs (auto-generated for cross-deployment compatibility)
# These outputs are required by downstream deployments via terraform_remote_state
# ============================================

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = null  # TODO: Set to the correct resource reference
}

output "location" {
  description = "The Azure region of the deployment"
  value       = null  # TODO: Set to the correct resource reference
}
