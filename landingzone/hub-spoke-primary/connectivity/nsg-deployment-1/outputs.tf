output "nsg_resource_group_name" {
  description = "The name of the resource group containing the NSGs"
  value       = azurerm_resource_group.nsg_rg.name
}

output "nsg_resource_group_id" {
  description = "The ID of the resource group containing the NSGs"
  value       = azurerm_resource_group.nsg_rg.id
}

output "nsg_pe_id" {
  description = "The ID of the private endpoints NSG"
  value       = azurerm_network_security_group.nsg_pe.id
}

output "nsg_pe_name" {
  description = "The name of the private endpoints NSG"
  value       = azurerm_network_security_group.nsg_pe.name
}

output "nsg_tools_id" {
  description = "The ID of the tools NSG"
  value       = azurerm_network_security_group.nsg_tools.id
}

output "nsg_tools_name" {
  description = "The name of the tools NSG"
  value       = azurerm_network_security_group.nsg_tools.name
}

output "nsg_fw_mgmt_id" {
  description = "The ID of the firewall management NSG"
  value       = azurerm_network_security_group.nsg_fw_mgmt.id
}

output "nsg_fw_mgmt_name" {
  description = "The name of the firewall management NSG"
  value       = azurerm_network_security_group.nsg_fw_mgmt.name
}

output "nsg_fw_untrust_id" {
  description = "The ID of the firewall untrust NSG"
  value       = azurerm_network_security_group.nsg_fw_untrust.id
}

output "nsg_fw_untrust_name" {
  description = "The name of the firewall untrust NSG"
  value       = azurerm_network_security_group.nsg_fw_untrust.name
}

output "nsg_fw_trust_id" {
  description = "The ID of the firewall trust NSG"
  value       = azurerm_network_security_group.nsg_fw_trust.id
}

output "nsg_fw_trust_name" {
  description = "The name of the firewall trust NSG"
  value       = azurerm_network_security_group.nsg_fw_trust.name
}

output "nsg_ids" {
  description = "Map of NSG names to their IDs"
  value = {
    (azurerm_network_security_group.nsg_pe.name)        = azurerm_network_security_group.nsg_pe.id
    (azurerm_network_security_group.nsg_tools.name)     = azurerm_network_security_group.nsg_tools.id
    (azurerm_network_security_group.nsg_fw_mgmt.name)   = azurerm_network_security_group.nsg_fw_mgmt.id
    (azurerm_network_security_group.nsg_fw_untrust.name) = azurerm_network_security_group.nsg_fw_untrust.id
    (azurerm_network_security_group.nsg_fw_trust.name)  = azurerm_network_security_group.nsg_fw_trust.id
  }
}

output "nsg_subnet_associations" {
  description = "Map of subnet names to their associated NSG IDs"
  value = {
    (var.subnet_pe_name)        = azurerm_network_security_group.nsg_pe.id
    (var.subnet_tools_name)     = azurerm_network_security_group.nsg_tools.id
    (var.subnet_fw_mgmt_name)   = azurerm_network_security_group.nsg_fw_mgmt.id
    (var.subnet_fw_untrust_name) = azurerm_network_security_group.nsg_fw_untrust.id
    (var.subnet_fw_trust_name)  = azurerm_network_security_group.nsg_fw_trust.id
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
  value       = azurerm_resource_group.nsg_rg.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.nsg_rg.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.nsg_rg.location
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
  value       = azurerm_resource_group.nsg_rg.name
}
