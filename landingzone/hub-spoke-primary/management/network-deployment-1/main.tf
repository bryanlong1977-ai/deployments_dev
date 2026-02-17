# =============================================================================
# Management Network Deployment 1 - Virtual Network, Subnets, Network Watcher
# Customer: Cloud AI Consulting
# Project: Secure Cloud Foundations
# Environment: Production
# Region: West US 3
# =============================================================================

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

# -----------------------------------------------------------------------------
# Resource Group for Virtual Network
# -----------------------------------------------------------------------------
resource "azurerm_resource_group" "network_rg" {
  name     = var.network_resource_group_name
  location = var.region
  tags     = var.tags
}

# -----------------------------------------------------------------------------
# Dedicated Resource Group for Network Watcher
# Network Watcher MUST be in a dedicated RG, not the VNet's RG
# -----------------------------------------------------------------------------
resource "azurerm_resource_group" "network_watcher_rg" {
  name     = var.network_watcher_resource_group_name
  location = var.region
  tags     = var.tags
}

# -----------------------------------------------------------------------------
# Virtual Network - Management VNet
# -----------------------------------------------------------------------------
resource "azurerm_virtual_network" "mgmt_vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name
  address_space       = var.vnet_address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# Subnets
# -----------------------------------------------------------------------------

# Private Endpoint Subnet
resource "azurerm_subnet" "snet_pe" {
  name                              = var.subnet_pe_name
  resource_group_name               = azurerm_resource_group.network_rg.name
  virtual_network_name              = azurerm_virtual_network.mgmt_vnet.name
  address_prefixes                  = [var.subnet_pe_address_prefix]
  private_endpoint_network_policies = var.private_endpoint_network_policies
}

# Tools Subnet
resource "azurerm_subnet" "snet_tools" {
  name                              = var.subnet_tools_name
  resource_group_name               = azurerm_resource_group.network_rg.name
  virtual_network_name              = azurerm_virtual_network.mgmt_vnet.name
  address_prefixes                  = [var.subnet_tools_address_prefix]
  private_endpoint_network_policies = var.private_endpoint_network_policies
}

# -----------------------------------------------------------------------------
# Network Watcher - In dedicated Resource Group
# -----------------------------------------------------------------------------
resource "azurerm_network_watcher" "mgmt_nw" {
  name                = var.network_watcher_name
  location            = azurerm_resource_group.network_watcher_rg.location
  resource_group_name = azurerm_resource_group.network_watcher_rg.name
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# VNet Peering - Management to Hub (Spoke-to-Hub peering)
# Hub side peering will be created in connectivity subscription
# -----------------------------------------------------------------------------
resource "azurerm_virtual_network_peering" "mgmt_to_hub" {
  name                         = var.peering_mgmt_to_hub_name
  resource_group_name          = azurerm_resource_group.network_rg.name
  virtual_network_name         = azurerm_virtual_network.mgmt_vnet.name
  remote_virtual_network_id    = data.terraform_remote_state.connectivity_network_deployment_1.outputs.vnet_id
  allow_virtual_network_access = var.peering_allow_virtual_network_access
  allow_forwarded_traffic      = var.peering_allow_forwarded_traffic
  allow_gateway_transit        = var.spoke_allow_gateway_transit
  use_remote_gateways          = var.spoke_use_remote_gateways
}