output "nsg_resource_group_name" {
  description = "The name of the NSG resource group"
  value       = azurerm_resource_group.nsg.name
}

output "nsg_resource_group_id" {
  description = "The ID of the NSG resource group"
  value       = azurerm_resource_group.nsg.id
}

output "nsg_pe_id" {
  description = "The ID of the NSG for private endpoints subnet"
  value       = azurerm_network_security_group.pe.id
}

output "nsg_pe_name" {
  description = "The name of the NSG for private endpoints subnet"
  value       = azurerm_network_security_group.pe.name
}

output "nsg_tools_id" {
  description = "The ID of the NSG for tools subnet"
  value       = azurerm_network_security_group.tools.id
}

output "nsg_tools_name" {
  description = "The name of the NSG for tools subnet"
  value       = azurerm_network_security_group.tools.name
}

output "nsg_inbound_id" {
  description = "The ID of the NSG for DNS resolver inbound subnet"
  value       = azurerm_network_security_group.inbound.id
}

output "nsg_inbound_name" {
  description = "The name of the NSG for DNS resolver inbound subnet"
  value       = azurerm_network_security_group.inbound.name
}

output "nsg_outbound_id" {
  description = "The ID of the NSG for DNS resolver outbound subnet"
  value       = azurerm_network_security_group.outbound.id
}

output "nsg_outbound_name" {
  description = "The name of the NSG for DNS resolver outbound subnet"
  value       = azurerm_network_security_group.outbound.name
}

output "nsg_dc_id" {
  description = "The ID of the NSG for domain controllers subnet"
  value       = azurerm_network_security_group.dc.id
}

output "nsg_dc_name" {
  description = "The name of the NSG for domain controllers subnet"
  value       = azurerm_network_security_group.dc.name
}

output "nsg_ib_mgmt_id" {
  description = "The ID of the NSG for Infoblox management subnet"
  value       = azurerm_network_security_group.ib_mgmt.id
}

output "nsg_ib_mgmt_name" {
  description = "The name of the NSG for Infoblox management subnet"
  value       = azurerm_network_security_group.ib_mgmt.name
}

output "nsg_ib_lan1_id" {
  description = "The ID of the NSG for Infoblox LAN1 subnet"
  value       = azurerm_network_security_group.ib_lan1.id
}

output "nsg_ib_lan1_name" {
  description = "The name of the NSG for Infoblox LAN1 subnet"
  value       = azurerm_network_security_group.ib_lan1.name
}

output "nsg_ids" {
  description = "Map of NSG names to IDs"
  value = {
    (azurerm_network_security_group.pe.name)      = azurerm_network_security_group.pe.id
    (azurerm_network_security_group.tools.name)   = azurerm_network_security_group.tools.id
    (azurerm_network_security_group.inbound.name) = azurerm_network_security_group.inbound.id
    (azurerm_network_security_group.outbound.name) = azurerm_network_security_group.outbound.id
    (azurerm_network_security_group.dc.name)      = azurerm_network_security_group.dc.id
    (azurerm_network_security_group.ib_mgmt.name) = azurerm_network_security_group.ib_mgmt.id
    (azurerm_network_security_group.ib_lan1.name) = azurerm_network_security_group.ib_lan1.id
  }
}

output "subnet_nsg_associations" {
  description = "Map of subnet names to their associated NSG IDs"
  value = {
    (var.subnet_pe_name)      = azurerm_network_security_group.pe.id
    (var.subnet_tools_name)   = azurerm_network_security_group.tools.id
    (var.subnet_inbound_name) = azurerm_network_security_group.inbound.id
    (var.subnet_outbound_name) = azurerm_network_security_group.outbound.id
    (var.subnet_dc_name)      = azurerm_network_security_group.dc.id
    (var.subnet_ib_mgmt_name) = azurerm_network_security_group.ib_mgmt.id
    (var.subnet_ib_lan1_name) = azurerm_network_security_group.ib_lan1.id
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
