# Outputs for NSG Deployment 1 - DMZ Subscription

# Resource Group
output "nsg_resource_group_name" {
  description = "The name of the resource group containing the NSGs"
  value       = azurerm_resource_group.nsg_rg.name
}

output "nsg_resource_group_id" {
  description = "The ID of the resource group containing the NSGs"
  value       = azurerm_resource_group.nsg_rg.id
}

# NSG IDs
output "nsg_pe_id" {
  description = "The ID of the NSG for private endpoints subnet"
  value       = azurerm_network_security_group.nsg_pe.id
}

output "nsg_tools_id" {
  description = "The ID of the NSG for tools subnet"
  value       = azurerm_network_security_group.nsg_tools.id
}

output "nsg_ns_mgmt_id" {
  description = "The ID of the NSG for NetScaler management subnet"
  value       = azurerm_network_security_group.nsg_ns_mgmt.id
}

output "nsg_ns_client_id" {
  description = "The ID of the NSG for NetScaler client subnet"
  value       = azurerm_network_security_group.nsg_ns_client.id
}

output "nsg_ns_server_id" {
  description = "The ID of the NSG for NetScaler server subnet"
  value       = azurerm_network_security_group.nsg_ns_server.id
}

output "nsg_ifw_mgmt_id" {
  description = "The ID of the NSG for ingress firewall management subnet"
  value       = azurerm_network_security_group.nsg_ifw_mgmt.id
}

output "nsg_ifw_untrust_id" {
  description = "The ID of the NSG for ingress firewall untrust subnet"
  value       = azurerm_network_security_group.nsg_ifw_untrust.id
}

output "nsg_ifw_trust_id" {
  description = "The ID of the NSG for ingress firewall trust subnet"
  value       = azurerm_network_security_group.nsg_ifw_trust.id
}

# NSG Names
output "nsg_pe_name" {
  description = "The name of the NSG for private endpoints subnet"
  value       = azurerm_network_security_group.nsg_pe.name
}

output "nsg_tools_name" {
  description = "The name of the NSG for tools subnet"
  value       = azurerm_network_security_group.nsg_tools.name
}

output "nsg_ns_mgmt_name" {
  description = "The name of the NSG for NetScaler management subnet"
  value       = azurerm_network_security_group.nsg_ns_mgmt.name
}

output "nsg_ns_client_name" {
  description = "The name of the NSG for NetScaler client subnet"
  value       = azurerm_network_security_group.nsg_ns_client.name
}

output "nsg_ns_server_name" {
  description = "The name of the NSG for NetScaler server subnet"
  value       = azurerm_network_security_group.nsg_ns_server.name
}

output "nsg_ifw_mgmt_name" {
  description = "The name of the NSG for ingress firewall management subnet"
  value       = azurerm_network_security_group.nsg_ifw_mgmt.name
}

output "nsg_ifw_untrust_name" {
  description = "The name of the NSG for ingress firewall untrust subnet"
  value       = azurerm_network_security_group.nsg_ifw_untrust.name
}

output "nsg_ifw_trust_name" {
  description = "The name of the NSG for ingress firewall trust subnet"
  value       = azurerm_network_security_group.nsg_ifw_trust.name
}

# NSG Associations Map
output "nsg_subnet_associations" {
  description = "Map of NSG to subnet associations"
  value = {
    pe          = azurerm_subnet_network_security_group_association.nsg_pe_association.id
    tools       = azurerm_subnet_network_security_group_association.nsg_tools_association.id
    ns_mgmt     = azurerm_subnet_network_security_group_association.nsg_ns_mgmt_association.id
    ns_client   = azurerm_subnet_network_security_group_association.nsg_ns_client_association.id
    ns_server   = azurerm_subnet_network_security_group_association.nsg_ns_server_association.id
    ifw_mgmt    = azurerm_subnet_network_security_group_association.nsg_ifw_mgmt_association.id
    ifw_untrust = azurerm_subnet_network_security_group_association.nsg_ifw_untrust_association.id
    ifw_trust   = azurerm_subnet_network_security_group_association.nsg_ifw_trust_association.id
  }
}

# All NSGs Map
output "all_nsgs" {
  description = "Map of all NSGs with their IDs and names"
  value = {
    pe = {
      id   = azurerm_network_security_group.nsg_pe.id
      name = azurerm_network_security_group.nsg_pe.name
    }
    tools = {
      id   = azurerm_network_security_group.nsg_tools.id
      name = azurerm_network_security_group.nsg_tools.name
    }
    ns_mgmt = {
      id   = azurerm_network_security_group.nsg_ns_mgmt.id
      name = azurerm_network_security_group.nsg_ns_mgmt.name
    }
    ns_client = {
      id   = azurerm_network_security_group.nsg_ns_client.id
      name = azurerm_network_security_group.nsg_ns_client.name
    }
    ns_server = {
      id   = azurerm_network_security_group.nsg_ns_server.id
      name = azurerm_network_security_group.nsg_ns_server.name
    }
    ifw_mgmt = {
      id   = azurerm_network_security_group.nsg_ifw_mgmt.id
      name = azurerm_network_security_group.nsg_ifw_mgmt.name
    }
    ifw_untrust = {
      id   = azurerm_network_security_group.nsg_ifw_untrust.id
      name = azurerm_network_security_group.nsg_ifw_untrust.name
    }
    ifw_trust = {
      id   = azurerm_network_security_group.nsg_ifw_trust.id
      name = azurerm_network_security_group.nsg_ifw_trust.name
    }
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
