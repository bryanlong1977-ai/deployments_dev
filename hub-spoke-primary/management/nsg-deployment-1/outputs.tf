# Outputs for NSG Deployment 1 - Management Subscription

# Resource Group Outputs
output "nsg_resource_group_name" {
  description = "Name of the NSG resource group"
  value       = azurerm_resource_group.nsg_rg.name
}

output "nsg_resource_group_id" {
  description = "ID of the NSG resource group"
  value       = azurerm_resource_group.nsg_rg.id
}

output "nsg_resource_group_location" {
  description = "Location of the NSG resource group"
  value       = azurerm_resource_group.nsg_rg.location
}

# NSG Outputs - Private Endpoint
output "nsg_pe_id" {
  description = "ID of the Private Endpoint NSG"
  value       = azurerm_network_security_group.nsg_pe.id
}

output "nsg_pe_name" {
  description = "Name of the Private Endpoint NSG"
  value       = azurerm_network_security_group.nsg_pe.name
}

# NSG Outputs - Tools
output "nsg_tools_id" {
  description = "ID of the Tools NSG"
  value       = azurerm_network_security_group.nsg_tools.id
}

output "nsg_tools_name" {
  description = "Name of the Tools NSG"
  value       = azurerm_network_security_group.nsg_tools.name
}

# NSG Map Output for downstream deployments
output "nsgs" {
  description = "Map of all NSGs created in this deployment"
  value = {
    pe = {
      id          = azurerm_network_security_group.nsg_pe.id
      name        = azurerm_network_security_group.nsg_pe.name
      subnet_name = var.subnet_pe_name
    }
    tools = {
      id          = azurerm_network_security_group.nsg_tools.id
      name        = azurerm_network_security_group.nsg_tools.name
      subnet_name = var.subnet_tools_name
    }
  }
}

# Subnet Association Outputs
output "subnet_nsg_associations" {
  description = "Map of subnet to NSG associations"
  value = {
    pe    = azurerm_subnet_network_security_group_association.pe_subnet_nsg.id
    tools = azurerm_subnet_network_security_group_association.tools_subnet_nsg.id
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
