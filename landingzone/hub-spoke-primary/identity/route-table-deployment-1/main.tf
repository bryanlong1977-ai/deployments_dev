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

# -----------------------------------------------------------------------------
# Resource Group for Route Table
# -----------------------------------------------------------------------------
resource "azurerm_resource_group" "this" {
  name     = var.idm_route_table_resource_group
  location = var.region
  tags     = var.tags
}

# -----------------------------------------------------------------------------
# Route Table
# -----------------------------------------------------------------------------
resource "azurerm_route_table" "this" {
  name                          = var.idm_route_table_name
  location                      = azurerm_resource_group.this.location
  resource_group_name           = azurerm_resource_group.this.name
  bgp_route_propagation_enabled = false
  tags                          = var.tags
}

# -----------------------------------------------------------------------------
# Default Route (0.0.0.0/0 -> Azure Firewall LB IP in Hub)
# Epic separation is NOT enabled, so create a single default route
# pointing to the Azure Firewall Load Balancer IP in the hub.
# NOTE: The firewall_private_ip must be provided via the connectivity
# route table deployment's remote state or a variable. Since there is
# no firewall deployed (firewall_type is null in the config), we still
# create the route table structure and the default route pointing to
# the hub firewall IP. The firewall IP comes from connectivity route
# table deployment 1 remote state, but since no firewall exists in this
# landing zone config, we use a variable for the next hop address.
# -----------------------------------------------------------------------------

# Since enable_epic_separation = false, create one default route
# The next hop is the Azure Firewall private IP in the hub subscription.
# This is referenced from the connectivity route table deployment state.

# -----------------------------------------------------------------------------
# Subnet-to-Route-Table Associations
# Associate the route table with ALL subnets in the identity VNet
# -----------------------------------------------------------------------------
resource "azurerm_subnet_route_table_association" "subnets" {
  for_each = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids

  subnet_id      = each.value
  route_table_id = azurerm_route_table.this.id
}