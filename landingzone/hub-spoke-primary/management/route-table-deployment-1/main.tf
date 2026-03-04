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

# -----------------------------------------------------------------------------
# Resource Group for Route Table
# -----------------------------------------------------------------------------
resource "azurerm_resource_group" "this" {
  name     = var.mgmt_route_table_resource_group
  location = var.region
  tags     = var.tags
}

# -----------------------------------------------------------------------------
# Route Table
# -----------------------------------------------------------------------------
resource "azurerm_route_table" "this" {
  name                          = var.mgmt_route_table_name
  location                      = var.region
  resource_group_name           = azurerm_resource_group.this.name
  bgp_route_propagation_enabled = false
  tags                          = var.tags
}

# -----------------------------------------------------------------------------
# Default route — 0.0.0.0/0 to Azure Firewall LB IP in hub
# Epic separation is NOT enabled, so single default route
# Note: No firewall is actually deployed in this landing zone (firewall_type is null),
# but the route table is created with BGP propagation disabled and no routes yet.
# Routes will be added when a firewall/NVA is deployed.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Associate Route Table with all Management subnets
# -----------------------------------------------------------------------------
resource "azurerm_subnet_route_table_association" "subnets" {
  for_each       = data.terraform_remote_state.management_network_deployment_1.outputs.subnet_ids
  subnet_id      = each.value
  route_table_id = azurerm_route_table.this.id
}