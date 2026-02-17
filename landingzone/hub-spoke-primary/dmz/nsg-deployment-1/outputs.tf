# ==========================================
# Resource Group Outputs
# ==========================================

output "nsg_resource_group_name" {
  description = "The name of the NSG resource group"
  value       = azurerm_resource_group.nsg_rg.name
}

output "nsg_resource_group_id" {
  description = "The ID of the NSG resource group"
  value       = azurerm_resource_group.nsg_rg.id
}

output "nsg_resource_group_location" {
  description = "The location of the NSG resource group"
  value       = azurerm_resource_group.nsg_rg.location
}

# ==========================================
# NSG Outputs - Private Endpoints
# ==========================================

output "nsg_pe_id" {
  description = "The ID of the Private Endpoints NSG"
  value       = azurerm_network_security_group.nsg_pe.id
}

output "nsg_pe_name" {
  description = "The name of the Private Endpoints NSG"
  value       = azurerm_network_security_group.nsg_pe.name
}

# ==========================================
# NSG Outputs - Tools
# ==========================================

output "nsg_tools_id" {
  description = "The ID of the Tools NSG"
  value       = azurerm_network_security_group.nsg_tools.id
}

output "nsg_tools_name" {
  description = "The name of the Tools NSG"
  value       = azurerm_network_security_group.nsg_tools.name
}

# ==========================================
# NSG Outputs - Ingress Firewall Management
# ==========================================

output "nsg_ifw_mgmt_id" {
  description = "The ID of the Ingress Firewall Management NSG"
  value       = azurerm_network_security_group.nsg_ifw_mgmt.id
}

output "nsg_ifw_mgmt_name" {
  description = "The name of the Ingress Firewall Management NSG"
  value       = azurerm_network_security_group.nsg_ifw_mgmt.name
}

# ==========================================
# NSG Outputs - Ingress Firewall Untrust
# ==========================================

output "nsg_ifw_untrust_id" {
  description = "The ID of the Ingress Firewall Untrust NSG"
  value       = azurerm_network_security_group.nsg_ifw_untrust.id
}

output "nsg_ifw_untrust_name" {
  description = "The name of the Ingress Firewall Untrust NSG"
  value       = azurerm_network_security_group.nsg_ifw_untrust.name
}

# ==========================================
# NSG Outputs - Ingress Firewall Trust
# ==========================================

output "nsg_ifw_trust_id" {
  description = "The ID of the Ingress Firewall Trust NSG"
  value       = azurerm_network_security_group.nsg_ifw_trust.id
}

output "nsg_ifw_trust_name" {
  description = "The name of the Ingress Firewall Trust NSG"
  value       = azurerm_network_security_group.nsg_ifw_trust.name
}

# ==========================================
# NSG Map Output (for convenience)
# ==========================================

output "nsgs" {
  description = "Map of all NSGs created in this deployment"
  value = {
    pe = {
      id   = azurerm_network_security_group.nsg_pe.id
      name = azurerm_network_security_group.nsg_pe.name
    }
    tools = {
      id   = azurerm_network_security_group.nsg_tools.id
      name = azurerm_network_security_group.nsg_tools.name
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
