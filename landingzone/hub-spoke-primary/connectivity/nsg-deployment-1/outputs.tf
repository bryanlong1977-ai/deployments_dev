# =============================================================================
# Outputs for Connectivity NSG Deployment 1
# =============================================================================

output "nsg_resource_group_name" {
  description = "The name of the NSG resource group."
  value       = azurerm_resource_group.this.name
}

output "nsg_resource_group_id" {
  description = "The ID of the NSG resource group."
  value       = azurerm_resource_group.this.id
}

output "nsg_ids" {
  description = "Map of subnet name to NSG resource ID."
  value       = { for k, v in azurerm_network_security_group.nsgs : k => v.id }
}

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
  value       = azurerm_resource_group.this.name
}
