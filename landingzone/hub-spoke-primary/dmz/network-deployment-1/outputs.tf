output "vnet_id" {
  description = "The ID of the DMZ virtual network"
  value       = azurerm_virtual_network.dmz.id
}

output "vnet_name" {
  description = "The name of the DMZ virtual network"
  value       = azurerm_virtual_network.dmz.name
}

output "vnet_address_space" {
  description = "The address space of the DMZ virtual network"
  value       = azurerm_virtual_network.dmz.address_space
}

output "resource_group_name" {
  description = "The name of the DMZ network resource group"
  value       = azurerm_resource_group.dmz_network.name
}

output "resource_group_id" {
  description = "The ID of the DMZ network resource group"
  value       = azurerm_resource_group.dmz_network.id
}

output "resource_group_location" {
  description = "The location of the DMZ network resource group"
  value       = azurerm_resource_group.dmz_network.location
}

output "network_watcher_resource_group_name" {
  description = "The name of the Network Watcher resource group"
  value       = azurerm_resource_group.network_watcher.name
}

output "network_watcher_id" {
  description = "The ID of the Network Watcher"
  value       = azurerm_network_watcher.dmz.id
}

output "network_watcher_name" {
  description = "The name of the Network Watcher"
  value       = azurerm_network_watcher.dmz.name
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

output "subnet_ifw_mgmt_id" {
  description = "The ID of the ingress firewall management subnet"
  value       = azurerm_subnet.ifw_mgmt.id
}

output "subnet_ifw_mgmt_name" {
  description = "The name of the ingress firewall management subnet"
  value       = azurerm_subnet.ifw_mgmt.name
}

output "subnet_ifw_mgmt_address_prefixes" {
  description = "The address prefixes of the ingress firewall management subnet"
  value       = azurerm_subnet.ifw_mgmt.address_prefixes
}

output "subnet_ifw_untrust_id" {
  description = "The ID of the ingress firewall untrust subnet"
  value       = azurerm_subnet.ifw_untrust.id
}

output "subnet_ifw_untrust_name" {
  description = "The name of the ingress firewall untrust subnet"
  value       = azurerm_subnet.ifw_untrust.name
}

output "subnet_ifw_untrust_address_prefixes" {
  description = "The address prefixes of the ingress firewall untrust subnet"
  value       = azurerm_subnet.ifw_untrust.address_prefixes
}

output "subnet_ifw_trust_id" {
  description = "The ID of the ingress firewall trust subnet"
  value       = azurerm_subnet.ifw_trust.id
}

output "subnet_ifw_trust_name" {
  description = "The name of the ingress firewall trust subnet"
  value       = azurerm_subnet.ifw_trust.name
}

output "subnet_ifw_trust_address_prefixes" {
  description = "The address prefixes of the ingress firewall trust subnet"
  value       = azurerm_subnet.ifw_trust.address_prefixes
}

output "all_subnet_ids" {
  description = "Map of all subnet names to their IDs"
  value = {
    pe          = azurerm_subnet.pe.id
    tools       = azurerm_subnet.tools.id
    ifw_mgmt    = azurerm_subnet.ifw_mgmt.id
    ifw_untrust = azurerm_subnet.ifw_untrust.id
    ifw_trust   = azurerm_subnet.ifw_trust.id
  }
}

output "peering_dmz_to_hub_id" {
  description = "The ID of the DMZ to Hub VNet peering"
  value       = azurerm_virtual_network_peering.dmz_to_hub.id
}

output "peering_hub_to_dmz_id" {
  description = "The ID of the Hub to DMZ VNet peering"
  value       = azurerm_virtual_network_peering.hub_to_dmz.id
}

# ============================================
# Standard Outputs (auto-generated for cross-deployment compatibility)
# These outputs are required by downstream deployments via terraform_remote_state
# ============================================

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.dmz_network.location
}
