# NAT Gateway Outputs
output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = azurerm_nat_gateway.hub_nat_gateway.id
}

output "nat_gateway_name" {
  description = "Name of the NAT Gateway"
  value       = azurerm_nat_gateway.hub_nat_gateway.name
}

output "nat_gateway_resource_group_name" {
  description = "Resource group name of the NAT Gateway"
  value       = azurerm_resource_group.nat_gateway_rg.name
}

output "nat_gateway_resource_id" {
  description = "Resource ID of the NAT Gateway"
  value       = azurerm_nat_gateway.hub_nat_gateway.resource_guid
}

# Public IP Prefix Outputs
output "public_ip_prefix_id" {
  description = "ID of the Public IP Prefix for NAT Gateway"
  value       = azurerm_public_ip_prefix.nat_gateway_pip_prefix.id
}

output "public_ip_prefix_name" {
  description = "Name of the Public IP Prefix for NAT Gateway"
  value       = azurerm_public_ip_prefix.nat_gateway_pip_prefix.name
}

output "public_ip_prefix_ip_prefix" {
  description = "IP prefix CIDR of the Public IP Prefix"
  value       = azurerm_public_ip_prefix.nat_gateway_pip_prefix.ip_prefix
}

# ExpressRoute Gateway Outputs
output "expressroute_gateway_id" {
  description = "ID of the ExpressRoute Gateway"
  value       = azurerm_virtual_network_gateway.expressroute_gateway.id
}

output "expressroute_gateway_name" {
  description = "Name of the ExpressRoute Gateway"
  value       = azurerm_virtual_network_gateway.expressroute_gateway.name
}

output "expressroute_gateway_public_ip_id" {
  description = "ID of the ExpressRoute Gateway Public IP"
  value       = azurerm_public_ip.expressroute_gateway_pip.id
}

output "expressroute_gateway_public_ip_address" {
  description = "Public IP address of the ExpressRoute Gateway"
  value       = azurerm_public_ip.expressroute_gateway_pip.ip_address
}

# External Load Balancer Outputs
output "external_lb_id" {
  description = "ID of the External Load Balancer"
  value       = azurerm_lb.external_lb.id
}

output "external_lb_name" {
  description = "Name of the External Load Balancer"
  value       = azurerm_lb.external_lb.name
}

output "external_lb_resource_group_name" {
  description = "Resource group name of the External Load Balancer"
  value       = azurerm_resource_group.external_lb_rg.name
}

output "external_lb_frontend_ip_configuration_id" {
  description = "ID of the External Load Balancer frontend IP configuration"
  value       = azurerm_lb.external_lb.frontend_ip_configuration[0].id
}

output "external_lb_backend_pool_id" {
  description = "ID of the External Load Balancer backend address pool"
  value       = azurerm_lb_backend_address_pool.external_lb_backend_pool.id
}

output "external_lb_public_ip_id" {
  description = "ID of the External Load Balancer Public IP"
  value       = azurerm_public_ip.external_lb_pip.id
}

output "external_lb_public_ip_address" {
  description = "Public IP address of the External Load Balancer"
  value       = azurerm_public_ip.external_lb_pip.ip_address
}

output "external_lb_pip_prefix_id" {
  description = "ID of the External Load Balancer Public IP Prefix"
  value       = azurerm_public_ip_prefix.external_lb_pip_prefix.id
}

output "external_lb_pip_prefix_ip_prefix" {
  description = "IP prefix CIDR of the External Load Balancer Public IP Prefix"
  value       = azurerm_public_ip_prefix.external_lb_pip_prefix.ip_prefix
}

# VNet Flow Log Outputs
output "vnet_flow_log_id" {
  description = "ID of the VNet Flow Log"
  value       = azurerm_network_watcher_flow_log.vnet_flow_log.id
}

output "vnet_flow_log_name" {
  description = "Name of the VNet Flow Log"
  value       = azurerm_network_watcher_flow_log.vnet_flow_log.name
}

# DNS Link Outputs
output "hub_dns_ruleset_link_id" {
  description = "ID of the DNS Forwarding Ruleset VNet Link for Hub"
  value       = azurerm_private_dns_resolver_virtual_network_link.hub_dns_link.id
}

output "hub_dns_zone_link_ids" {
  description = "Map of Private DNS Zone VNet Link IDs for Hub"
  value       = { for k, v in azurerm_private_dns_zone_virtual_network_link.hub_dns_zone_links : k => v.id }
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
  value       = azurerm_resource_group.nat_gateway_rg.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.nat_gateway_rg.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.nat_gateway_rg.location
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
  value       = azurerm_resource_group.nat_gateway_rg.name
}
