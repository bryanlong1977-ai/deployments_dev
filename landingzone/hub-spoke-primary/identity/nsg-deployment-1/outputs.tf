output "nsg_resource_group_name" {
  description = "The name of the resource group containing the NSGs"
  value       = azurerm_resource_group.nsg.name
}

output "nsg_resource_group_id" {
  description = "The ID of the resource group containing the NSGs"
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
  description = "Map of NSG names to their IDs"
  value = {
    "nsg-idm-pe-prd-eus2-01"      = azurerm_network_security_group.pe.id
    "nsg-idm-tools-prd-eus2-01"   = azurerm_network_security_group.tools.id
    "nsg-idm-inbound-prd-eus2-01" = azurerm_network_security_group.inbound.id
    "nsg-idm-outbound-prd-eus2-01" = azurerm_network_security_group.outbound.id
    "nsg-idm-dc-prd-eus2-01"      = azurerm_network_security_group.dc.id
    "nsg-idm-ib-mgmt-prd-eus2-01" = azurerm_network_security_group.ib_mgmt.id
    "nsg-idm-ib-lan1-prd-eus2-01" = azurerm_network_security_group.ib_lan1.id
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
