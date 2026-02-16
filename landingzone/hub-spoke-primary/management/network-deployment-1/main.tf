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

# Provider for Connectivity subscription (for peering)
provider "azurerm" {
  alias           = "connectivity"
  features {}
  subscription_id = var.connectivity_subscription_id
}

# Resource Group for VNet
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

# Management Virtual Network
resource "azurerm_virtual_network" "mgmt" {
  name                = var.vnet_name
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = var.vnet_address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
}

# Subnet: Private Endpoints
resource "azurerm_subnet" "pe" {
  name                              = var.subnet_pe_name
  resource_group_name               = azurerm_resource_group.network.name
  virtual_network_name              = azurerm_virtual_network.mgmt.name
  address_prefixes                  = [var.subnet_pe_address_prefix]
  private_endpoint_network_policies = "Enabled"
}

# Subnet: Tools
resource "azurerm_subnet" "tools" {
  name                 = var.subnet_tools_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.mgmt.name
  address_prefixes     = [var.subnet_tools_address_prefix]
}

# Network Watcher
resource "azurerm_network_watcher" "mgmt" {
  name                = var.network_watcher_name
  location            = azurerm_resource_group.network_watcher.location
  resource_group_name = azurerm_resource_group.network_watcher.name
  tags                = var.tags
}

# VNet Peering: Management to Hub
resource "azurerm_virtual_network_peering" "mgmt_to_hub" {
  name                         = var.peering_mgmt_to_hub_name
  resource_group_name          = azurerm_resource_group.network.name
  virtual_network_name         = azurerm_virtual_network.mgmt.name
  remote_virtual_network_id    = data.terraform_remote_state.connectivity_network_deployment_1.outputs.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = var.use_remote_gateways
}

# VNet Peering: Hub to Management (created in Connectivity subscription)
resource "azurerm_virtual_network_peering" "hub_to_mgmt" {
  provider                     = azurerm.connectivity
  name                         = var.peering_hub_to_mgmt_name
  resource_group_name          = data.terraform_remote_state.connectivity_network_deployment_1.outputs.resource_group_name
  virtual_network_name         = data.terraform_remote_state.connectivity_network_deployment_1.outputs.vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.mgmt.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}