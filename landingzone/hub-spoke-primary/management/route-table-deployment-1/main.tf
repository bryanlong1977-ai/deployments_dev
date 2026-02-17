# Route Table Deployment 1 - Management Subscription
# Customer: Cloud AI Consulting
# Project: Secure Cloud Foundations
# Deployment ID: 925e43c3-6edd-4030-9310-0f384ef3ac0b

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

#--------------------------------------------------------------
# Resource Group for Route Table
#--------------------------------------------------------------
resource "azurerm_resource_group" "route_table_rg" {
  name     = var.route_table_resource_group_name
  location = var.region
  tags     = var.tags
}

#--------------------------------------------------------------
# Route Table
#--------------------------------------------------------------
resource "azurerm_route_table" "mgmt_rt" {
  name                          = var.route_table_name
  location                      = azurerm_resource_group.route_table_rg.location
  resource_group_name           = azurerm_resource_group.route_table_rg.name
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
  tags                          = var.tags
}

#--------------------------------------------------------------
# Route to Firewall (Default route via Azure Load Balancer FW IP)
# Since Epic/Non-Epic separation is NOT enabled, create single default route
#--------------------------------------------------------------
resource "azurerm_route" "route_to_firewall" {
  name                   = var.route_to_firewall_name
  resource_group_name    = azurerm_resource_group.route_table_rg.name
  route_table_name       = azurerm_route_table.mgmt_rt.name
  address_prefix         = var.default_route_address_prefix
  next_hop_type          = var.next_hop_type_virtual_appliance
  next_hop_in_ip_address = var.firewall_lb_ip_address
}

#--------------------------------------------------------------
# Route Table Association with Subnets
# Associate route table with all subnets in Management VNet
#--------------------------------------------------------------
resource "azurerm_subnet_route_table_association" "pe_subnet_association" {
  subnet_id      = data.terraform_remote_state.management_network_deployment_1.outputs.subnet_ids[var.pe_subnet_name]
  route_table_id = azurerm_route_table.mgmt_rt.id
}

resource "azurerm_subnet_route_table_association" "tools_subnet_association" {
  subnet_id      = data.terraform_remote_state.management_network_deployment_1.outputs.subnet_ids[var.tools_subnet_name]
  route_table_id = azurerm_route_table.mgmt_rt.id
}