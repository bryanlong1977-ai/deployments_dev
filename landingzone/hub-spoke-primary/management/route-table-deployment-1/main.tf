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

# Route Table for Management VNet
resource "azurerm_route_table" "mgmt_rt" {
  name                          = var.route_table_name
  location                      = azurerm_resource_group.route_table_rg.location
  resource_group_name           = azurerm_resource_group.route_table_rg.name
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled

  tags = var.tags
}

# Route to send all traffic (0.0.0.0/0) to the Azure Load Balancer FW IP in the Hub
# Since Epic/Non-Epic separation is NOT enabled, create single default route
resource "azurerm_route" "route_to_firewall" {
  name                   = var.route_to_firewall_name
  resource_group_name    = azurerm_resource_group.route_table_rg.name
  route_table_name       = azurerm_route_table.mgmt_rt.name
  address_prefix         = var.default_route_address_prefix
  next_hop_type          = var.next_hop_type_virtual_appliance
  next_hop_in_ip_address = var.hub_firewall_lb_ip
}

# Associate Route Table with Private Endpoint Subnet
resource "azurerm_subnet_route_table_association" "pe_subnet_association" {
  subnet_id      = data.terraform_remote_state.management_network_deployment_1.outputs.subnet_ids[var.pe_subnet_name]
  route_table_id = azurerm_route_table.mgmt_rt.id
}

# Associate Route Table with Tools Subnet
resource "azurerm_subnet_route_table_association" "tools_subnet_association" {
  subnet_id      = data.terraform_remote_state.management_network_deployment_1.outputs.subnet_ids[var.tools_subnet_name]
  route_table_id = azurerm_route_table.mgmt_rt.id
}