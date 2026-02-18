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

# Route Table for Identity VNet
resource "azurerm_route_table" "identity_rt" {
  name                          = var.route_table_name
  location                      = azurerm_resource_group.route_table_rg.location
  resource_group_name           = azurerm_resource_group.route_table_rg.name
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled

  tags = var.tags
}

# Default route to Azure Load Balancer FW IP in Hub
# Since Epic/Non-Epic Traffic Separation is NOT enabled, create single 0.0.0.0/0 route
resource "azurerm_route" "default_to_firewall" {
  name                   = var.default_route_name
  resource_group_name    = azurerm_resource_group.route_table_rg.name
  route_table_name       = azurerm_route_table.identity_rt.name
  address_prefix         = var.default_route_address_prefix
  next_hop_type          = var.default_route_next_hop_type
  next_hop_in_ip_address = var.firewall_lb_private_ip
}

# Associate Route Table with Private Endpoints Subnet
resource "azurerm_subnet_route_table_association" "pe_subnet_association" {
  subnet_id      = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_pe_name]
  route_table_id = azurerm_route_table.identity_rt.id
}

# Associate Route Table with Tools Subnet
resource "azurerm_subnet_route_table_association" "tools_subnet_association" {
  subnet_id      = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_tools_name]
  route_table_id = azurerm_route_table.identity_rt.id
}

# Associate Route Table with DNS Resolver Inbound Subnet
resource "azurerm_subnet_route_table_association" "inbound_subnet_association" {
  subnet_id      = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_inbound_name]
  route_table_id = azurerm_route_table.identity_rt.id
}

# Associate Route Table with DNS Resolver Outbound Subnet
resource "azurerm_subnet_route_table_association" "outbound_subnet_association" {
  subnet_id      = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_outbound_name]
  route_table_id = azurerm_route_table.identity_rt.id
}

# Associate Route Table with Domain Controllers Subnet
resource "azurerm_subnet_route_table_association" "dc_subnet_association" {
  subnet_id      = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_dc_name]
  route_table_id = azurerm_route_table.identity_rt.id
}

# Associate Route Table with Infoblox Management Subnet
resource "azurerm_subnet_route_table_association" "ib_mgmt_subnet_association" {
  subnet_id      = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_ib_mgmt_name]
  route_table_id = azurerm_route_table.identity_rt.id
}

# Associate Route Table with Infoblox LAN1 Subnet
resource "azurerm_subnet_route_table_association" "ib_lan1_subnet_association" {
  subnet_id      = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_ib_lan1_name]
  route_table_id = azurerm_route_table.identity_rt.id
}