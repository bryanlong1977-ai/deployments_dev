#------------------------------------------------------------------------------
# Resource Group Outputs
#------------------------------------------------------------------------------

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

output "network_watcher_resource_group_id" {
  description = "ID of the network watcher resource group"
  value       = azurerm_resource_group.network_watcher.id
}

output "dns_resource_group_name" {
  description = "Name of the DNS resource group"
  value       = azurerm_resource_group.dns.name
}

output "dns_resource_group_id" {
  description = "ID of the DNS resource group"
  value       = azurerm_resource_group.dns.id
}

#------------------------------------------------------------------------------
# Virtual Network Outputs
#------------------------------------------------------------------------------

output "vnet_name" {
  description = "Name of the Identity virtual network"
  value       = azurerm_virtual_network.identity.name
}

output "vnet_id" {
  description = "ID of the Identity virtual network"
  value       = azurerm_virtual_network.identity.id
}

output "vnet_address_space" {
  description = "Address space of the Identity virtual network"
  value       = azurerm_virtual_network.identity.address_space
}

#------------------------------------------------------------------------------
# Subnet Outputs
#------------------------------------------------------------------------------

output "subnet_pe_id" {
  description = "ID of the private endpoints subnet"
  value       = azurerm_subnet.pe.id
}

output "subnet_pe_name" {
  description = "Name of the private endpoints subnet"
  value       = azurerm_subnet.pe.name
}

output "subnet_pe_address_prefix" {
  description = "Address prefix of the private endpoints subnet"
  value       = azurerm_subnet.pe.address_prefixes[0]
}

output "subnet_tools_id" {
  description = "ID of the tools subnet"
  value       = azurerm_subnet.tools.id
}

output "subnet_tools_name" {
  description = "Name of the tools subnet"
  value       = azurerm_subnet.tools.name
}

output "subnet_inbound_id" {
  description = "ID of the DNS resolver inbound subnet"
  value       = azurerm_subnet.inbound.id
}

output "subnet_inbound_name" {
  description = "Name of the DNS resolver inbound subnet"
  value       = azurerm_subnet.inbound.name
}

output "subnet_outbound_id" {
  description = "ID of the DNS resolver outbound subnet"
  value       = azurerm_subnet.outbound.id
}

output "subnet_outbound_name" {
  description = "Name of the DNS resolver outbound subnet"
  value       = azurerm_subnet.outbound.name
}

output "subnet_dc_id" {
  description = "ID of the domain controllers subnet"
  value       = azurerm_subnet.dc.id
}

output "subnet_dc_name" {
  description = "Name of the domain controllers subnet"
  value       = azurerm_subnet.dc.name
}

output "subnet_ib_mgmt_id" {
  description = "ID of the Infoblox management subnet"
  value       = azurerm_subnet.ib_mgmt.id
}

output "subnet_ib_mgmt_name" {
  description = "Name of the Infoblox management subnet"
  value       = azurerm_subnet.ib_mgmt.name
}

output "subnet_ib_lan1_id" {
  description = "ID of the Infoblox LAN1 subnet"
  value       = azurerm_subnet.ib_lan1.id
}

output "subnet_ib_lan1_name" {
  description = "Name of the Infoblox LAN1 subnet"
  value       = azurerm_subnet.ib_lan1.name
}

output "all_subnet_ids" {
  description = "Map of all subnet IDs by name"
  value = {
    (azurerm_subnet.pe.name)      = azurerm_subnet.pe.id
    (azurerm_subnet.tools.name)   = azurerm_subnet.tools.id
    (azurerm_subnet.inbound.name) = azurerm_subnet.inbound.id
    (azurerm_subnet.outbound.name) = azurerm_subnet.outbound.id
    (azurerm_subnet.dc.name)      = azurerm_subnet.dc.id
    (azurerm_subnet.ib_mgmt.name) = azurerm_subnet.ib_mgmt.id
    (azurerm_subnet.ib_lan1.name) = azurerm_subnet.ib_lan1.id
  }
}

#------------------------------------------------------------------------------
# Network Watcher Outputs
#------------------------------------------------------------------------------

output "network_watcher_name" {
  description = "Name of the network watcher"
  value       = azurerm_network_watcher.identity.name
}

output "network_watcher_id" {
  description = "ID of the network watcher"
  value       = azurerm_network_watcher.identity.id
}

#------------------------------------------------------------------------------
# Private DNS Resolver Outputs
#------------------------------------------------------------------------------

output "private_dns_resolver_name" {
  description = "Name of the Private DNS Resolver"
  value       = azurerm_private_dns_resolver.identity.name
}

output "private_dns_resolver_id" {
  description = "ID of the Private DNS Resolver"
  value       = azurerm_private_dns_resolver.identity.id
}

output "dns_resolver_inbound_endpoint_id" {
  description = "ID of the DNS resolver inbound endpoint"
  value       = azurerm_private_dns_resolver_inbound_endpoint.identity.id
}

output "dns_resolver_inbound_endpoint_ip" {
  description = "IP address of the DNS resolver inbound endpoint"
  value       = azurerm_private_dns_resolver_inbound_endpoint.identity.ip_configurations[0].private_ip_address
}

output "dns_resolver_outbound_endpoint_id" {
  description = "ID of the DNS resolver outbound endpoint"
  value       = azurerm_private_dns_resolver_outbound_endpoint.identity.id
}

#------------------------------------------------------------------------------
# Private DNS Zone Outputs
#------------------------------------------------------------------------------

output "private_dns_zone_ids" {
  description = "Map of private DNS zone names to their IDs"
  value       = { for k, v in azurerm_private_dns_zone.zones : k => v.id }
}

output "private_dns_zone_names" {
  description = "List of private DNS zone names"
  value       = [for zone in azurerm_private_dns_zone.zones : zone.name]
}

#------------------------------------------------------------------------------
# DNS Forwarding Ruleset Outputs
#------------------------------------------------------------------------------

output "dns_forwarding_ruleset_id" {
  description = "ID of the DNS forwarding ruleset"
  value       = var.dns_forwarding_enabled ? azurerm_private_dns_resolver_dns_forwarding_ruleset.identity[0].id : null
}

output "dns_forwarding_ruleset_name" {
  description = "Name of the DNS forwarding ruleset"
  value       = var.dns_forwarding_enabled ? azurerm_private_dns_resolver_dns_forwarding_ruleset.identity[0].name : null
}

#------------------------------------------------------------------------------
# VNet Peering Outputs
#------------------------------------------------------------------------------

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
