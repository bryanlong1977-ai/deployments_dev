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
  subscription_id = var.management_subscription_id
}

provider "azurerm" {
  alias           = "connectivity"
  features {}
  subscription_id = var.connectivity_subscription_id
}

# ============================================
# Resource Group - Network Watcher (dedicated)
# ============================================
resource "azurerm_resource_group" "network_watcher" {
  name     = var.management_network_watcher_resource_group
  location = var.region
  tags     = var.tags
}

# ============================================
# Resource Group - VNet
# ============================================
resource "azurerm_resource_group" "this" {
  name     = var.management_resource_group_name
  location = var.region
  tags     = var.tags
}

# ============================================
# Network Watcher
# ============================================
resource "azurerm_network_watcher" "this" {
  name                = var.management_network_watcher_name
  location            = var.region
  resource_group_name = azurerm_resource_group.network_watcher.name
  tags                = var.tags
}

# ============================================
# Virtual Network - Management
# ============================================
resource "azurerm_virtual_network" "this" {
  name                = var.management_vnet_name
  location            = var.region
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.management_vnet_address_space]
  tags                = var.tags

  depends_on = [azurerm_network_watcher.this]
}

# ============================================
# Subnets
# ============================================
resource "azurerm_subnet" "subnets" {
  for_each             = var.management_subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]
}

# ============================================
# VNet Peering - Management to Hub
# ============================================
resource "azurerm_virtual_network_peering" "mgmt_to_hub" {
  name                         = var.management_to_hub_peering_name
  resource_group_name          = azurerm_resource_group.this.name
  virtual_network_name         = azurerm_virtual_network.this.name
  remote_virtual_network_id    = data.terraform_remote_state.connectivity_network_deployment_1.outputs.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# ============================================
# VNet Peering - Hub to Management (cross-subscription)
# ============================================
resource "azurerm_virtual_network_peering" "hub_to_mgmt" {
  provider                     = azurerm.connectivity
  name                         = var.hub_to_management_peering_name
  resource_group_name          = data.terraform_remote_state.connectivity_network_deployment_1.outputs.resource_group_name
  virtual_network_name         = data.terraform_remote_state.connectivity_network_deployment_1.outputs.vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.this.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}