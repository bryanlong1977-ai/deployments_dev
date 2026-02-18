# Outputs for Route Table Deployment 1 - Connectivity Subscription
# These outputs can be referenced by downstream deployments via terraform_remote_state

output "route_table_id" {
  description = "The ID of the route table"
  value       = azurerm_route_table.hub.id
}

output "route_table_name" {
  description = "The name of the route table"
  value       = azurerm_route_table.hub.name
}

output "route_table_resource_group_name" {
  description = "The name of the resource group containing the route table"
  value       = azurerm_resource_group.route_table.name
}

output "route_table_resource_group_id" {
  description = "The ID of the resource group containing the route table"
  value       = azurerm_resource_group.route_table.id
}

output "route_table_location" {
  description = "The location of the route table"
  value       = azurerm_route_table.hub.location
}

output "bgp_route_propagation_enabled" {
  description = "Whether BGP route propagation is enabled on this route table"
  value       = azurerm_route_table.hub.bgp_route_propagation_enabled
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
  value       = azurerm_resource_group.route_table.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.route_table.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.route_table.location
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
  value       = azurerm_resource_group.route_table.name
}
