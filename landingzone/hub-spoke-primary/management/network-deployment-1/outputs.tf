output "resource_group_name" {
  description = "The name of the management network resource group."
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "The ID of the management network resource group."
  value       = azurerm_resource_group.this.id
}

output "vnet_name" {
  description = "The name of the management virtual network."
  value       = azurerm_virtual_network.this.name
}

output "vnet_id" {
  description = "The ID of the management virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_address_space" {
  description = "The address space of the management virtual network."
  value       = azurerm_virtual_network.this.address_space
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs."
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "subnet_address_prefixes" {
  description = "Map of subnet names to their address prefixes."
  value       = { for k, v in azurerm_subnet.subnets : k => v.address_prefixes }
}

output "mgmt_to_hub_peering_id" {
  description = "The ID of the management-to-hub VNet peering."
  value       = azurerm_virtual_network_peering.mgmt_to_hub.id
}

output "hub_to_mgmt_peering_id" {
  description = "The ID of the hub-to-management VNet peering."
  value       = azurerm_virtual_network_peering.hub_to_mgmt.id
}

# ============================================
# Standard Outputs (auto-generated for cross-deployment compatibility)
# These outputs are required by downstream deployments via terraform_remote_state
# ============================================

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.this.location
}
