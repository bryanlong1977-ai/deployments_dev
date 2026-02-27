terraform {
  required_version = ">= 1.10.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.identity_subscription_id
}

provider "azurerm" {
  alias           = "connectivity"
  features {}
  subscription_id = var.connectivity_subscription_id
}

# ==============================================
# Resource Group - Identity Network
# ==============================================
resource "azurerm_resource_group" "this" {
  name     = var.identity_resource_group_name
  location = var.region
  tags     = var.tags
}

# ==============================================
# Resource Group - DNS
# ==============================================
resource "azurerm_resource_group" "dns" {
  name     = var.dns_resource_group
  location = var.region
  tags     = var.tags
}

# ==============================================
# Virtual Network - Identity
# ==============================================
resource "azurerm_virtual_network" "this" {
  name                = var.identity_vnet_name
  location            = var.region
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.identity_vnet_address_space]
  tags                = var.tags
}

# ==============================================
# Subnets - Identity
# ==============================================
resource "azurerm_subnet" "subnets" {
  for_each             = var.identity_subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]

  dynamic "delegation" {
    for_each = each.key == var.snet_inbound_idm_eus2_01_subnet_name ? [1] : []
    content {
      name = "Microsoft.Network.dnsResolvers"
      service_delegation {
        name    = "Microsoft.Network/dnsResolvers"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
  }

  dynamic "delegation" {
    for_each = each.key == var.snet_outbound_idm_eus2_01_subnet_name ? [1] : []
    content {
      name = "Microsoft.Network.dnsResolvers"
      service_delegation {
        name    = "Microsoft.Network/dnsResolvers"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
  }
}

# ==============================================
# VNet Peering - Identity to Hub (spoke side)
# ==============================================
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = var.identity_to_hub_peering_name
  resource_group_name          = azurerm_resource_group.this.name
  virtual_network_name         = azurerm_virtual_network.this.name
  remote_virtual_network_id    = data.terraform_remote_state.connectivity_network_1.outputs.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# ==============================================
# VNet Peering - Hub to Identity (hub side)
# ==============================================
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider                     = azurerm.connectivity
  name                         = var.hub_to_identity_peering_name
  resource_group_name          = data.terraform_remote_state.connectivity_network_1.outputs.resource_group_name
  virtual_network_name         = data.terraform_remote_state.connectivity_network_1.outputs.vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.this.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

# ==============================================
# Private DNS Resolver
# ==============================================
resource "azurerm_private_dns_resolver" "this" {
  name                = var.private_dns_resolver_name
  resource_group_name = azurerm_resource_group.dns.name
  location            = var.region
  virtual_network_id  = azurerm_virtual_network.this.id
  tags                = var.tags
}

# ==============================================
# DNS Resolver Inbound Endpoint
# ==============================================
resource "azurerm_private_dns_resolver_inbound_endpoint" "this" {
  name                    = var.dns_inbound_endpoint_name
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = var.region
  tags                    = var.tags

  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.subnets[var.snet_inbound_idm_eus2_01_subnet_name].id
  }
}

# ==============================================
# DNS Resolver Outbound Endpoint
# ==============================================
resource "azurerm_private_dns_resolver_outbound_endpoint" "this" {
  name                    = var.dns_outbound_endpoint_name
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = var.region
  subnet_id               = azurerm_subnet.subnets[var.snet_outbound_idm_eus2_01_subnet_name].id
  tags                    = var.tags
}

# ==============================================
# DNS Forwarding Ruleset
# ==============================================
resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "this" {
  name                                       = "dfrs-identity-prd-eus2-01"
  resource_group_name                        = azurerm_resource_group.dns.name
  location                                   = var.region
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.this.id]
  tags                                       = var.tags
}

# ==============================================
# Private DNS Zones
# ==============================================
resource "azurerm_private_dns_zone" "zones" {
  for_each            = toset(var.private_dns_zones)
  name                = each.value
  resource_group_name = azurerm_resource_group.dns.name
  tags                = var.tags
}

# ==============================================
# Private DNS Zone VNet Links - Identity VNet
# ==============================================
resource "azurerm_private_dns_zone_virtual_network_link" "identity" {
  for_each              = toset(var.private_dns_zones)
  name                  = "link-${var.identity_vnet_name}-${replace(each.value, ".", "-")}"
  resource_group_name   = azurerm_resource_group.dns.name
  private_dns_zone_name = azurerm_private_dns_zone.zones[each.value].name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false
  tags                  = var.tags
}

# ==============================================
# Private DNS Zone VNet Links - Hub VNet
# ==============================================
resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
  for_each              = toset(var.private_dns_zones)
  name                  = "link-${var.connectivity_vnet_name}-${replace(each.value, ".", "-")}"
  resource_group_name   = azurerm_resource_group.dns.name
  private_dns_zone_name = azurerm_private_dns_zone.zones[each.value].name
  virtual_network_id    = data.terraform_remote_state.connectivity_network_1.outputs.vnet_id
  registration_enabled  = false
  tags                  = var.tags
}