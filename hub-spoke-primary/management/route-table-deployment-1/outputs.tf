# Outputs for Route Table Deployment 1 - Management Subscription

output "route_table_id" {
  value       = azurerm_route_table.management_rt.id
  description = "The ID of the management route table"
}

output "route_table_name" {
  value       = azurerm_route_table.management_rt.name
  description = "The name of the management route table"
}

output "route_table_resource_group_name" {
  value       = azurerm_resource_group.route_table_rg.name
  description = "The name of the resource group containing the route table"
}

output "route_table_resource_group_id" {
  value       = azurerm_resource_group.route_table_rg.id
  description = "The ID of the resource group containing the route table"
}

output "default_route_id" {
  value       = azurerm_route.default_to_firewall.id
  description = "The ID of the default route to the firewall"
}

output "pe_subnet_route_table_association_id" {
  value       = azurerm_subnet_route_table_association.pe_subnet_association.id
  description = "The ID of the route table association for the private endpoint subnet"
}

output "tools_subnet_route_table_association_id" {
  value       = azurerm_subnet_route_table_association.tools_subnet_association.id
  description = "The ID of the route table association for the tools subnet"
}

output "route_table_subnets" {
  value       = azurerm_route_table.management_rt.subnets
  description = "List of subnet IDs associated with the route table"
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
  value       = azurerm_resource_group.route_table_rg.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.route_table_rg.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.route_table_rg.location
}
