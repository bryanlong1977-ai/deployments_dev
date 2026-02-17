# =============================================================================
# Outputs for Management Network Deployment 1
# These outputs are used by downstream deployments via terraform_remote_state
# =============================================================================

# -----------------------------------------------------------------------------
# Resource Group Outputs
# -----------------------------------------------------------------------------
output "network_resource_group_name" {
  description = "Name of the network resource group"
  value       = azurerm_resource_group.network_rg.name
}

output "network_resource_group_id" {
  description = "ID of the network resource group"
  value       = azurerm_resource_group.network_rg.id
}

output "network_resource_group_location" {
  description = "Location of the network resource group"
  value       = azurerm_resource_group.network_rg.location
}

output "network_watcher_resource_group_name" {
  description = "Name of the Network Watcher resource group"
  value       = azurerm_resource_group.network_watcher_rg.name
}

output "network_watcher_resource_group_id" {
  description = "ID of the Network Watcher resource group"
  value       = azurerm_resource_group.network_watcher_rg.id
}

# -----------------------------------------------------------------------------
# Virtual Network Outputs
# -----------------------------------------------------------------------------
output "vnet_id" {
  description = "ID of the Management virtual network"
  value       = azurerm_virtual_network.mgmt_vnet.id
}

output "vnet_name" {
  description = "Name of the Management virtual network"
  value       = azurerm_virtual_network.mgmt_vnet.name
}

output "vnet_address_space" {
  description = "Address space of the Management virtual network"
  value       = azurerm_virtual_network.mgmt_vnet.address_space
}

output "vnet_location" {
  description = "Location of the Management virtual network"
  value       = azurerm_virtual_network.mgmt_vnet.location
}

output "vnet_guid" {
  description = "GUID of the Management virtual network"
  value       = azurerm_virtual_network.mgmt_vnet.guid
}

# -----------------------------------------------------------------------------
# Subnet Outputs
# -----------------------------------------------------------------------------
output "subnet_pe_id" {
  description = "ID of the private endpoint subnet"
  value       = azurerm_subnet.snet_pe.id
}

output "subnet_pe_name" {
  description = "Name of the private endpoint subnet"
  value       = azurerm_subnet.snet_pe.name
}

output "subnet_pe_address_prefixes" {
  description = "Address prefixes of the private endpoint subnet"
  value       = azurerm_subnet.snet_pe.address_prefixes
}

output "subnet_tools_id" {
  description = "ID of the tools subnet"
  value       = azurerm_subnet.snet_tools.id
}

output "subnet_tools_name" {
  description = "Name of the tools subnet"
  value       = azurerm_subnet.snet_tools.name
}

output "subnet_tools_address_prefixes" {
  description = "Address prefixes of the tools subnet"
  value       = azurerm_subnet.snet_tools.address_prefixes
}

# Combined subnet outputs for easy iteration
output "subnets" {
  description = "Map of all subnets with their IDs and names"
  value = {
    pe = {
      id               = azurerm_subnet.snet_pe.id
      name             = azurerm_subnet.snet_pe.name
      address_prefixes = azurerm_subnet.snet_pe.address_prefixes
    }
    tools = {
      id               = azurerm_subnet.snet_tools.id
      name             = azurerm_subnet.snet_tools.name
      address_prefixes = azurerm_subnet.snet_tools.address_prefixes
    }
  }
}

# -----------------------------------------------------------------------------
# Network Watcher Outputs
# -----------------------------------------------------------------------------
output "network_watcher_id" {
  description = "ID of the Network Watcher"
  value       = azurerm_network_watcher.mgmt_nw.id
}

output "network_watcher_name" {
  description = "Name of the Network Watcher"
  value       = azurerm_network_watcher.mgmt_nw.name
}

output "network_watcher_location" {
  description = "Location of the Network Watcher"
  value       = azurerm_network_watcher.mgmt_nw.location
}

# -----------------------------------------------------------------------------
# VNet Peering Outputs
# -----------------------------------------------------------------------------
output "peering_mgmt_to_hub_id" {
  description = "ID of the VNet peering from Management to Hub"
  value       = azurerm_virtual_network_peering.mgmt_to_hub.id
}

output "peering_mgmt_to_hub_name" {
  description = "Name of the VNet peering from Management to Hub"
  value       = azurerm_virtual_network_peering.mgmt_to_hub.name
}

# -----------------------------------------------------------------------------
# Subscription and Region Outputs
# -----------------------------------------------------------------------------
output "subscription_id" {
  description = "The subscription ID where resources are deployed"
  value       = var.subscription_id
}

output "region" {
  description = "The Azure region where resources are deployed"
  value       = var.region
}

# ============================================
# Standard Outputs (auto-generated for cross-deployment compatibility)
# These outputs are required by downstream deployments via terraform_remote_state
# ============================================

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.network_rg.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.network_rg.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = var.region
}
