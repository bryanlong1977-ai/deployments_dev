# Outputs for Route Table Deployment 1 - DMZ Subscription

output "route_table_id" {
  description = "The ID of the DMZ route table"
  value       = azurerm_route_table.dmz_route_table.id
}

output "route_table_name" {
  description = "The name of the DMZ route table"
  value       = azurerm_route_table.dmz_route_table.name
}

output "route_table_resource_group_name" {
  description = "The resource group name where the route table is deployed"
  value       = azurerm_resource_group.route_table_rg.name
}

output "route_table_resource_group_id" {
  description = "The ID of the resource group where the route table is deployed"
  value       = azurerm_resource_group.route_table_rg.id
}

output "default_route_id" {
  description = "The ID of the default route to the hub firewall"
  value       = azurerm_route.route_to_firewall.id
}

output "default_route_name" {
  description = "The name of the default route to the hub firewall"
  value       = azurerm_route.route_to_firewall.name
}

output "subnet_route_table_association_ids" {
  description = "Map of subnet names to their route table association IDs"
  value = {
    "snet-pe-dmz-eus2-01"         = azurerm_subnet_route_table_association.pe_subnet.id
    "snet-tools-dmz-eus2-01"      = azurerm_subnet_route_table_association.tools_subnet.id
    "snet-ns-mgmt-dmz-eus2-01"    = azurerm_subnet_route_table_association.ns_mgmt_subnet.id
    "snet-ns-client-dmz-eus2-01"  = azurerm_subnet_route_table_association.ns_client_subnet.id
    "snet-ns-server-dmz-eus2-01"  = azurerm_subnet_route_table_association.ns_server_subnet.id
    "snet-ifw-mgmt-dmz-eus2-01"   = azurerm_subnet_route_table_association.ifw_mgmt_subnet.id
    "snet-ifw-untrust-dmz-eus2-01" = azurerm_subnet_route_table_association.ifw_untrust_subnet.id
    "snet-ifw-trust-dmz-eus2-01"  = azurerm_subnet_route_table_association.ifw_trust_subnet.id
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
