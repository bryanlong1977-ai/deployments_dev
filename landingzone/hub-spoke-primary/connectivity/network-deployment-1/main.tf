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
  name     = var.resource_group_name
  location = var.region
  tags     = var.tags
}

# Resource Group for Network Watcher (dedicated RG per standards)
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

# Subnet: Private Endpoints
resource "azurerm_subnet" "pe" {
  name                                          = var.subnet_pe_name
  resource_group_name                           = azurerm_resource_group.hub_network.name
  virtual_network_name                          = azurerm_virtual_network.hub.name
  address_prefixes                              = [var.subnet_pe_address_prefix]
  private_endpoint_network_policies             = var.private_endpoint_network_policies
}

# Subnet: Tools
resource "azurerm_subnet" "tools" {
  name                 = var.subnet_tools_name
  resource_group_name  = azurerm_resource_group.hub_network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_tools_address_prefix]
}

# Subnet: Firewall Management
resource "azurerm_subnet" "fw_mgmt" {
  name                 = var.subnet_fw_mgmt_name
  resource_group_name  = azurerm_resource_group.hub_network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_fw_mgmt_address_prefix]
}

# Subnet: Firewall Untrust
resource "azurerm_subnet" "fw_untrust" {
  name                 = var.subnet_fw_untrust_name
  resource_group_name  = azurerm_resource_group.hub_network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_fw_untrust_address_prefix]
}

# Subnet: Firewall Trust
resource "azurerm_subnet" "fw_trust" {
  name                 = var.subnet_fw_trust_name
  resource_group_name  = azurerm_resource_group.hub_network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_fw_trust_address_prefix]
}

# Subnet: Gateway Subnet (special Azure subnet for VPN/ExpressRoute Gateway)
resource "azurerm_subnet" "gateway" {
  name                 = var.subnet_gateway_name
  resource_group_name  = azurerm_resource_group.hub_network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_gateway_address_prefix]
}

# Subnet: Route Server Subnet (special Azure subnet for Route Server)
resource "azurerm_subnet" "route_server" {
  name                 = var.subnet_route_server_name
  resource_group_name  = azurerm_resource_group.hub_network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_route_server_address_prefix]
}

# Network Watcher (in dedicated RG)
resource "azurerm_network_watcher" "hub" {
  name                = var.network_watcher_name
  location            = azurerm_resource_group.network_watcher.location
  resource_group_name = azurerm_resource_group.network_watcher.name
  tags                = var.tags
}