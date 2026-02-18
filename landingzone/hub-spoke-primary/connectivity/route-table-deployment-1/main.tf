# Route Table Deployment 1 - Connectivity Subscription
# Customer: Cloud AI Consulting
# Project: Secure Cloud Foundations
# Deployment ID: 7e6e79d1-70cd-4feb-8f93-d22e3f2f6fca
# Region: East US 2
# Environment: Production

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
# Resource Group for Route Table
# -----------------------------------------------------------------------------
resource "azurerm_resource_group" "route_table" {
  name     = var.route_table_resource_group_name
  location = var.region
  tags     = var.tags
}

# -----------------------------------------------------------------------------
# Route Table
# -----------------------------------------------------------------------------
resource "azurerm_route_table" "hub" {
  name                          = var.route_table_name
  location                      = azurerm_resource_group.route_table.location
  resource_group_name           = azurerm_resource_group.route_table.name
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
  tags                          = var.tags
}

# -----------------------------------------------------------------------------
# Note: Route table is created without subnet associations as per requirements.
# Routes can be added later when firewall/NVA private IP is known.
# Example routes that could be added:
# - Default route (0.0.0.0/0) to Firewall/NVA
# - On-premises routes via VPN/ExpressRoute Gateway
# -----------------------------------------------------------------------------