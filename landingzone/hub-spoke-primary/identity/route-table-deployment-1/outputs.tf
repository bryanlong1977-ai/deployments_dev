output "route_table_id" {
  description = "The ID of the Identity route table."
  value       = azurerm_route_table.this.id
}

output "route_table_name" {
  description = "The name of the Identity route table."
  value       = azurerm_route_table.this.name
}

output "route_table_resource_group_name" {
  description = "The name of the resource group containing the Identity route table."
  value       = azurerm_resource_group.this.name
}

output "subnet_route_table_association_ids" {
  description = "Map of subnet names to their route table association IDs."
  value       = { for k, v in azurerm_subnet_route_table_association.subnets : k => v.id }
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
