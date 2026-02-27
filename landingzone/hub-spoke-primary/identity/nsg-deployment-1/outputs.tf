# -----------------------------------------------------------------------------
# NSG Resource Group
# -----------------------------------------------------------------------------
output "nsg_resource_group_name" {
  description = "Name of the NSG resource group."
  value       = azurerm_resource_group.this.name
}

output "nsg_resource_group_id" {
  description = "ID of the NSG resource group."
  value       = azurerm_resource_group.this.id
}

# -----------------------------------------------------------------------------
# NSG IDs — map keyed by subnet name
# -----------------------------------------------------------------------------
output "nsg_ids" {
  description = "Map of subnet name to NSG resource ID."
  value       = { for k, v in azurerm_network_security_group.nsgs : k => v.id }
}

# -----------------------------------------------------------------------------
# NSG Names — map keyed by subnet name
# -----------------------------------------------------------------------------
output "nsg_names" {
  description = "Map of subnet name to NSG name."
  value       = { for k, v in azurerm_network_security_group.nsgs : k => v.name }
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
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.this.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.this.location
}
