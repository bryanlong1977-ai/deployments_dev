# Route Table Deployment 1 - Management Subscription
# Customer: Cloud AI Consulting
# Project: Secure Cloud Foundations
# Deployment ID: 8b492308-bab3-41e1-a8cb-1348dfea4227

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

# Route Table for Management VNet
resource "azurerm_route_table" "management_rt" {
  name                          = var.route_table_name
  location                      = azurerm_resource_group.route_table_rg.location
  resource_group_name           = azurerm_resource_group.route_table_rg.name
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
  tags                          = var.tags
}

# Default route to Hub Trust Firewall Load Balancer
# Since Epic/Non-Epic Traffic Separation is NOT enabled, create single default route
resource "azurerm_route" "default_to_firewall" {
  name                   = var.default_route_name
  resource_group_name    = azurerm_resource_group.route_table_rg.name
  route_table_name       = azurerm_route_table.management_rt.name
  address_prefix         = var.default_route_address_prefix
  next_hop_type          = var.next_hop_type_virtual_appliance
  next_hop_in_ip_address = var.hub_trust_firewall_lb_ip
}

# Associate Route Table with Private Endpoint Subnet
resource "azurerm_subnet_route_table_association" "pe_subnet_association" {
  subnet_id      = data.terraform_remote_state.management_network_deployment_1.outputs.subnet_ids[var.pe_subnet_name]
  route_table_id = azurerm_route_table.management_rt.id
}

# Associate Route Table with Tools Subnet
resource "azurerm_subnet_route_table_association" "tools_subnet_association" {
  subnet_id      = data.terraform_remote_state.management_network_deployment_1.outputs.subnet_ids[var.tools_subnet_name]
  route_table_id = azurerm_route_table.management_rt.id
}