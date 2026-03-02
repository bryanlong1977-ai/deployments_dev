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

# =============================================================================
# Resource Group for Route Table
# =============================================================================
resource "azurerm_resource_group" "this" {
  name     = var.management_route_table_resource_group
  location = var.region
  tags     = var.tags
}

# =============================================================================
# Route Table
# =============================================================================
resource "azurerm_route_table" "this" {
  name                          = var.management_route_table_name
  location                      = azurerm_resource_group.this.location
  resource_group_name           = azurerm_resource_group.this.name
  bgp_route_propagation_enabled = false
  tags                          = var.tags
}

# =============================================================================
# Default Route - 0.0.0.0/0 to Azure Firewall LB IP in Hub
# Since enable_epic_separation is false, create a single default route
# pointing to the Azure Firewall Load Balancer IP in the hub subscription
# =============================================================================
resource "azurerm_route" "this" {
  name                   = "route-to-firewall"
  resource_group_name    = azurerm_resource_group.this.name
  route_table_name       = azurerm_route_table.this.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = data.terraform_remote_state.connectivity_network_deployment_1.outputs.firewall_private_ip
}

# =============================================================================
# Subnet-Route Table Associations
# Associate route table with ALL subnets in the management VNet
# =============================================================================
resource "azurerm_subnet_route_table_association" "subnets" {
  for_each       = data.terraform_remote_state.management_network_deployment_1.outputs.subnet_ids
  subnet_id      = each.value
  route_table_id = azurerm_route_table.this.id
}