# =============================================================================
# Resource Group Outputs
# =============================================================================
output "resource_group_name" {
  description = "Name of the Identity network resource group."
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "ID of the Identity network resource group."
  value       = azurerm_resource_group.this.id
}

output "dns_resource_group_name" {
  description = "Name of the DNS resource group."
  value       = azurerm_resource_group.dns.name
}

output "dns_resource_group_id" {
  description = "ID of the DNS resource group."
  value       = azurerm_resource_group.dns.id
}

# =============================================================================
# Virtual Network Outputs
# =============================================================================
output "vnet_name" {
  description = "Name of the Identity virtual network."
  value       = azurerm_virtual_network.this.name
}

output "vnet_id" {
  description = "ID of the Identity virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_address_space" {
  description = "Address space of the Identity virtual network."
  value       = azurerm_virtual_network.this.address_space
}

# =============================================================================
# Subnet Outputs
# =============================================================================
output "subnet_ids" {
  description = "Map of subnet names to their IDs."
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "subnet_address_prefixes" {
  description = "Map of subnet names to their address prefixes."
  value       = { for k, v in azurerm_subnet.subnets : k => v.address_prefixes }
}

# =============================================================================
# VNet Peering Outputs
# =============================================================================
output "spoke_to_hub_peering_id" {
  description = "ID of the Identity-to-Hub VNet peering."
  value       = azurerm_virtual_network_peering.spoke_to_hub.id
}

output "hub_to_spoke_peering_id" {
  description = "ID of the Hub-to-Identity VNet peering."
  value       = azurerm_virtual_network_peering.hub_to_spoke.id
}

# =============================================================================
# Private DNS Resolver Outputs
# =============================================================================
output "private_dns_resolver_id" {
  description = "ID of the Private DNS Resolver."
  value       = azurerm_private_dns_resolver.this.id
}

output "private_dns_resolver_name" {
  description = "Name of the Private DNS Resolver."
  value       = azurerm_private_dns_resolver.this.name
}

output "dns_inbound_endpoint_id" {
  description = "ID of the DNS resolver inbound endpoint."
  value       = azurerm_private_dns_resolver_inbound_endpoint.this.id
}

output "dns_inbound_endpoint_ip" {
  description = "IP configurations of the DNS resolver inbound endpoint."
  value       = azurerm_private_dns_resolver_inbound_endpoint.this.ip_configurations
}

output "dns_outbound_endpoint_id" {
  description = "ID of the DNS resolver outbound endpoint."
  value       = azurerm_private_dns_resolver_outbound_endpoint.this.id
}

# =============================================================================
# DNS Forwarding Ruleset Outputs
# =============================================================================
output "dns_forwarding_ruleset_id" {
  description = "ID of the DNS forwarding ruleset."
  value       = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
}

output "dns_forwarding_ruleset_name" {
  description = "Name of the DNS forwarding ruleset."
  value       = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.name
}

# =============================================================================
# Private DNS Zone Outputs
# =============================================================================
output "private_dns_zone_ids" {
  description = "Map of private DNS zone names to their IDs."
  value       = { for k, v in azurerm_private_dns_zone.zones : k => v.id }
}

output "private_dns_zone_names" {
  description = "List of private DNS zone names created."
  value       = [for k, v in azurerm_private_dns_zone.zones : v.name]
}

# ============================================
# Standard Outputs (auto-generated for cross-deployment compatibility)
# These outputs are required by downstream deployments via terraform_remote_state
# ============================================

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.this.location
}
