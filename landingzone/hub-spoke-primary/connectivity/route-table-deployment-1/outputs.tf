# =============================================================================
# Outputs - Route Table Deployment 1 - Connectivity
# =============================================================================

output "route_table_id" {
  description = "The ID of the connectivity route table."
  value       = azurerm_route_table.this.id
}

output "route_table_name" {
  description = "The name of the connectivity route table."
  value       = azurerm_route_table.this.name
}

output "route_table_resource_group_name" {
  description = "The resource group name where the route table is deployed."
  value       = azurerm_resource_group.this.name
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
