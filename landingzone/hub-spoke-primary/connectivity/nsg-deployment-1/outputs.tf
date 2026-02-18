output "nsg_resource_group_name" {
  description = "The name of the resource group containing the NSGs"
  value       = azurerm_resource_group.nsg.name
}

output "nsg_resource_group_id" {
  description = "The ID of the resource group containing the NSGs"
  value       = azurerm_resource_group.nsg.id
}

output "nsg_pe_id" {
  description = "The ID of the NSG for the private endpoints subnet"
  value       = azurerm_network_security_group.pe.id
}

output "nsg_pe_name" {
  description = "The name of the NSG for the private endpoints subnet"
  value       = azurerm_network_security_group.pe.name
}

output "nsg_tools_id" {
  description = "The ID of the NSG for the tools subnet"
  value       = azurerm_network_security_group.tools.id
}

output "nsg_tools_name" {
  description = "The name of the NSG for the tools subnet"
  value       = azurerm_network_security_group.tools.name
}

output "nsg_fw_mgmt_id" {
  description = "The ID of the NSG for the firewall management subnet"
  value       = azurerm_network_security_group.fw_mgmt.id
}

output "nsg_fw_mgmt_name" {
  description = "The name of the NSG for the firewall management subnet"
  value       = azurerm_network_security_group.fw_mgmt.name
}

output "nsg_fw_untrust_id" {
  description = "The ID of the NSG for the firewall untrust subnet"
  value       = azurerm_network_security_group.fw_untrust.id
}

output "nsg_fw_untrust_name" {
  description = "The name of the NSG for the firewall untrust subnet"
  value       = azurerm_network_security_group.fw_untrust.name
}

output "nsg_fw_trust_id" {
  description = "The ID of the NSG for the firewall trust subnet"
  value       = azurerm_network_security_group.fw_trust.id
}

output "nsg_fw_trust_name" {
  description = "The name of the NSG for the firewall trust subnet"
  value       = azurerm_network_security_group.fw_trust.name
}

output "nsg_ids" {
  description = "Map of NSG names to their IDs"
  value = {
    (azurerm_network_security_group.pe.name)        = azurerm_network_security_group.pe.id
    (azurerm_network_security_group.tools.name)     = azurerm_network_security_group.tools.id
    (azurerm_network_security_group.fw_mgmt.name)   = azurerm_network_security_group.fw_mgmt.id
    (azurerm_network_security_group.fw_untrust.name) = azurerm_network_security_group.fw_untrust.id
    (azurerm_network_security_group.fw_trust.name)  = azurerm_network_security_group.fw_trust.id
  }
}

output "subnet_nsg_associations" {
  description = "Map of subnet names to their associated NSG IDs"
  value = {
    (var.subnet_pe_name)        = azurerm_network_security_group.pe.id
    (var.subnet_tools_name)     = azurerm_network_security_group.tools.id
    (var.subnet_fw_mgmt_name)   = azurerm_network_security_group.fw_mgmt.id
    (var.subnet_fw_untrust_name) = azurerm_network_security_group.fw_untrust.id
    (var.subnet_fw_trust_name)  = azurerm_network_security_group.fw_trust.id
  }
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
  value       = azurerm_resource_group.nsg.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.nsg.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.nsg.location
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
  value       = azurerm_resource_group.nsg.name
}
