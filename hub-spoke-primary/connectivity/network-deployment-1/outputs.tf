# Resource Group Outputs
output "hub_network_resource_group_name" {
  description = "Name of the hub network resource group"
  value       = azurerm_resource_group.hub_network.name
}

output "hub_network_resource_group_id" {
  description = "ID of the hub network resource group"
  value       = azurerm_resource_group.hub_network.id
}

output "hub_network_resource_group_location" {
  description = "Location of the hub network resource group"
  value       = azurerm_resource_group.hub_network.location
}

output "network_watcher_resource_group_name" {
  description = "Name of the Network Watcher resource group"
  value       = azurerm_resource_group.network_watcher.name
}

output "network_watcher_resource_group_id" {
  description = "ID of the Network Watcher resource group"
  value       = azurerm_resource_group.network_watcher.id
}

# Virtual Network Outputs
output "hub_vnet_id" {
  description = "ID of the hub virtual network"
  value       = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  description = "Name of the hub virtual network"
  value       = azurerm_virtual_network.hub.name
}

output "hub_vnet_address_space" {
  description = "Address space of the hub virtual network"
  value       = azurerm_virtual_network.hub.address_space
}

output "hub_vnet_guid" {
  description = "GUID of the hub virtual network"
  value       = azurerm_virtual_network.hub.guid
}

# Subnet Outputs
output "subnet_pe_id" {
  description = "ID of the private endpoints subnet"
  value       = azurerm_subnet.pe.id
}

output "subnet_pe_name" {
  description = "Name of the private endpoints subnet"
  value       = azurerm_subnet.pe.name
}

output "subnet_pe_address_prefix" {
  description = "Address prefix of the private endpoints subnet"
  value       = azurerm_subnet.pe.address_prefixes[0]
}

output "subnet_tools_id" {
  description = "ID of the tools subnet"
  value       = azurerm_subnet.tools.id
}

output "subnet_tools_name" {
  description = "Name of the tools subnet"
  value       = azurerm_subnet.tools.name
}

output "subnet_tools_address_prefix" {
  description = "Address prefix of the tools subnet"
  value       = azurerm_subnet.tools.address_prefixes[0]
}

output "subnet_fw_mgmt_id" {
  description = "ID of the firewall management subnet"
  value       = azurerm_subnet.fw_mgmt.id
}

output "subnet_fw_mgmt_name" {
  description = "Name of the firewall management subnet"
  value       = azurerm_subnet.fw_mgmt.name
}

output "subnet_fw_mgmt_address_prefix" {
  description = "Address prefix of the firewall management subnet"
  value       = azurerm_subnet.fw_mgmt.address_prefixes[0]
}

output "subnet_fw_untrust_id" {
  description = "ID of the firewall untrust subnet"
  value       = azurerm_subnet.fw_untrust.id
}

output "subnet_fw_untrust_name" {
  description = "Name of the firewall untrust subnet"
  value       = azurerm_subnet.fw_untrust.name
}

output "subnet_fw_untrust_address_prefix" {
  description = "Address prefix of the firewall untrust subnet"
  value       = azurerm_subnet.fw_untrust.address_prefixes[0]
}

output "subnet_fw_trust_id" {
  description = "ID of the firewall trust subnet"
  value       = azurerm_subnet.fw_trust.id
}

output "subnet_fw_trust_name" {
  description = "Name of the firewall trust subnet"
  value       = azurerm_subnet.fw_trust.name
}

output "subnet_fw_trust_address_prefix" {
  description = "Address prefix of the firewall trust subnet"
  value       = azurerm_subnet.fw_trust.address_prefixes[0]
}

output "subnet_gateway_id" {
  description = "ID of the gateway subnet"
  value       = azurerm_subnet.gateway.id
}

output "subnet_gateway_name" {
  description = "Name of the gateway subnet"
  value       = azurerm_subnet.gateway.name
}

output "subnet_gateway_address_prefix" {
  description = "Address prefix of the gateway subnet"
  value       = azurerm_subnet.gateway.address_prefixes[0]
}

output "subnet_route_server_id" {
  description = "ID of the route server subnet"
  value       = azurerm_subnet.route_server.id
}

output "subnet_route_server_name" {
  description = "Name of the route server subnet"
  value       = azurerm_subnet.route_server.name
}

output "subnet_route_server_address_prefix" {
  description = "Address prefix of the route server subnet"
  value       = azurerm_subnet.route_server.address_prefixes[0]
}

# Network Watcher Outputs
output "network_watcher_id" {
  description = "ID of the Network Watcher"
  value       = azurerm_network_watcher.hub.id
}

output "network_watcher_name" {
  description = "Name of the Network Watcher"
  value       = azurerm_network_watcher.hub.name
}

# Map of all subnet IDs for easy reference
output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value = {
    pe           = azurerm_subnet.pe.id
    tools        = azurerm_subnet.tools.id
    fw_mgmt      = azurerm_subnet.fw_mgmt.id
    fw_untrust   = azurerm_subnet.fw_untrust.id
    fw_trust     = azurerm_subnet.fw_trust.id
    gateway      = azurerm_subnet.gateway.id
    route_server = azurerm_subnet.route_server.id
  }
}

# Map of all subnet names for easy reference
output "subnet_names" {
  description = "Map of subnet purposes to their names"
  value = {
    pe           = azurerm_subnet.pe.name
    tools        = azurerm_subnet.tools.name
    fw_mgmt      = azurerm_subnet.fw_mgmt.name
    fw_untrust   = azurerm_subnet.fw_untrust.name
    fw_trust     = azurerm_subnet.fw_trust.name
    gateway      = azurerm_subnet.gateway.name
    route_server = azurerm_subnet.route_server.name
  }
}

# ============================================
# Standard Outputs (auto-generated for cross-deployment compatibility)
# These outputs are required by downstream deployments via terraform_remote_state
# ============================================

output "vnet_id" {
  description = "The ID of the deployed Virtual Network"
  value       = azurerm_virtual_network.hub.id
}

output "vnet_name" {
  description = "The name of the deployed Virtual Network"
  value       = azurerm_virtual_network.hub.name
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.hub_network.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.hub_network.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.hub_network.location
}

output "hub_resource_group_name" {
  description = "The name of the hub resource group (alias for resource_group_name)"
  value       = azurerm_resource_group.hub_network.name
}
