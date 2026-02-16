# Route Table Deployment 1 - Connectivity Subscription
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

  tags = var.tags
}

# Route Table
resource "azurerm_route_table" "hub_route_table" {
  name                          = var.route_table_name
  location                      = azurerm_resource_group.route_table_rg.location
  resource_group_name           = azurerm_resource_group.route_table_rg.name
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled

  tags = var.tags
}