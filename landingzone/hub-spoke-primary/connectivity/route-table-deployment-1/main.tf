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
# Resource Group for Route Table
# =============================================================================
resource "azurerm_resource_group" "this" {
  name     = var.connectivity_route_table_resource_group
  location = var.region
  tags     = var.tags
}

# =============================================================================
# Route Table - Hub (Connectivity)
# =============================================================================
resource "azurerm_route_table" "this" {
  name                          = var.connectivity_route_table_name
  location                      = var.region
  resource_group_name           = azurerm_resource_group.this.name
  bgp_route_propagation_enabled = true
  tags                          = var.tags
}
