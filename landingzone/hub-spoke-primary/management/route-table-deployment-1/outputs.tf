output "route_table_id" {
  description = "The ID of the route table"
  value       = azurerm_route_table.mgmt_rt.id
}

output "route_table_name" {
  description = "The name of the route table"
  value       = azurerm_route_table.mgmt_rt.name
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
  description = "The ID of the default route to firewall"
  value       = azurerm_route.route_to_firewall.id
}

output "pe_subnet_route_table_association_id" {
  description = "The ID of the route table association for the PE subnet"
  value       = azurerm_subnet_route_table_association.pe_subnet_association.id
}

output "tools_subnet_route_table_association_id" {
  description = "The ID of the route table association for the Tools subnet"
  value       = azurerm_subnet_route_table_association.tools_subnet_association.id
}

output "hub_firewall_lb_ip" {
  description = "The Hub Firewall Load Balancer IP used as next hop"
  value       = var.hub_firewall_lb_ip
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
