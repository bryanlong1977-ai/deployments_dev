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
  subscription_id = var.connectivity_subscription_id
}

# =============================================================================
# Resource Group for Network Watcher (dedicated RG)
# =============================================================================
resource "azurerm_resource_group" "network_watcher" {
  name     = var.connectivity_network_watcher_resource_group
  location = var.region
  tags     = var.tags
}

# =============================================================================
# Resource Group for VNet and Subnets
# =============================================================================
resource "azurerm_resource_group" "this" {
  name     = var.connectivity_resource_group_name
  location = var.region
  tags     = var.tags
}

# =============================================================================
# Network Watcher
# =============================================================================
resource "azurerm_network_watcher" "this" {
  name                = var.connectivity_network_watcher_name
  location            = azurerm_resource_group.network_watcher.location
  resource_group_name = azurerm_resource_group.network_watcher.name
  tags                = var.tags
}

# =============================================================================
# Virtual Network
# =============================================================================
resource "azurerm_virtual_network" "this" {
  name                = var.connectivity_vnet_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.connectivity_vnet_address_space]
  tags                = var.tags

  depends_on = [azurerm_network_watcher.this]
}

# =============================================================================
# Subnets
# =============================================================================
resource "azurerm_subnet" "subnets" {
  for_each             = var.connectivity_subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]
}