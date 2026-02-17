#--------------------------------------------------------------
# Resource Group Outputs
#--------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the network resource group"
  value       = azurerm_resource_group.network.name
}

output "resource_group_id" {
  description = "ID of the network resource group"
  value       = azurerm_resource_group.network.id
}

output "network_watcher_resource_group_name" {
  description = "Name of the network watcher resource group"
  value       = azurerm_resource_group.network_watcher.name
}

output "dns_resource_group_name" {
  description = "Name of the DNS resource group"
  value       = azurerm_resource_group.dns.name
}

output "dns_resource_group_id" {
  description = "ID of the DNS resource group"
  value       = azurerm_resource_group.dns.id
}

#--------------------------------------------------------------
# Virtual Network Outputs
#--------------------------------------------------------------

output "vnet_id" {
  description = "ID of the Identity virtual network"
  value       = azurerm_virtual_network.identity.id
}

output "vnet_name" {
  description = "Name of the Identity virtual network"
  value       = azurerm_virtual_network.identity.name
}

output "vnet_address_space" {
  description = "Address space of the Identity virtual network"
  value       = azurerm_virtual_network.identity.address_space
}

#--------------------------------------------------------------
# Subnet Outputs
#--------------------------------------------------------------

output "subnet_private_endpoints_id" {
  description = "ID of the private endpoints subnet"
  value       = azurerm_subnet.private_endpoints.id
}

output "subnet_private_endpoints_name" {
  description = "Name of the private endpoints subnet"
  value       = azurerm_subnet.private_endpoints.name
}

output "subnet_tools_id" {
  description = "ID of the tools subnet"
  value       = azurerm_subnet.tools.id
}

output "subnet_tools_name" {
  description = "Name of the tools subnet"
  value       = azurerm_subnet.tools.name
}

output "subnet_dns_inbound_id" {
  description = "ID of the DNS resolver inbound subnet"
  value       = azurerm_subnet.dns_inbound.id
}

output "subnet_dns_inbound_name" {
  description = "Name of the DNS resolver inbound subnet"
  value       = azurerm_subnet.dns_inbound.name
}

output "subnet_dns_outbound_id" {
  description = "ID of the DNS resolver outbound subnet"
  value       = azurerm_subnet.dns_outbound.id
}

output "subnet_dns_outbound_name" {
  description = "Name of the DNS resolver outbound subnet"
  value       = azurerm_subnet.dns_outbound.name
}

output "subnet_domain_controllers_id" {
  description = "ID of the domain controllers subnet"
  value       = azurerm_subnet.domain_controllers.id
}

output "subnet_domain_controllers_name" {
  description = "Name of the domain controllers subnet"
  value       = azurerm_subnet.domain_controllers.name
}

output "subnet_infoblox_mgmt_id" {
  description = "ID of the Infoblox management subnet"
  value       = azurerm_subnet.infoblox_mgmt.id
}

output "subnet_infoblox_mgmt_name" {
  description = "Name of the Infoblox management subnet"
  value       = azurerm_subnet.infoblox_mgmt.name
}

output "subnet_infoblox_lan1_id" {
  description = "ID of the Infoblox LAN1 subnet"
  value       = azurerm_subnet.infoblox_lan1.id
}

output "subnet_infoblox_lan1_name" {
  description = "Name of the Infoblox LAN1 subnet"
  value       = azurerm_subnet.infoblox_lan1.name
}

output "all_subnet_ids" {
  description = "Map of all subnet IDs by name"
  value = {
    (azurerm_subnet.private_endpoints.name)   = azurerm_subnet.private_endpoints.id
    (azurerm_subnet.tools.name)               = azurerm_subnet.tools.id
    (azurerm_subnet.dns_inbound.name)         = azurerm_subnet.dns_inbound.id
    (azurerm_subnet.dns_outbound.name)        = azurerm_subnet.dns_outbound.id
    (azurerm_subnet.domain_controllers.name)  = azurerm_subnet.domain_controllers.id
    (azurerm_subnet.infoblox_mgmt.name)       = azurerm_subnet.infoblox_mgmt.id
    (azurerm_subnet.infoblox_lan1.name)       = azurerm_subnet.infoblox_lan1.id
  }
}

#--------------------------------------------------------------
# Network Watcher Outputs
#--------------------------------------------------------------

output "network_watcher_id" {
  description = "ID of the Network Watcher"
  value       = azurerm_network_watcher.identity.id
}

output "network_watcher_name" {
  description = "Name of the Network Watcher"
  value       = azurerm_network_watcher.identity.name
}

#--------------------------------------------------------------
# DNS Resolver Outputs
#--------------------------------------------------------------

output "dns_resolver_id" {
  description = "ID of the Private DNS Resolver"
  value       = azurerm_private_dns_resolver.identity.id
}

output "dns_resolver_name" {
  description = "Name of the Private DNS Resolver"
  value       = azurerm_private_dns_resolver.identity.name
}

output "dns_resolver_inbound_endpoint_id" {
  description = "ID of the DNS Resolver inbound endpoint"
  value       = azurerm_private_dns_resolver_inbound_endpoint.identity.id
}

output "dns_resolver_inbound_endpoint_ip" {
  description = "IP address of the DNS Resolver inbound endpoint"
  value       = azurerm_private_dns_resolver_inbound_endpoint.identity.ip_configurations[0].private_ip_address
}

output "dns_resolver_outbound_endpoint_id" {
  description = "ID of the DNS Resolver outbound endpoint"
  value       = azurerm_private_dns_resolver_outbound_endpoint.identity.id
}

#--------------------------------------------------------------
# Private DNS Zone Outputs
#--------------------------------------------------------------

output "private_dns_zone_ids" {
  description = "Map of Private DNS zone names to their IDs"
  value       = { for k, v in azurerm_private_dns_zone.zones : k => v.id }
}

output "private_dns_zone_names" {
  description = "List of Private DNS zone names"
  value       = [for k, v in azurerm_private_dns_zone.zones : v.name]
}

#--------------------------------------------------------------
# DNS Forwarding Ruleset Outputs
#--------------------------------------------------------------

output "dns_forwarding_ruleset_id" {
  description = "ID of the DNS Forwarding Ruleset"
  value       = var.dns_forwarding_enabled ? azurerm_private_dns_resolver_dns_forwarding_ruleset.identity[0].id : null
}

output "dns_forwarding_ruleset_name" {
  description = "Name of the DNS Forwarding Ruleset"
  value       = var.dns_forwarding_enabled ? azurerm_private_dns_resolver_dns_forwarding_ruleset.identity[0].name : null
}

#--------------------------------------------------------------
# VNet Peering Outputs
#--------------------------------------------------------------

output "peering_identity_to_hub_id" {
  description = "ID of the Identity to Hub VNet peering"
  value       = azurerm_virtual_network_peering.identity_to_hub.id
}

output "peering_hub_to_identity_id" {
  description = "ID of the Hub to Identity VNet peering"
  value       = azurerm_virtual_network_peering.hub_to_identity.id
}

# ============================================
# Standard Outputs (auto-generated for cross-deployment compatibility)
# These outputs are required by downstream deployments via terraform_remote_state
# ============================================

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.network.location
}
