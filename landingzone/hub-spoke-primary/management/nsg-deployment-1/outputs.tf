output "nsg_resource_group_name" {
  description = "The name of the NSG resource group"
  value       = azurerm_resource_group.nsg_rg.name
}

output "nsg_resource_group_id" {
  description = "The ID of the NSG resource group"
  value       = azurerm_resource_group.nsg_rg.id
}

output "nsg_pe_id" {
  description = "The ID of the Private Endpoints NSG"
  value       = azurerm_network_security_group.nsg_pe.id
}

output "nsg_pe_name" {
  description = "The name of the Private Endpoints NSG"
  value       = azurerm_network_security_group.nsg_pe.name
}

output "nsg_tools_id" {
  description = "The ID of the Tools NSG"
  value       = azurerm_network_security_group.nsg_tools.id
}

output "nsg_tools_name" {
  description = "The name of the Tools NSG"
  value       = azurerm_network_security_group.nsg_tools.name
}

output "nsg_ids" {
  description = "Map of NSG names to IDs"
  value = {
    (azurerm_network_security_group.nsg_pe.name)    = azurerm_network_security_group.nsg_pe.id
    (azurerm_network_security_group.nsg_tools.name) = azurerm_network_security_group.nsg_tools.id
  }
}

output "nsg_subnet_associations" {
  description = "Map of subnet names to associated NSG IDs"
  value = {
    (var.subnet_pe_name)    = azurerm_network_security_group.nsg_pe.id
    (var.subnet_tools_name) = azurerm_network_security_group.nsg_tools.id
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
