# Route Table Deployment 1 - DMZ Subscription
# Customer: Cloud AI Consulting
# Project: Secure Cloud Foundations
# Deployment ID: 8b492308-bab3-41e1-a8cb-1348dfea4227

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
resource "azurerm_route_table" "dmz_rt" {
  name                          = var.route_table_name
  location                      = azurerm_resource_group.route_table_rg.location
  resource_group_name           = azurerm_resource_group.route_table_rg.name
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
  tags                          = var.tags
}

# Default Route to Hub Trust Load Balancer (0.0.0.0/0 -> Trust FW LB IP)
# Since Epic/Non-Epic Traffic Separation is NOT enabled, single route to Trust LB
resource "azurerm_route" "route_to_firewall" {
  name                   = var.route_to_firewall_name
  resource_group_name    = azurerm_resource_group.route_table_rg.name
  route_table_name       = azurerm_route_table.dmz_rt.name
  address_prefix         = var.default_route_address_prefix
  next_hop_type          = var.next_hop_type_virtual_appliance
  next_hop_in_ip_address = var.hub_trust_lb_frontend_ip
}

# Associate Route Table with DMZ Subnets
# snet-pe-dmz-wus3-01
resource "azurerm_subnet_route_table_association" "pe_subnet_association" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-pe-dmz-wus3-01"]
  route_table_id = azurerm_route_table.dmz_rt.id
}

# snet-tools-dmz-wus3-01
resource "azurerm_subnet_route_table_association" "tools_subnet_association" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-tools-dmz-wus3-01"]
  route_table_id = azurerm_route_table.dmz_rt.id
}

# snet-ns-mgmt-dmz-wus3-01
resource "azurerm_subnet_route_table_association" "ns_mgmt_subnet_association" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-ns-mgmt-dmz-wus3-01"]
  route_table_id = azurerm_route_table.dmz_rt.id
}

# snet-ns-client-dmz-wus3-01
resource "azurerm_subnet_route_table_association" "ns_client_subnet_association" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-ns-client-dmz-wus3-01"]
  route_table_id = azurerm_route_table.dmz_rt.id
}

# snet-ns-server-dmz-wus3-01
resource "azurerm_subnet_route_table_association" "ns_server_subnet_association" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-ns-server-dmz-wus3-01"]
  route_table_id = azurerm_route_table.dmz_rt.id
}

# snet-ifw-mgmt-dmz-wus3-01
resource "azurerm_subnet_route_table_association" "ifw_mgmt_subnet_association" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-ifw-mgmt-dmz-wus3-01"]
  route_table_id = azurerm_route_table.dmz_rt.id
}

# snet-ifw-untrust-dmz-wus3-01
resource "azurerm_subnet_route_table_association" "ifw_untrust_subnet_association" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-ifw-untrust-dmz-wus3-01"]
  route_table_id = azurerm_route_table.dmz_rt.id
}

# snet-ifw-trust-dmz-wus3-01
resource "azurerm_subnet_route_table_association" "ifw_trust_subnet_association" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-ifw-trust-dmz-wus3-01"]
  route_table_id = azurerm_route_table.dmz_rt.id
}