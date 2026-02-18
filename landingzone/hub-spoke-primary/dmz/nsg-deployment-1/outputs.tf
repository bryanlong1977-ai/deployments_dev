output "nsg_resource_group_name" {
  description = "Name of the NSG resource group"
  value       = azurerm_resource_group.nsg_rg.name
}

output "nsg_resource_group_id" {
  description = "ID of the NSG resource group"
  value       = azurerm_resource_group.nsg_rg.id
}

output "nsg_pe_id" {
  description = "ID of the Private Endpoints NSG"
  value       = azurerm_network_security_group.nsg_pe.id
}

output "nsg_pe_name" {
  description = "Name of the Private Endpoints NSG"
  value       = azurerm_network_security_group.nsg_pe.name
}

output "nsg_tools_id" {
  description = "ID of the Tools NSG"
  value       = azurerm_network_security_group.nsg_tools.id
}

output "nsg_tools_name" {
  description = "Name of the Tools NSG"
  value       = azurerm_network_security_group.nsg_tools.name
}

output "nsg_ns_mgmt_id" {
  description = "ID of the NetScaler Management NSG"
  value       = azurerm_network_security_group.nsg_ns_mgmt.id
}

output "nsg_ns_mgmt_name" {
  description = "Name of the NetScaler Management NSG"
  value       = azurerm_network_security_group.nsg_ns_mgmt.name
}

output "nsg_ns_client_id" {
  description = "ID of the NetScaler Client NSG"
  value       = azurerm_network_security_group.nsg_ns_client.id
}

output "nsg_ns_client_name" {
  description = "Name of the NetScaler Client NSG"
  value       = azurerm_network_security_group.nsg_ns_client.name
}

output "nsg_ns_server_id" {
  description = "ID of the NetScaler Server NSG"
  value       = azurerm_network_security_group.nsg_ns_server.id
}

output "nsg_ns_server_name" {
  description = "Name of the NetScaler Server NSG"
  value       = azurerm_network_security_group.nsg_ns_server.name
}

output "nsg_ifw_mgmt_id" {
  description = "ID of the Ingress Firewall Management NSG"
  value       = azurerm_network_security_group.nsg_ifw_mgmt.id
}

output "nsg_ifw_mgmt_name" {
  description = "Name of the Ingress Firewall Management NSG"
  value       = azurerm_network_security_group.nsg_ifw_mgmt.name
}

output "nsg_ifw_untrust_id" {
  description = "ID of the Ingress Firewall Untrust NSG"
  value       = azurerm_network_security_group.nsg_ifw_untrust.id
}

output "nsg_ifw_untrust_name" {
  description = "Name of the Ingress Firewall Untrust NSG"
  value       = azurerm_network_security_group.nsg_ifw_untrust.name
}

output "nsg_ifw_trust_id" {
  description = "ID of the Ingress Firewall Trust NSG"
  value       = azurerm_network_security_group.nsg_ifw_trust.id
}

output "nsg_ifw_trust_name" {
  description = "Name of the Ingress Firewall Trust NSG"
  value       = azurerm_network_security_group.nsg_ifw_trust.name
}

output "nsg_ids" {
  description = "Map of NSG names to IDs"
  value = {
    (azurerm_network_security_group.nsg_pe.name)         = azurerm_network_security_group.nsg_pe.id
    (azurerm_network_security_group.nsg_tools.name)      = azurerm_network_security_group.nsg_tools.id
    (azurerm_network_security_group.nsg_ns_mgmt.name)    = azurerm_network_security_group.nsg_ns_mgmt.id
    (azurerm_network_security_group.nsg_ns_client.name)  = azurerm_network_security_group.nsg_ns_client.id
    (azurerm_network_security_group.nsg_ns_server.name)  = azurerm_network_security_group.nsg_ns_server.id
    (azurerm_network_security_group.nsg_ifw_mgmt.name)   = azurerm_network_security_group.nsg_ifw_mgmt.id
    (azurerm_network_security_group.nsg_ifw_untrust.name) = azurerm_network_security_group.nsg_ifw_untrust.id
    (azurerm_network_security_group.nsg_ifw_trust.name)  = azurerm_network_security_group.nsg_ifw_trust.id
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
