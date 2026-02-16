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

output "nsg_inbound_id" {
  description = "The ID of the DNS Resolver Inbound NSG"
  value       = azurerm_network_security_group.nsg_inbound.id
}

output "nsg_inbound_name" {
  description = "The name of the DNS Resolver Inbound NSG"
  value       = azurerm_network_security_group.nsg_inbound.name
}

output "nsg_outbound_id" {
  description = "The ID of the DNS Resolver Outbound NSG"
  value       = azurerm_network_security_group.nsg_outbound.id
}

output "nsg_outbound_name" {
  description = "The name of the DNS Resolver Outbound NSG"
  value       = azurerm_network_security_group.nsg_outbound.name
}

output "nsg_dc_id" {
  description = "The ID of the Domain Controllers NSG"
  value       = azurerm_network_security_group.nsg_dc.id
}

output "nsg_dc_name" {
  description = "The name of the Domain Controllers NSG"
  value       = azurerm_network_security_group.nsg_dc.name
}

output "nsg_ib_mgmt_id" {
  description = "The ID of the Infoblox Management NSG"
  value       = azurerm_network_security_group.nsg_ib_mgmt.id
}

output "nsg_ib_mgmt_name" {
  description = "The name of the Infoblox Management NSG"
  value       = azurerm_network_security_group.nsg_ib_mgmt.name
}

output "nsg_ib_lan1_id" {
  description = "The ID of the Infoblox LAN1 NSG"
  value       = azurerm_network_security_group.nsg_ib_lan1.id
}

output "nsg_ib_lan1_name" {
  description = "The name of the Infoblox LAN1 NSG"
  value       = azurerm_network_security_group.nsg_ib_lan1.name
}

output "nsg_ids" {
  description = "Map of NSG names to their IDs"
  value = {
    (azurerm_network_security_group.nsg_pe.name)      = azurerm_network_security_group.nsg_pe.id
    (azurerm_network_security_group.nsg_tools.name)   = azurerm_network_security_group.nsg_tools.id
    (azurerm_network_security_group.nsg_inbound.name) = azurerm_network_security_group.nsg_inbound.id
    (azurerm_network_security_group.nsg_outbound.name) = azurerm_network_security_group.nsg_outbound.id
    (azurerm_network_security_group.nsg_dc.name)      = azurerm_network_security_group.nsg_dc.id
    (azurerm_network_security_group.nsg_ib_mgmt.name) = azurerm_network_security_group.nsg_ib_mgmt.id
    (azurerm_network_security_group.nsg_ib_lan1.name) = azurerm_network_security_group.nsg_ib_lan1.id
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
