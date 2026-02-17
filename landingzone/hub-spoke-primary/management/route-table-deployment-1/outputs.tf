#--------------------------------------------------------------
# Route Table Outputs
#--------------------------------------------------------------
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

output "route_table_location" {
  description = "The location of the route table"
  value       = azurerm_route_table.mgmt_rt.location
}

#--------------------------------------------------------------
# Route Outputs
#--------------------------------------------------------------
output "route_to_firewall_id" {
  description = "The ID of the default route to firewall"
  value       = azurerm_route.route_to_firewall.id
}

output "route_to_firewall_name" {
  description = "The name of the default route to firewall"
  value       = azurerm_route.route_to_firewall.name
}

#--------------------------------------------------------------
# Subnet Association Outputs
#--------------------------------------------------------------
output "pe_subnet_route_table_association_id" {
  description = "The ID of the route table association for the Private Endpoint subnet"
  value       = azurerm_subnet_route_table_association.pe_subnet_association.id
}

output "tools_subnet_route_table_association_id" {
  description = "The ID of the route table association for the Tools subnet"
  value       = azurerm_subnet_route_table_association.tools_subnet_association.id
}

#--------------------------------------------------------------
# Summary Outputs
#--------------------------------------------------------------
output "associated_subnet_names" {
  description = "List of subnet names associated with this route table"
  value = [
    var.pe_subnet_name,
    var.tools_subnet_name
  ]
}

output "route_table_routes" {
  description = "Summary of routes configured in the route table"
  value = {
    default_route = {
      name                   = azurerm_route.route_to_firewall.name
      address_prefix         = azurerm_route.route_to_firewall.address_prefix
      next_hop_type          = azurerm_route.route_to_firewall.next_hop_type
      next_hop_in_ip_address = azurerm_route.route_to_firewall.next_hop_in_ip_address
    }
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
