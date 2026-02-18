# Route Table Deployment 1 - DMZ Subscription
# Deployment ID: 7e6e79d1-70cd-4feb-8f93-d22e3f2f6fca
# Customer: Cloud AI Consulting
# Project: Secure Cloud Foundations

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
  tags     = var.tags
}

# Route Table for DMZ VNet
resource "azurerm_route_table" "dmz_route_table" {
  name                          = var.route_table_name
  location                      = azurerm_resource_group.route_table_rg.location
  resource_group_name           = azurerm_resource_group.route_table_rg.name
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
  tags                          = var.tags
}

# Default route to Hub Trust Firewall Load Balancer
# Since Epic/Non-Epic Traffic Separation is NOT enabled, single route for 0.0.0.0/0
resource "azurerm_route" "route_to_firewall" {
  name                   = var.route_to_firewall_name
  resource_group_name    = azurerm_resource_group.route_table_rg.name
  route_table_name       = azurerm_route_table.dmz_route_table.name
  address_prefix         = var.default_route_address_prefix
  next_hop_type          = var.next_hop_type_virtual_appliance
  next_hop_in_ip_address = var.hub_trust_firewall_lb_ip
}

# Associate Route Table with all DMZ subnets
resource "azurerm_subnet_route_table_association" "pe_subnet" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-pe-dmz-eus2-01"]
  route_table_id = azurerm_route_table.dmz_route_table.id
}

resource "azurerm_subnet_route_table_association" "tools_subnet" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-tools-dmz-eus2-01"]
  route_table_id = azurerm_route_table.dmz_route_table.id
}

resource "azurerm_subnet_route_table_association" "ns_mgmt_subnet" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-ns-mgmt-dmz-eus2-01"]
  route_table_id = azurerm_route_table.dmz_route_table.id
}

resource "azurerm_subnet_route_table_association" "ns_client_subnet" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-ns-client-dmz-eus2-01"]
  route_table_id = azurerm_route_table.dmz_route_table.id
}

resource "azurerm_subnet_route_table_association" "ns_server_subnet" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-ns-server-dmz-eus2-01"]
  route_table_id = azurerm_route_table.dmz_route_table.id
}

resource "azurerm_subnet_route_table_association" "ifw_mgmt_subnet" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-ifw-mgmt-dmz-eus2-01"]
  route_table_id = azurerm_route_table.dmz_route_table.id
}

resource "azurerm_subnet_route_table_association" "ifw_untrust_subnet" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-ifw-untrust-dmz-eus2-01"]
  route_table_id = azurerm_route_table.dmz_route_table.id
}

resource "azurerm_subnet_route_table_association" "ifw_trust_subnet" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-ifw-trust-dmz-eus2-01"]
  route_table_id = azurerm_route_table.dmz_route_table.id
}