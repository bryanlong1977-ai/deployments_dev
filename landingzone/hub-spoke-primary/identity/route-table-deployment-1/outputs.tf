output "route_table_id" {
  description = "The ID of the Identity route table"
  value       = azurerm_route_table.identity.id
}

output "route_table_name" {
  description = "The name of the Identity route table"
  value       = azurerm_route_table.identity.name
}

output "route_table_resource_group_name" {
  description = "The resource group name containing the route table"
  value       = azurerm_resource_group.route_table.name
}

output "route_table_resource_group_id" {
  description = "The ID of the resource group containing the route table"
  value       = azurerm_resource_group.route_table.id
}

output "default_route_id" {
  description = "The ID of the default route to firewall"
  value       = azurerm_route.default_to_firewall.id
}

output "subnet_route_table_association_ids" {
  description = "Map of subnet names to their route table association IDs"
  value = {
    (var.subnet_pe_name)      = azurerm_subnet_route_table_association.pe.id
    (var.subnet_tools_name)   = azurerm_subnet_route_table_association.tools.id
    (var.subnet_inbound_name) = azurerm_subnet_route_table_association.inbound.id
    (var.subnet_outbound_name) = azurerm_subnet_route_table_association.outbound.id
    (var.subnet_dc_name)      = azurerm_subnet_route_table_association.dc.id
    (var.subnet_ib_mgmt_name) = azurerm_subnet_route_table_association.ib_mgmt.id
    (var.subnet_ib_lan1_name) = azurerm_subnet_route_table_association.ib_lan1.id
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
