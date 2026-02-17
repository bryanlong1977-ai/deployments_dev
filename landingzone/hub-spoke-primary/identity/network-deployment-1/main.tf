terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Provider for connectivity subscription (for VNet peering)
provider "azurerm" {
  alias           = "connectivity"
  features {}
  subscription_id = var.connectivity_subscription_id
}

#--------------------------------------------------------------
# Resource Groups
#--------------------------------------------------------------

# Network Resource Group
resource "azurerm_resource_group" "network" {
  name     = var.network_resource_group_name
  location = var.region
  tags     = var.tags
}

# Network Watcher Resource Group (dedicated)
resource "azurerm_resource_group" "network_watcher" {
  name     = var.network_watcher_resource_group_name
  location = var.region
  tags     = var.tags
}

# DNS Resource Group
resource "azurerm_resource_group" "dns" {
  name     = var.dns_resource_group_name
  location = var.region
  tags     = var.tags
}

#--------------------------------------------------------------
# Virtual Network
#--------------------------------------------------------------

resource "azurerm_virtual_network" "identity" {
  name                = var.vnet_name
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

#--------------------------------------------------------------
# Subnets
#--------------------------------------------------------------

resource "azurerm_subnet" "private_endpoints" {
  name                              = var.subnet_private_endpoints_name
  resource_group_name               = azurerm_resource_group.network.name
  virtual_network_name              = azurerm_virtual_network.identity.name
  address_prefixes                  = [var.subnet_private_endpoints_prefix]
  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_subnet" "tools" {
  name                 = var.subnet_tools_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.identity.name
  address_prefixes     = [var.subnet_tools_prefix]
}

resource "azurerm_subnet" "dns_inbound" {
  name                 = var.subnet_dns_inbound_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.identity.name
  address_prefixes     = [var.subnet_dns_inbound_prefix]

  delegation {
    name = "dns-resolver-delegation"
    service_delegation {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "dns_outbound" {
  name                 = var.subnet_dns_outbound_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.identity.name
  address_prefixes     = [var.subnet_dns_outbound_prefix]

  delegation {
    name = "dns-resolver-delegation"
    service_delegation {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "domain_controllers" {
  name                 = var.subnet_domain_controllers_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.identity.name
  address_prefixes     = [var.subnet_domain_controllers_prefix]
}

resource "azurerm_subnet" "infoblox_mgmt" {
  name                 = var.subnet_infoblox_mgmt_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.identity.name
  address_prefixes     = [var.subnet_infoblox_mgmt_prefix]
}

resource "azurerm_subnet" "infoblox_lan1" {
  name                 = var.subnet_infoblox_lan1_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.identity.name
  address_prefixes     = [var.subnet_infoblox_lan1_prefix]
}

#--------------------------------------------------------------
# Network Watcher
#--------------------------------------------------------------

resource "azurerm_network_watcher" "identity" {
  name                = var.network_watcher_name
  location            = azurerm_resource_group.network_watcher.location
  resource_group_name = azurerm_resource_group.network_watcher.name
  tags                = var.tags
}

#--------------------------------------------------------------
# VNet Peering to Hub
#--------------------------------------------------------------

# Identity to Hub peering
resource "azurerm_virtual_network_peering" "identity_to_hub" {
  name                         = var.peering_identity_to_hub_name
  resource_group_name          = azurerm_resource_group.network.name
  virtual_network_name         = azurerm_virtual_network.identity.name
  remote_virtual_network_id    = data.terraform_remote_state.connectivity_network_deployment_1.outputs.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = var.use_remote_gateways
}

# Hub to Identity peering (created in connectivity subscription)
resource "azurerm_virtual_network_peering" "hub_to_identity" {
  provider                     = azurerm.connectivity
  name                         = var.peering_hub_to_identity_name
  resource_group_name          = data.terraform_remote_state.connectivity_network_deployment_1.outputs.resource_group_name
  virtual_network_name         = data.terraform_remote_state.connectivity_network_deployment_1.outputs.vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.identity.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

#--------------------------------------------------------------
# Private DNS Resolver
#--------------------------------------------------------------

resource "azurerm_private_dns_resolver" "identity" {
  name                = var.dns_resolver_name
  resource_group_name = azurerm_resource_group.dns.name
  location            = azurerm_resource_group.dns.location
  virtual_network_id  = azurerm_virtual_network.identity.id
  tags                = var.tags
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "identity" {
  name                    = var.dns_resolver_inbound_endpoint_name
  private_dns_resolver_id = azurerm_private_dns_resolver.identity.id
  location                = azurerm_resource_group.dns.location

  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.dns_inbound.id
  }

  tags = var.tags
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "identity" {
  name                    = var.dns_resolver_outbound_endpoint_name
  private_dns_resolver_id = azurerm_private_dns_resolver.identity.id
  location                = azurerm_resource_group.dns.location
  subnet_id               = azurerm_subnet.dns_outbound.id
  tags                    = var.tags
}

#--------------------------------------------------------------
# Private DNS Zones
#--------------------------------------------------------------

resource "azurerm_private_dns_zone" "zones" {
  for_each            = toset(var.private_dns_zones)
  name                = each.value
  resource_group_name = azurerm_resource_group.dns.name
  tags                = var.tags
}

# Link DNS Zones to Identity VNet
resource "azurerm_private_dns_zone_virtual_network_link" "identity" {
  for_each              = azurerm_private_dns_zone.zones
  name                  = "link-${replace(each.key, ".", "-")}-identity"
  resource_group_name   = azurerm_resource_group.dns.name
  private_dns_zone_name = each.value.name
  virtual_network_id    = azurerm_virtual_network.identity.id
  registration_enabled  = false
  tags                  = var.tags
}

# Link DNS Zones to Hub VNet
resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
  for_each              = azurerm_private_dns_zone.zones
  name                  = "link-${replace(each.key, ".", "-")}-hub"
  resource_group_name   = azurerm_resource_group.dns.name
  private_dns_zone_name = each.value.name
  virtual_network_id    = data.terraform_remote_state.connectivity_network_deployment_1.outputs.vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

#--------------------------------------------------------------
# DNS Forwarding Ruleset
#--------------------------------------------------------------

resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "identity" {
  count                                      = var.dns_forwarding_enabled ? 1 : 0
  name                                       = var.dns_forwarding_ruleset_name
  resource_group_name                        = azurerm_resource_group.dns.name
  location                                   = azurerm_resource_group.dns.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.identity.id]
  tags                                       = var.tags
}

# DNS Forwarding Rules
resource "azurerm_private_dns_resolver_forwarding_rule" "rules" {
  for_each = var.dns_forwarding_enabled ? { for rule in var.dns_forwarding_rules : rule.domain => rule } : {}

  name                      = "rule-${replace(each.value.domain, ".", "-")}"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.identity[0].id
  domain_name               = "${each.value.domain}."
  enabled                   = each.value.state == "Enabled"

  dynamic "target_dns_servers" {
    for_each = each.value.targetDnsServers
    content {
      ip_address = target_dns_servers.value
      port       = 53
    }
  }
}

# Link DNS Forwarding Ruleset to Identity VNet
resource "azurerm_private_dns_resolver_virtual_network_link" "identity" {
  count                     = var.dns_forwarding_enabled ? 1 : 0
  name                      = "link-identity-vnet"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.identity[0].id
  virtual_network_id        = azurerm_virtual_network.identity.id
}

# Link DNS Forwarding Ruleset to Hub VNet
resource "azurerm_private_dns_resolver_virtual_network_link" "hub" {
  count                     = var.dns_forwarding_enabled ? 1 : 0
  name                      = "link-hub-vnet"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.identity[0].id
  virtual_network_id        = data.terraform_remote_state.connectivity_network_deployment_1.outputs.vnet_id
}