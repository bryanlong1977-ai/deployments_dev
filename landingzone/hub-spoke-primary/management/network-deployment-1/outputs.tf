output "mgmt_vnet_id" {
  description = "The ID of the Management virtual network"
  value       = azurerm_virtual_network.mgmt.id
}

output "mgmt_vnet_name" {
  description = "The name of the Management virtual network"
  value       = azurerm_virtual_network.mgmt.name
}

output "mgmt_vnet_address_space" {
  description = "The address space of the Management virtual network"
  value       = azurerm_virtual_network.mgmt.address_space
}

output "mgmt_resource_group_name" {
  description = "The name of the Management network resource group"
  value       = azurerm_resource_group.network.name
}

output "mgmt_resource_group_id" {
  description = "The ID of the Management network resource group"
  value       = azurerm_resource_group.network.id
}

output "mgmt_resource_group_location" {
  description = "The location of the Management network resource group"
  value       = azurerm_resource_group.network.location
}

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

output "network_watcher_id" {
  description = "The ID of the Network Watcher"
  value       = azurerm_network_watcher.mgmt.id
}

output "network_watcher_name" {
  description = "The name of the Network Watcher"
  value       = azurerm_network_watcher.mgmt.name
}

output "network_watcher_resource_group_name" {
  description = "The name of the Network Watcher resource group"
  value       = azurerm_resource_group.network_watcher.name
}

output "peering_mgmt_to_hub_id" {
  description = "The ID of the VNet peering from Management to Hub"
  value       = azurerm_virtual_network_peering.mgmt_to_hub.id
}

output "peering_hub_to_mgmt_id" {
  description = "The ID of the VNet peering from Hub to Management"
  value       = azurerm_virtual_network_peering.hub_to_mgmt.id
}

output "all_subnet_ids" {
  description = "Map of all subnet names to their IDs"
  value = {
    (azurerm_subnet.pe.name)    = azurerm_subnet.pe.id
    (azurerm_subnet.tools.name) = azurerm_subnet.tools.id
  }
}

# ============================================
# Standard Outputs (auto-generated for cross-deployment compatibility)
# These outputs are required by downstream deployments via terraform_remote_state
# ============================================

output "vnet_id" {
  description = "The ID of the deployed Virtual Network"
  value       = azurerm_virtual_network.mgmt.id
}

output "vnet_name" {
  description = "The name of the deployed Virtual Network"
  value       = azurerm_virtual_network.mgmt.name
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.network.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.network.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.network.location
}
