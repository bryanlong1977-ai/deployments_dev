# =============================================================================
# Resource Group Outputs
# =============================================================================
output "resource_group_name" {
  description = "The name of the hub VNet resource group."
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "The ID of the hub VNet resource group."
  value       = azurerm_resource_group.this.id
}

output "resource_group_location" {
  description = "The location of the hub VNet resource group."
  value       = azurerm_resource_group.this.location
}

# =============================================================================
# Network Watcher Outputs
# =============================================================================
output "network_watcher_name" {
  description = "The name of the Network Watcher."
  value       = azurerm_network_watcher.this.name
}

output "network_watcher_id" {
  description = "The ID of the Network Watcher."
  value       = azurerm_network_watcher.this.id
}

output "network_watcher_resource_group_name" {
  description = "The name of the Network Watcher resource group."
  value       = azurerm_resource_group.network_watcher.name
}

output "network_watcher_resource_group_id" {
  description = "The ID of the Network Watcher resource group."
  value       = azurerm_resource_group.network_watcher.id
}

# =============================================================================
# Virtual Network Outputs
# =============================================================================
output "vnet_name" {
  description = "The name of the hub virtual network."
  value       = azurerm_virtual_network.this.name
}

output "vnet_id" {
  description = "The ID of the hub virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_address_space" {
  description = "The address space of the hub virtual network."
  value       = azurerm_virtual_network.this.address_space
}

# =============================================================================
# Subnet Outputs
# =============================================================================
output "subnet_ids" {
  description = "A map of subnet names to their IDs."
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "subnet_names" {
  description = "A map of subnet names to their names (for reference consistency)."
  value       = { for k, v in azurerm_subnet.subnets : k => v.name }
}

output "subnet_address_prefixes" {
  description = "A map of subnet names to their address prefixes."
  value       = { for k, v in azurerm_subnet.subnets : k => v.address_prefixes }
}

# ============================================
# Standard Outputs (auto-generated for cross-deployment compatibility)
# These outputs are required by downstream deployments via terraform_remote_state
# ============================================

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.network_watcher.location
}

output "hub_vnet_id" {
  description = "The ID of the hub Virtual Network (alias for vnet_id)"
  value       = azurerm_virtual_network.this.id
}

output "hub_vnet_name" {
  description = "The name of the hub Virtual Network (alias for vnet_name)"
  value       = azurerm_virtual_network.this.name
}

output "hub_resource_group_name" {
  description = "The name of the hub resource group (alias for resource_group_name)"
  value       = azurerm_resource_group.this.name
}
