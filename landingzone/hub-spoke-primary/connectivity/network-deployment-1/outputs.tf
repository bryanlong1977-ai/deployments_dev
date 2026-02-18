# Resource Group Outputs
output "resource_group_name" {
  description = "The name of the hub network resource group"
  value       = azurerm_resource_group.hub_network.name
}

output "resource_group_id" {
  description = "The ID of the hub network resource group"
  value       = azurerm_resource_group.hub_network.id
}

output "resource_group_location" {
  description = "The location of the hub network resource group"
  value       = azurerm_resource_group.hub_network.location
}

# Network Watcher Resource Group Outputs
output "network_watcher_resource_group_name" {
  description = "The name of the Network Watcher resource group"
  value       = azurerm_resource_group.network_watcher.name
}

output "network_watcher_resource_group_id" {
  description = "The ID of the Network Watcher resource group"
  value       = azurerm_resource_group.network_watcher.id
}

# Virtual Network Outputs
output "hub_vnet_id" {
  description = "The ID of the hub virtual network"
  value       = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  description = "The name of the hub virtual network"
  value       = azurerm_virtual_network.hub.name
}

output "hub_vnet_address_space" {
  description = "The address space of the hub virtual network"
  value       = azurerm_virtual_network.hub.address_space
}

output "hub_vnet_guid" {
  description = "The GUID of the hub virtual network"
  value       = azurerm_virtual_network.hub.guid
}

# Subnet Outputs - Private Endpoints
output "subnet_pe_id" {
  description = "The ID of the private endpoints subnet"
  value       = azurerm_subnet.pe.id
}

output "subnet_pe_name" {
  description = "The name of the private endpoints subnet"
  value       = azurerm_subnet.pe.name
}

output "subnet_pe_address_prefixes" {
  description = "The address prefixes of the private endpoints subnet"
  value       = azurerm_subnet.pe.address_prefixes
}

# Subnet Outputs - Tools
output "subnet_tools_id" {
  description = "The ID of the tools subnet"
  value       = azurerm_subnet.tools.id
}

output "subnet_tools_name" {
  description = "The name of the tools subnet"
  value       = azurerm_subnet.tools.name
}

output "subnet_tools_address_prefixes" {
  description = "The address prefixes of the tools subnet"
  value       = azurerm_subnet.tools.address_prefixes
}

# Subnet Outputs - Firewall Management
output "subnet_fw_mgmt_id" {
  description = "The ID of the firewall management subnet"
  value       = azurerm_subnet.fw_mgmt.id
}

output "subnet_fw_mgmt_name" {
  description = "The name of the firewall management subnet"
  value       = azurerm_subnet.fw_mgmt.name
}

output "subnet_fw_mgmt_address_prefixes" {
  description = "The address prefixes of the firewall management subnet"
  value       = azurerm_subnet.fw_mgmt.address_prefixes
}

# Subnet Outputs - Firewall Untrust
output "subnet_fw_untrust_id" {
  description = "The ID of the firewall untrust subnet"
  value       = azurerm_subnet.fw_untrust.id
}

output "subnet_fw_untrust_name" {
  description = "The name of the firewall untrust subnet"
  value       = azurerm_subnet.fw_untrust.name
}

output "subnet_fw_untrust_address_prefixes" {
  description = "The address prefixes of the firewall untrust subnet"
  value       = azurerm_subnet.fw_untrust.address_prefixes
}

# Subnet Outputs - Firewall Trust
output "subnet_fw_trust_id" {
  description = "The ID of the firewall trust subnet"
  value       = azurerm_subnet.fw_trust.id
}

output "subnet_fw_trust_name" {
  description = "The name of the firewall trust subnet"
  value       = azurerm_subnet.fw_trust.name
}

output "subnet_fw_trust_address_prefixes" {
  description = "The address prefixes of the firewall trust subnet"
  value       = azurerm_subnet.fw_trust.address_prefixes
}

# Subnet Outputs - Gateway
output "subnet_gateway_id" {
  description = "The ID of the gateway subnet"
  value       = azurerm_subnet.gateway.id
}

output "subnet_gateway_name" {
  description = "The name of the gateway subnet"
  value       = azurerm_subnet.gateway.name
}

output "subnet_gateway_address_prefixes" {
  description = "The address prefixes of the gateway subnet"
  value       = azurerm_subnet.gateway.address_prefixes
}

# Subnet Outputs - Route Server
output "subnet_route_server_id" {
  description = "The ID of the route server subnet"
  value       = azurerm_subnet.route_server.id
}

output "subnet_route_server_name" {
  description = "The name of the route server subnet"
  value       = azurerm_subnet.route_server.name
}

output "subnet_route_server_address_prefixes" {
  description = "The address prefixes of the route server subnet"
  value       = azurerm_subnet.route_server.address_prefixes
}

# Network Watcher Outputs
output "network_watcher_id" {
  description = "The ID of the network watcher"
  value       = azurerm_network_watcher.hub.id
}

output "network_watcher_name" {
  description = "The name of the network watcher"
  value       = azurerm_network_watcher.hub.name
}

# Consolidated subnet map for downstream deployments
output "subnets" {
  description = "Map of all subnet names to their IDs for downstream reference"
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

output "subnet_names" {
  description = "Map of subnet purposes to their actual names"
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

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.hub_network.location
}

output "hub_resource_group_name" {
  description = "The name of the hub resource group (alias for resource_group_name)"
  value       = azurerm_resource_group.hub_network.name
}
