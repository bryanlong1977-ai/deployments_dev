# Outputs for Route Table Deployment 1 - DMZ Subscription

output "route_table_id" {
  description = "The ID of the DMZ route table"
  value       = azurerm_route_table.dmz_rt.id
}

output "route_table_name" {
  description = "The name of the DMZ route table"
  value       = azurerm_route_table.dmz_rt.name
}

output "route_table_resource_group_name" {
  description = "The name of the resource group containing the route table"
  value       = azurerm_resource_group.route_table_rg.name
}

output "route_table_resource_group_id" {
  description = "The ID of the resource group containing the route table"
  value       = azurerm_resource_group.route_table_rg.id
}

output "route_to_firewall_id" {
  description = "The ID of the route directing traffic to the firewall"
  value       = azurerm_route.route_to_firewall.id
}

output "subnet_route_table_association_ids" {
  description = "Map of subnet names to their route table association IDs"
  value = {
    "snet-pe-dmz-wus3-01"          = azurerm_subnet_route_table_association.pe_subnet_rt_association.id
    "snet-tools-dmz-wus3-01"       = azurerm_subnet_route_table_association.tools_subnet_rt_association.id
    "snet-ifw-mgmt-dmz-wus3-01"    = azurerm_subnet_route_table_association.ifw_mgmt_subnet_rt_association.id
    "snet-ifw-untrust-dmz-wus3-01" = azurerm_subnet_route_table_association.ifw_untrust_subnet_rt_association.id
    "snet-ifw-trust-dmz-wus3-01"   = azurerm_subnet_route_table_association.ifw_trust_subnet_rt_association.id
  }
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
