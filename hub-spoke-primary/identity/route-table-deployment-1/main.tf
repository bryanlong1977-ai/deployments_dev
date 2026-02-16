# Route Table Deployment 1 - Identity Subscription
# Customer: Cloud AI Consulting
# Project: Secure Cloud Foundations
# Environment: Production
# Region: West US 3

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

# Resource Group for Route Table
resource "azurerm_resource_group" "route_table_rg" {
  name     = var.route_table_resource_group_name
  location = var.region
  tags     = var.tags
}

# Route Table for Identity VNet
resource "azurerm_route_table" "identity_rt" {
  name                          = var.route_table_name
  location                      = azurerm_resource_group.route_table_rg.location
  resource_group_name           = azurerm_resource_group.route_table_rg.name
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
  tags                          = var.tags
}

# Default route to Azure Load Balancer (Trust ILB) in Hub
# Since Epic/Non-Epic Traffic Separation is NOT enabled, create single default route
resource "azurerm_route" "default_to_firewall" {
  name                   = var.default_route_name
  resource_group_name    = azurerm_resource_group.route_table_rg.name
  route_table_name       = azurerm_route_table.identity_rt.name
  address_prefix         = var.default_route_address_prefix
  next_hop_type          = var.default_route_next_hop_type
  next_hop_in_ip_address = var.firewall_trust_lb_ip
}

# Associate Route Table with Identity VNet Subnets
# Using data source to get subnet IDs from previous deployment via remote state

# Private Endpoints Subnet Association
resource "azurerm_subnet_route_table_association" "pe_subnet" {
  subnet_id      = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_names.pe]
  route_table_id = azurerm_route_table.identity_rt.id
}

# Tools Subnet Association
resource "azurerm_subnet_route_table_association" "tools_subnet" {
  subnet_id      = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_names.tools]
  route_table_id = azurerm_route_table.identity_rt.id
}

# DNS Resolver Inbound Subnet Association
resource "azurerm_subnet_route_table_association" "inbound_subnet" {
  subnet_id      = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_names.inbound]
  route_table_id = azurerm_route_table.identity_rt.id
}

# DNS Resolver Outbound Subnet Association
resource "azurerm_subnet_route_table_association" "outbound_subnet" {
  subnet_id      = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_names.outbound]
  route_table_id = azurerm_route_table.identity_rt.id
}

# Domain Controllers Subnet Association
resource "azurerm_subnet_route_table_association" "dc_subnet" {
  subnet_id      = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_names.dc]
  route_table_id = azurerm_route_table.identity_rt.id
}

# Infoblox Management Subnet Association
resource "azurerm_subnet_route_table_association" "ib_mgmt_subnet" {
  subnet_id      = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_names.ib_mgmt]
  route_table_id = azurerm_route_table.identity_rt.id
}

# Infoblox LAN1 Subnet Association
resource "azurerm_subnet_route_table_association" "ib_lan1_subnet" {
  subnet_id      = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_names.ib_lan1]
  route_table_id = azurerm_route_table.identity_rt.id
}