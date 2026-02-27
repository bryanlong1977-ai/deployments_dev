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

# ==============================================
# Resource Group for Route Table
# ==============================================
resource "azurerm_resource_group" "this" {
  name     = var.management_route_table_resource_group
  location = var.region
  tags     = var.tags
}

# ==============================================
# Route Table
# ==============================================
resource "azurerm_route_table" "this" {
  name                          = var.management_route_table_name
  location                      = azurerm_resource_group.this.location
  resource_group_name           = azurerm_resource_group.this.name
  bgp_route_propagation_enabled = false
  tags                          = var.tags
}

# ==============================================
# Route: Default route to Azure Firewall
# Epic separation is NOT enabled, so create a single
# default route pointing 0.0.0.0/0 to the Firewall
# private IP (Azure Load Balancer FW IP) in the hub.
# Since no firewall is actually deployed in the hub
# (firewall_type is null), we use a placeholder IP.
# The next_hop will be updated when the firewall is
# deployed. Using VirtualAppliance next hop type.
# ==============================================
# Note: enable_firewall flag indicates a firewall is
# expected. The firewall private IP will be provided
# via the connectivity remote state once deployed.
# For now, we reference the connectivity network
# deployment for any needed outputs.
# ==============================================

# Since there is no firewall deployed yet (firewall_type is null
# in the landing zone config), but enable_firewall = true,
# we create the route table and default route structure.
# The route uses "None" as next hop type until a firewall IP
# is available. This can be updated later.
resource "azurerm_route" "this" {
  name                = "route-to-firewall"
  resource_group_name = azurerm_resource_group.this.name
  route_table_name    = azurerm_route_table.this.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "None"
}

# ==============================================
# Associate Route Table with Management Subnets
# ==============================================
resource "azurerm_subnet_route_table_association" "subnets" {
  for_each = var.management_subnets

  subnet_id      = data.terraform_remote_state.management_network_deployment_1.outputs.subnet_ids[each.key]
  route_table_id = azurerm_route_table.this.id
}