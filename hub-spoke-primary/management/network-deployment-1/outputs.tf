output "resource_group_name" {
  description = "Name of the network resource group"
  value       = azurerm_resource_group.network.name
}

output "resource_group_id" {
  description = "ID of the network resource group"
  value       = azurerm_resource_group.network.id
}

output "network_watcher_resource_group_name" {
  description = "Name of the Network Watcher resource group"
  value       = azurerm_resource_group.network_watcher.name
}

output "network_watcher_resource_group_id" {
  description = "ID of the Network Watcher resource group"
  value       = azurerm_resource_group.network_watcher.id
}

output "vnet_name" {
  description = "Name of the Management virtual network"
  value       = azurerm_virtual_network.mgmt.name
}

output "vnet_id" {
  description = "ID of the Management virtual network"
  value       = azurerm_virtual_network.mgmt.id
}

output "vnet_address_space" {
  description = "Address space of the Management VNet"
  value       = azurerm_virtual_network.mgmt.address_space
}

output "subnet_pe_name" {
  description = "Name of the private endpoints subnet"
  value       = azurerm_subnet.pe.name
}

output "subnet_pe_id" {
  description = "ID of the private endpoints subnet"
  value       = azurerm_subnet.pe.id
}

output "subnet_pe_address_prefixes" {
  description = "Address prefixes of the private endpoints subnet"
  value       = azurerm_subnet.pe.address_prefixes
}

output "subnet_tools_name" {
  description = "Name of the tools subnet"
  value       = azurerm_subnet.tools.name
}

output "subnet_tools_id" {
  description = "ID of the tools subnet"
  value       = azurerm_subnet.tools.id
}

output "subnet_tools_address_prefixes" {
  description = "Address prefixes of the tools subnet"
  value       = azurerm_subnet.tools.address_prefixes
}

output "network_watcher_name" {
  description = "Name of the Network Watcher"
  value       = azurerm_network_watcher.mgmt.name
}

output "network_watcher_id" {
  description = "ID of the Network Watcher"
  value       = azurerm_network_watcher.mgmt.id
}

output "peering_mgmt_to_hub_id" {
  description = "ID of the VNet peering from Management to Hub"
  value       = azurerm_virtual_network_peering.mgmt_to_hub.id
}

output "peering_hub_to_mgmt_id" {
  description = "ID of the VNet peering from Hub to Management"
  value       = azurerm_virtual_network_peering.hub_to_mgmt.id
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value = {
    (azurerm_subnet.pe.name)    = azurerm_subnet.pe.id
    (azurerm_subnet.tools.name) = azurerm_subnet.tools.id
  }
}

# ============================================
# Standard Outputs (auto-generated for cross-deployment compatibility)
# These outputs are required by downstream deployments via terraform_remote_state
# ============================================

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.network.location
}
