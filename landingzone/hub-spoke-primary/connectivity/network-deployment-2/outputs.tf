#------------------------------------------------------------------------------
# NAT Gateway Outputs
#------------------------------------------------------------------------------
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = azurerm_nat_gateway.hub.id
}

output "nat_gateway_name" {
  description = "The name of the NAT Gateway"
  value       = azurerm_nat_gateway.hub.name
}

output "nat_gateway_resource_group_name" {
  description = "The resource group name of the NAT Gateway"
  value       = azurerm_resource_group.natgw.name
}

#------------------------------------------------------------------------------
# Public IP Prefix Outputs
#------------------------------------------------------------------------------
output "public_ip_prefix_id" {
  description = "The ID of the Public IP Prefix"
  value       = azurerm_public_ip_prefix.natgw.id
}

output "public_ip_prefix_name" {
  description = "The name of the Public IP Prefix"
  value       = azurerm_public_ip_prefix.natgw.name
}

output "public_ip_prefix_ip_prefix" {
  description = "The IP prefix value of the Public IP Prefix"
  value       = azurerm_public_ip_prefix.natgw.ip_prefix
}

#------------------------------------------------------------------------------
# ExpressRoute Gateway Outputs
#------------------------------------------------------------------------------
output "expressroute_gateway_id" {
  description = "The ID of the ExpressRoute Gateway"
  value       = azurerm_virtual_network_gateway.expressroute.id
}

output "expressroute_gateway_name" {
  description = "The name of the ExpressRoute Gateway"
  value       = azurerm_virtual_network_gateway.expressroute.name
}

output "expressroute_gateway_resource_group_name" {
  description = "The resource group name of the ExpressRoute Gateway"
  value       = azurerm_resource_group.ergw.name
}

output "expressroute_gateway_public_ip_id" {
  description = "The ID of the ExpressRoute Gateway Public IP"
  value       = azurerm_public_ip.ergw.id
}

output "expressroute_gateway_public_ip_address" {
  description = "The IP address of the ExpressRoute Gateway Public IP"
  value       = azurerm_public_ip.ergw.ip_address
}

#------------------------------------------------------------------------------
# Flow Log Outputs
#------------------------------------------------------------------------------
output "hub_vnet_flow_log_id" {
  description = "The ID of the Hub VNet Flow Log"
  value       = azurerm_network_watcher_flow_log.hub_vnet.id
}

output "hub_vnet_flow_log_name" {
  description = "The name of the Hub VNet Flow Log"
  value       = azurerm_network_watcher_flow_log.hub_vnet.name
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
  value       = azurerm_resource_group.natgw.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.natgw.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.natgw.location
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
  value       = azurerm_resource_group.natgw.name
}
