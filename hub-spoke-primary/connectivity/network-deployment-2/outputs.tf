#----------------------------------------------------------
# NAT Gateway Outputs
#----------------------------------------------------------
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = azurerm_nat_gateway.natgw.id
}

output "nat_gateway_name" {
  description = "The name of the NAT Gateway"
  value       = azurerm_nat_gateway.natgw.name
}

output "nat_gateway_resource_group_name" {
  description = "The resource group name of the NAT Gateway"
  value       = azurerm_resource_group.natgw_rg.name
}

output "public_ip_prefix_id" {
  description = "The ID of the Public IP Prefix for NAT Gateway"
  value       = azurerm_public_ip_prefix.natgw_pip_prefix.id
}

output "public_ip_prefix_name" {
  description = "The name of the Public IP Prefix for NAT Gateway"
  value       = azurerm_public_ip_prefix.natgw_pip_prefix.name
}

output "public_ip_prefix_ip_prefix" {
  description = "The IP prefix of the Public IP Prefix"
  value       = azurerm_public_ip_prefix.natgw_pip_prefix.ip_prefix
}

#----------------------------------------------------------
# ExpressRoute Gateway Outputs
#----------------------------------------------------------
output "expressroute_gateway_id" {
  description = "The ID of the ExpressRoute Gateway"
  value       = azurerm_virtual_network_gateway.expressroute_gateway.id
}

output "expressroute_gateway_name" {
  description = "The name of the ExpressRoute Gateway"
  value       = azurerm_virtual_network_gateway.expressroute_gateway.name
}

output "expressroute_gateway_resource_group_name" {
  description = "The resource group name of the ExpressRoute Gateway"
  value       = azurerm_resource_group.ergw_rg.name
}

output "expressroute_gateway_pip_id" {
  description = "The ID of the ExpressRoute Gateway Public IP"
  value       = azurerm_public_ip.ergw_pip.id
}

output "expressroute_gateway_pip_address" {
  description = "The IP address of the ExpressRoute Gateway Public IP"
  value       = azurerm_public_ip.ergw_pip.ip_address
}

output "expressroute_gateway_bgp_settings" {
  description = "The BGP settings of the ExpressRoute Gateway"
  value       = azurerm_virtual_network_gateway.expressroute_gateway.bgp_settings
}

#----------------------------------------------------------
# External Load Balancer Outputs
#----------------------------------------------------------
output "external_lb_id" {
  description = "The ID of the External Load Balancer"
  value       = azurerm_lb.external_lb.id
}

output "external_lb_name" {
  description = "The name of the External Load Balancer"
  value       = azurerm_lb.external_lb.name
}

output "external_lb_resource_group_name" {
  description = "The resource group name of the External Load Balancer"
  value       = azurerm_resource_group.elb_rg.name
}

output "external_lb_frontend_ip_config_id" {
  description = "The ID of the External Load Balancer frontend IP configuration"
  value       = azurerm_lb.external_lb.frontend_ip_configuration[0].id
}

output "external_lb_backend_pool_id" {
  description = "The ID of the External Load Balancer backend address pool"
  value       = azurerm_lb_backend_address_pool.external_lb_backend.id
}

output "external_lb_probe_id" {
  description = "The ID of the External Load Balancer health probe"
  value       = azurerm_lb_probe.external_lb_probe.id
}

output "external_lb_pip_id" {
  description = "The ID of the External Load Balancer Public IP"
  value       = azurerm_public_ip.elb_pip.id
}

output "external_lb_pip_address" {
  description = "The IP address of the External Load Balancer Public IP"
  value       = azurerm_public_ip.elb_pip.ip_address
}

output "external_lb_pip_prefix_id" {
  description = "The ID of the External Load Balancer Public IP Prefix"
  value       = azurerm_public_ip_prefix.elb_pip_prefix.id
}

output "external_lb_pip_prefix_ip_prefix" {
  description = "The IP prefix of the External Load Balancer Public IP Prefix"
  value       = azurerm_public_ip_prefix.elb_pip_prefix.ip_prefix
}

#----------------------------------------------------------
# VNet Flow Log Outputs
#----------------------------------------------------------
output "vnet_flow_log_id" {
  description = "The ID of the VNet Flow Log"
  value       = azurerm_network_watcher_flow_log.vnet_flow_log.id
}

output "vnet_flow_log_name" {
  description = "The name of the VNet Flow Log"
  value       = azurerm_network_watcher_flow_log.vnet_flow_log.name
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
  value       = azurerm_resource_group.natgw_rg.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.natgw_rg.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.natgw_rg.location
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
  value       = azurerm_resource_group.natgw_rg.name
}
