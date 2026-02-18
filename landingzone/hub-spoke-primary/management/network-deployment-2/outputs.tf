#--------------------------------------------------------------
# VNet Outputs
#--------------------------------------------------------------
output "vnet_id" {
  description = "The ID of the Management VNet"
  value       = data.azurerm_virtual_network.mgmt_vnet.id
}

output "vnet_name" {
  description = "The name of the Management VNet"
  value       = data.azurerm_virtual_network.mgmt_vnet.name
}

output "vnet_resource_group_name" {
  description = "The resource group name of the Management VNet"
  value       = data.azurerm_virtual_network.mgmt_vnet.resource_group_name
}

#--------------------------------------------------------------
# Diagnostic Settings Outputs
#--------------------------------------------------------------
output "vnet_diagnostic_setting_id" {
  description = "The ID of the VNet diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.mgmt_vnet_diag.id
}

output "vnet_diagnostic_setting_name" {
  description = "The name of the VNet diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.mgmt_vnet_diag.name
}

#--------------------------------------------------------------
# DNS Link Outputs
#--------------------------------------------------------------
output "dns_ruleset_vnet_link_id" {
  description = "The ID of the DNS forwarding ruleset VNet link"
  value       = azurerm_private_dns_resolver_virtual_network_link.mgmt_vnet_dns_link.id
}

output "dns_ruleset_vnet_link_name" {
  description = "The name of the DNS forwarding ruleset VNet link"
  value       = azurerm_private_dns_resolver_virtual_network_link.mgmt_vnet_dns_link.name
}

output "dns_zone_vnet_link_ids" {
  description = "Map of DNS zone names to their VNet link IDs"
  value       = { for k, v in azurerm_private_dns_zone_virtual_network_link.mgmt_vnet_dns_zone_links : k => v.id }
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

output "flow_log_storage_account_id" {
  description = "The storage account ID used for flow logs"
  value       = data.azurerm_storage_account.mgmt_ntwk_sa.id
}

output "flow_log_log_analytics_workspace_id" {
  description = "The Log Analytics workspace ID used for flow log traffic analytics"
  value       = data.azurerm_log_analytics_workspace.mgmt_law.id
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
