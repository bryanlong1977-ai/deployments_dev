output "route_table_id" {
  description = "The ID of the route table"
  value       = azurerm_route_table.identity_rt.id
}

output "route_table_name" {
  description = "The name of the route table"
  value       = azurerm_route_table.identity_rt.name
}

output "route_table_resource_group_name" {
  description = "The resource group name where the route table is deployed"
  value       = azurerm_resource_group.route_table_rg.name
}

output "route_table_resource_group_id" {
  description = "The ID of the route table resource group"
  value       = azurerm_resource_group.route_table_rg.id
}

output "default_route_id" {
  description = "The ID of the default route to firewall"
  value       = azurerm_route.default_to_firewall.id
}

output "default_route_name" {
  description = "The name of the default route"
  value       = azurerm_route.default_to_firewall.name
}

output "subnet_associations" {
  description = "Map of subnet names to their route table association IDs"
  value = {
    "snet-pe-idm-eus2-01"       = azurerm_subnet_route_table_association.pe_subnet_association.id
    "snet-tools-idm-eus2-01"    = azurerm_subnet_route_table_association.tools_subnet_association.id
    "snet-inbound-idm-eus2-01"  = azurerm_subnet_route_table_association.inbound_subnet_association.id
    "snet-outbound-idm-eus2-01" = azurerm_subnet_route_table_association.outbound_subnet_association.id
    "snet-dc-idm-eus2-01"       = azurerm_subnet_route_table_association.dc_subnet_association.id
    "snet-ib-mgmt-idm-eus2-01"  = azurerm_subnet_route_table_association.ib_mgmt_subnet_association.id
    "snet-ib-lan1-idm-eus2-01"  = azurerm_subnet_route_table_association.ib_lan1_subnet_association.id
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
