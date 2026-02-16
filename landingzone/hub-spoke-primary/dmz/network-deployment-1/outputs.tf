# =============================================================================
# Outputs for DMZ Network Deployment 1
# =============================================================================

# -----------------------------------------------------------------------------
# Resource Group Outputs
# -----------------------------------------------------------------------------
output "resource_group_name" {
  description = "Name of the DMZ network resource group"
  value       = azurerm_resource_group.dmz_network.name
}

output "resource_group_id" {
  description = "ID of the DMZ network resource group"
  value       = azurerm_resource_group.dmz_network.id
}

output "resource_group_location" {
  description = "Location of the DMZ network resource group"
  value       = azurerm_resource_group.dmz_network.location
}

output "network_watcher_resource_group_name" {
  description = "Name of the Network Watcher resource group"
  value       = azurerm_resource_group.network_watcher.name
}

output "network_watcher_resource_group_id" {
  description = "ID of the Network Watcher resource group"
  value       = azurerm_resource_group.network_watcher.id
}

# -----------------------------------------------------------------------------
# Virtual Network Outputs
# -----------------------------------------------------------------------------
output "vnet_id" {
  description = "ID of the DMZ virtual network"
  value       = azurerm_virtual_network.dmz.id
}

output "vnet_name" {
  description = "Name of the DMZ virtual network"
  value       = azurerm_virtual_network.dmz.name
}

output "vnet_address_space" {
  description = "Address space of the DMZ virtual network"
  value       = azurerm_virtual_network.dmz.address_space
}

output "vnet_guid" {
  description = "GUID of the DMZ virtual network"
  value       = azurerm_virtual_network.dmz.guid
}

# -----------------------------------------------------------------------------
# Subnet Outputs
# -----------------------------------------------------------------------------
output "subnet_pe_id" {
  description = "ID of the private endpoints subnet"
  value       = azurerm_subnet.pe.id
}

output "subnet_pe_name" {
  description = "Name of the private endpoints subnet"
  value       = azurerm_subnet.pe.name
}

output "subnet_pe_address_prefixes" {
  description = "Address prefixes of the private endpoints subnet"
  value       = azurerm_subnet.pe.address_prefixes
}

output "subnet_tools_id" {
  description = "ID of the tools subnet"
  value       = azurerm_subnet.tools.id
}

output "subnet_tools_name" {
  description = "Name of the tools subnet"
  value       = azurerm_subnet.tools.name
}

output "subnet_tools_address_prefixes" {
  description = "Address prefixes of the tools subnet"
  value       = azurerm_subnet.tools.address_prefixes
}

output "subnet_ns_mgmt_id" {
  description = "ID of the NetScaler management subnet"
  value       = azurerm_subnet.ns_mgmt.id
}

output "subnet_ns_mgmt_name" {
  description = "Name of the NetScaler management subnet"
  value       = azurerm_subnet.ns_mgmt.name
}

output "subnet_ns_mgmt_address_prefixes" {
  description = "Address prefixes of the NetScaler management subnet"
  value       = azurerm_subnet.ns_mgmt.address_prefixes
}

output "subnet_ns_client_id" {
  description = "ID of the NetScaler client subnet"
  value       = azurerm_subnet.ns_client.id
}

output "subnet_ns_client_name" {
  description = "Name of the NetScaler client subnet"
  value       = azurerm_subnet.ns_client.name
}

output "subnet_ns_client_address_prefixes" {
  description = "Address prefixes of the NetScaler client subnet"
  value       = azurerm_subnet.ns_client.address_prefixes
}

output "subnet_ns_server_id" {
  description = "ID of the NetScaler server subnet"
  value       = azurerm_subnet.ns_server.id
}

output "subnet_ns_server_name" {
  description = "Name of the NetScaler server subnet"
  value       = azurerm_subnet.ns_server.name
}

output "subnet_ns_server_address_prefixes" {
  description = "Address prefixes of the NetScaler server subnet"
  value       = azurerm_subnet.ns_server.address_prefixes
}

output "subnet_ifw_mgmt_id" {
  description = "ID of the ingress firewall management subnet"
  value       = azurerm_subnet.ifw_mgmt.id
}

output "subnet_ifw_mgmt_name" {
  description = "Name of the ingress firewall management subnet"
  value       = azurerm_subnet.ifw_mgmt.name
}

output "subnet_ifw_mgmt_address_prefixes" {
  description = "Address prefixes of the ingress firewall management subnet"
  value       = azurerm_subnet.ifw_mgmt.address_prefixes
}

output "subnet_ifw_untrust_id" {
  description = "ID of the ingress firewall untrust subnet"
  value       = azurerm_subnet.ifw_untrust.id
}

output "subnet_ifw_untrust_name" {
  description = "Name of the ingress firewall untrust subnet"
  value       = azurerm_subnet.ifw_untrust.name
}

output "subnet_ifw_untrust_address_prefixes" {
  description = "Address prefixes of the ingress firewall untrust subnet"
  value       = azurerm_subnet.ifw_untrust.address_prefixes
}

output "subnet_ifw_trust_id" {
  description = "ID of the ingress firewall trust subnet"
  value       = azurerm_subnet.ifw_trust.id
}

output "subnet_ifw_trust_name" {
  description = "Name of the ingress firewall trust subnet"
  value       = azurerm_subnet.ifw_trust.name
}

output "subnet_ifw_trust_address_prefixes" {
  description = "Address prefixes of the ingress firewall trust subnet"
  value       = azurerm_subnet.ifw_trust.address_prefixes
}

# Consolidated subnet outputs for easy reference
output "all_subnet_ids" {
  description = "Map of all subnet names to their IDs"
  value = {
    (azurerm_subnet.pe.name)          = azurerm_subnet.pe.id
    (azurerm_subnet.tools.name)       = azurerm_subnet.tools.id
    (azurerm_subnet.ns_mgmt.name)     = azurerm_subnet.ns_mgmt.id
    (azurerm_subnet.ns_client.name)   = azurerm_subnet.ns_client.id
    (azurerm_subnet.ns_server.name)   = azurerm_subnet.ns_server.id
    (azurerm_subnet.ifw_mgmt.name)    = azurerm_subnet.ifw_mgmt.id
    (azurerm_subnet.ifw_untrust.name) = azurerm_subnet.ifw_untrust.id
    (azurerm_subnet.ifw_trust.name)   = azurerm_subnet.ifw_trust.id
  }
}

# -----------------------------------------------------------------------------
# Network Watcher Outputs
# -----------------------------------------------------------------------------
output "network_watcher_id" {
  description = "ID of the Network Watcher"
  value       = azurerm_network_watcher.dmz.id
}

output "network_watcher_name" {
  description = "Name of the Network Watcher"
  value       = azurerm_network_watcher.dmz.name
}

# -----------------------------------------------------------------------------
# VNet Peering Outputs
# -----------------------------------------------------------------------------
output "peering_dmz_to_hub_id" {
  description = "ID of the DMZ to Hub VNet peering"
  value       = azurerm_virtual_network_peering.dmz_to_hub.id
}

output "peering_dmz_to_hub_name" {
  description = "Name of the DMZ to Hub VNet peering"
  value       = azurerm_virtual_network_peering.dmz_to_hub.name
}

output "peering_hub_to_dmz_id" {
  description = "ID of the Hub to DMZ VNet peering"
  value       = azurerm_virtual_network_peering.hub_to_dmz.id
}

output "peering_hub_to_dmz_name" {
  description = "Name of the Hub to DMZ VNet peering"
  value       = azurerm_virtual_network_peering.hub_to_dmz.name
}

# ============================================
# Standard Outputs (auto-generated for cross-deployment compatibility)
# These outputs are required by downstream deployments via terraform_remote_state
# ============================================

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.dmz_network.location
}
