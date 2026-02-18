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

# Provider alias for connectivity subscription (for VNet peering)
provider "azurerm" {
  alias           = "connectivity"
  features {}
  subscription_id = var.connectivity_subscription_id
}

# Resource Group for DMZ Network
resource "azurerm_resource_group" "network" {
  name     = var.network_resource_group_name
  location = var.region
  tags     = var.tags
}

# Resource Group for Network Watcher (dedicated RG)
resource "azurerm_resource_group" "network_watcher" {
  name     = var.network_watcher_resource_group_name
  location = var.region
  tags     = var.tags
}

# DMZ Virtual Network
resource "azurerm_virtual_network" "dmz" {
  name                = var.vnet_name
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = var.vnet_address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
}

# Subnets
resource "azurerm_subnet" "pe" {
  name                                          = var.subnet_pe_name
  resource_group_name                           = azurerm_resource_group.network.name
  virtual_network_name                          = azurerm_virtual_network.dmz.name
  address_prefixes                              = [var.subnet_pe_address_prefix]
  private_endpoint_network_policies             = var.private_endpoint_network_policies
}

resource "azurerm_subnet" "tools" {
  name                 = var.subnet_tools_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.dmz.name
  address_prefixes     = [var.subnet_tools_address_prefix]
}

resource "azurerm_subnet" "ns_mgmt" {
  name                 = var.subnet_ns_mgmt_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.dmz.name
  address_prefixes     = [var.subnet_ns_mgmt_address_prefix]
}

resource "azurerm_subnet" "ns_client" {
  name                 = var.subnet_ns_client_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.dmz.name
  address_prefixes     = [var.subnet_ns_client_address_prefix]
}

resource "azurerm_subnet" "ns_server" {
  name                 = var.subnet_ns_server_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.dmz.name
  address_prefixes     = [var.subnet_ns_server_address_prefix]
}

resource "azurerm_subnet" "ifw_mgmt" {
  name                 = var.subnet_ifw_mgmt_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.dmz.name
  address_prefixes     = [var.subnet_ifw_mgmt_address_prefix]
}

resource "azurerm_subnet" "ifw_untrust" {
  name                 = var.subnet_ifw_untrust_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.dmz.name
  address_prefixes     = [var.subnet_ifw_untrust_address_prefix]
}

resource "azurerm_subnet" "ifw_trust" {
  name                 = var.subnet_ifw_trust_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.dmz.name
  address_prefixes     = [var.subnet_ifw_trust_address_prefix]
}

# Network Watcher in dedicated Resource Group
resource "azurerm_network_watcher" "dmz" {
  name                = var.network_watcher_name
  location            = azurerm_resource_group.network_watcher.location
  resource_group_name = azurerm_resource_group.network_watcher.name
  tags                = var.tags
}

# VNet Peering: DMZ to Hub
resource "azurerm_virtual_network_peering" "dmz_to_hub" {
  name                         = var.peering_dmz_to_hub_name
  resource_group_name          = azurerm_resource_group.network.name
  virtual_network_name         = azurerm_virtual_network.dmz.name
  remote_virtual_network_id    = data.terraform_remote_state.connectivity_network_deployment_1.outputs.vnet_id
  allow_virtual_network_access = var.peering_allow_virtual_network_access
  allow_forwarded_traffic      = var.peering_allow_forwarded_traffic
  allow_gateway_transit        = var.peering_allow_gateway_transit_dmz
  use_remote_gateways          = var.peering_use_remote_gateways_dmz
}

# VNet Peering: Hub to DMZ (created in connectivity subscription using provider alias)
resource "azurerm_virtual_network_peering" "hub_to_dmz" {
  provider                     = azurerm.connectivity
  name                         = var.peering_hub_to_dmz_name
  resource_group_name          = data.terraform_remote_state.connectivity_network_deployment_1.outputs.resource_group_name
  virtual_network_name         = data.terraform_remote_state.connectivity_network_deployment_1.outputs.vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.dmz.id
  allow_virtual_network_access = var.peering_allow_virtual_network_access
  allow_forwarded_traffic      = var.peering_allow_forwarded_traffic
  allow_gateway_transit        = var.peering_allow_gateway_transit_hub
  use_remote_gateways          = var.peering_use_remote_gateways_hub
}