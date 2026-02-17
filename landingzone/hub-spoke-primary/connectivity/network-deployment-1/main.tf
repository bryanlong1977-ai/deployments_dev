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

# Resource Group for Hub VNet
resource "azurerm_resource_group" "hub_network" {
  name     = var.network_resource_group_name
  location = var.region
  tags     = var.tags
}

# Resource Group for Network Watcher (dedicated RG as per best practices)
resource "azurerm_resource_group" "network_watcher" {
  name     = var.network_watcher_resource_group_name
  location = var.region
  tags     = var.tags
}

# Hub Virtual Network
resource "azurerm_virtual_network" "hub" {
  name                = var.vnet_name
  location            = azurerm_resource_group.hub_network.location
  resource_group_name = azurerm_resource_group.hub_network.name
  address_space       = var.vnet_address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
}

# Private Endpoints Subnet
resource "azurerm_subnet" "pe" {
  name                              = var.subnet_pe_name
  resource_group_name               = azurerm_resource_group.hub_network.name
  virtual_network_name              = azurerm_virtual_network.hub.name
  address_prefixes                  = [var.subnet_pe_address_prefix]
  private_endpoint_network_policies = var.private_endpoint_network_policies
}

# Tools Subnet
resource "azurerm_subnet" "tools" {
  name                 = var.subnet_tools_name
  resource_group_name  = azurerm_resource_group.hub_network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_tools_address_prefix]
}

# Firewall Management Subnet
resource "azurerm_subnet" "fw_mgmt" {
  name                 = var.subnet_fw_mgmt_name
  resource_group_name  = azurerm_resource_group.hub_network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_fw_mgmt_address_prefix]
}

# Firewall Untrust Subnet
resource "azurerm_subnet" "fw_untrust" {
  name                 = var.subnet_fw_untrust_name
  resource_group_name  = azurerm_resource_group.hub_network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_fw_untrust_address_prefix]
}

# Firewall Trust Subnet
resource "azurerm_subnet" "fw_trust" {
  name                 = var.subnet_fw_trust_name
  resource_group_name  = azurerm_resource_group.hub_network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_fw_trust_address_prefix]
}

# Gateway Subnet (required name for VPN/ExpressRoute gateways)
resource "azurerm_subnet" "gateway" {
  name                 = var.subnet_gateway_name
  resource_group_name  = azurerm_resource_group.hub_network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_gateway_address_prefix]
}

# Route Server Subnet (required name for Azure Route Server)
resource "azurerm_subnet" "route_server" {
  name                 = var.subnet_route_server_name
  resource_group_name  = azurerm_resource_group.hub_network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_route_server_address_prefix]
}

# Network Watcher (in dedicated Resource Group)
resource "azurerm_network_watcher" "hub" {
  name                = var.network_watcher_name
  location            = azurerm_resource_group.network_watcher.location
  resource_group_name = azurerm_resource_group.network_watcher.name
  tags                = var.tags
}