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

# =============================================================================
# Resource Group for Route Table
# =============================================================================
resource "azurerm_resource_group" "this" {
  name     = var.identity_route_table_resource_group
  location = var.region
  tags     = var.tags
}

# =============================================================================
# Route Table
# =============================================================================
resource "azurerm_route_table" "this" {
  name                          = var.identity_route_table_name
  location                      = azurerm_resource_group.this.location
  resource_group_name           = azurerm_resource_group.this.name
  bgp_route_propagation_enabled = false
  tags                          = var.tags
}

# =============================================================================
# Route: Default route to Azure Firewall LB IP in hub
# Since enable_epic_separation is false, create a single 0.0.0.0/0 route
# pointing to the Azure Firewall private IP (load balancer IP) in the hub.
# Note: The firewall is not yet deployed in this landing zone (no firewall_type
# configured), so we use a placeholder. When a firewall is deployed, update
# the next_hop_in_ip_address variable accordingly.
# For now, since there is no firewall deployed, we still create the route
# structure but the next hop IP must be provided via the connectivity
# remote state when available. Since the connectivity deployment does not
# yet have a firewall, we skip the default route creation when no firewall
# IP is available.
# =============================================================================
# Since the landing zone configuration shows enable_firewall = true but
# firewall_type = null and no firewall was deployed in any previous deployment,
# we will NOT create a default route pointing to a non-existent firewall IP.
# The route table is created empty and routes can be added when the firewall
# is provisioned.

# =============================================================================
# Subnet Associations - Associate route table with all identity subnets
# =============================================================================
resource "azurerm_subnet_route_table_association" "subnets" {
  for_each = tomap({
    (var.snet_pe_idm_eus2_01_subnet_name)       = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.snet_pe_idm_eus2_01_subnet_name]
    (var.snet_tools_idm_eus2_01_subnet_name)     = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.snet_tools_idm_eus2_01_subnet_name]
    (var.snet_inbound_idm_eus2_01_subnet_name)   = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.snet_inbound_idm_eus2_01_subnet_name]
    (var.snet_outbound_idm_eus2_01_subnet_name)  = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.snet_outbound_idm_eus2_01_subnet_name]
    (var.snet_dc_idm_eus2_01_subnet_name)        = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.snet_dc_idm_eus2_01_subnet_name]
  })

  subnet_id      = each.value
  route_table_id = azurerm_route_table.this.id
}