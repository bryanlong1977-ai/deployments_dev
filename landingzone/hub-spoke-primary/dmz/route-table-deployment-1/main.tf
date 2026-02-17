# Route Table Deployment 1 - DMZ Subscription
# Deployment ID: 925e43c3-6edd-4030-9310-0f384ef3ac0b
# This deployment creates the route table for the DMZ VNet and associates it with all subnets

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
  bgp_route_propagation_enabled = var.disable_bgp_route_propagation ? false : true
  tags                          = var.tags
}

# Route to Hub Trust Firewall Load Balancer (0.0.0.0/0)
# Since Epic/Non-Epic separation is NOT enabled, all traffic goes to the Trust LB
resource "azurerm_route" "route_to_firewall" {
  name                   = var.route_to_firewall_name
  resource_group_name    = azurerm_resource_group.route_table_rg.name
  route_table_name       = azurerm_route_table.dmz_rt.name
  address_prefix         = var.default_route_address_prefix
  next_hop_type          = var.next_hop_type_virtual_appliance
  next_hop_in_ip_address = var.hub_trust_firewall_lb_ip
}

# Associate Route Table with Private Endpoints Subnet
resource "azurerm_subnet_route_table_association" "pe_subnet_rt_association" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-pe-dmz-wus3-01"]
  route_table_id = azurerm_route_table.dmz_rt.id
}

# Associate Route Table with Tools Subnet
resource "azurerm_subnet_route_table_association" "tools_subnet_rt_association" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-tools-dmz-wus3-01"]
  route_table_id = azurerm_route_table.dmz_rt.id
}

# Associate Route Table with Ingress Firewall Management Subnet
resource "azurerm_subnet_route_table_association" "ifw_mgmt_subnet_rt_association" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-ifw-mgmt-dmz-wus3-01"]
  route_table_id = azurerm_route_table.dmz_rt.id
}

# Associate Route Table with Ingress Firewall Untrust Subnet
resource "azurerm_subnet_route_table_association" "ifw_untrust_subnet_rt_association" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-ifw-untrust-dmz-wus3-01"]
  route_table_id = azurerm_route_table.dmz_rt.id
}

# Associate Route Table with Ingress Firewall Trust Subnet
resource "azurerm_subnet_route_table_association" "ifw_trust_subnet_rt_association" {
  subnet_id      = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-ifw-trust-dmz-wus3-01"]
  route_table_id = azurerm_route_table.dmz_rt.id
}