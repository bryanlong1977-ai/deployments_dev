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
  subscription_id = var.identity_subscription_id
}

# ============================================
# Resource Group for Route Table
# ============================================
resource "azurerm_resource_group" "this" {
  name     = var.idm_route_table_resource_group
  location = var.region
  tags     = var.tags
}

# ============================================
# Route Table
# ============================================
resource "azurerm_route_table" "this" {
  name                          = var.idm_route_table_name
  location                      = azurerm_resource_group.this.location
  resource_group_name           = azurerm_resource_group.this.name
  bgp_route_propagation_enabled = false
  tags                          = var.tags
}

# ============================================
# Route - Default route to Internet (no firewall deployed)
# Since enable_epic_separation is false and there is no
# firewall/NVA deployed (firewall_type is null), we create
# a default route. Without a firewall private IP to point to,
# the route uses None next hop to drop traffic by default.
# This can be updated later when a firewall is deployed.
# ============================================
# Note: No firewall is deployed in this landing zone (firewall_type is null),
# so no default 0.0.0.0/0 route to a firewall is created.
# The route table is created empty and ready for future route additions.

# ============================================
# Subnet-Route Table Associations
# Associate the route table with all identity subnets
# ============================================
locals {
  identity_subnet_names = [
    var.snet_pe_idm_cus_01_subnet_name,
    var.snet_tools_idm_cus_01_subnet_name,
    var.snet_inbound_idm_cus_01_subnet_name,
    var.snet_outbound_idm_cus_01_subnet_name,
    var.snet_dc_idm_cus_01_subnet_name,
  ]
}

resource "azurerm_subnet_route_table_association" "subnets" {
  for_each       = toset(local.identity_subnet_names)
  subnet_id      = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[each.key]
  route_table_id = azurerm_route_table.this.id
}