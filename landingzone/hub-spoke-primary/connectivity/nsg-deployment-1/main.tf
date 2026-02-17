# NSG Deployment 1 - Connectivity Subscription
# Creates Network Security Groups for Hub VNet subnets
# Deployment 13 of 20

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

#--------------------------------------------------------------
# Resource Group for NSGs
#--------------------------------------------------------------
resource "azurerm_resource_group" "nsg_rg" {
  name     = var.nsg_resource_group_name
  location = var.region
  tags     = var.tags
}

#--------------------------------------------------------------
# Network Security Groups
#--------------------------------------------------------------

# NSG for Private Endpoints Subnet
resource "azurerm_network_security_group" "nsg_pe" {
  name                = var.nsg_pe_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = azurerm_resource_group.nsg_rg.name
  tags                = var.tags
}

# NSG for Tools Subnet
resource "azurerm_network_security_group" "nsg_tools" {
  name                = var.nsg_tools_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = azurerm_resource_group.nsg_rg.name
  tags                = var.tags
}

# NSG for Firewall Management Subnet
resource "azurerm_network_security_group" "nsg_fw_mgmt" {
  name                = var.nsg_fw_mgmt_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = azurerm_resource_group.nsg_rg.name
  tags                = var.tags
}

# NSG for Firewall Untrust Subnet
resource "azurerm_network_security_group" "nsg_fw_untrust" {
  name                = var.nsg_fw_untrust_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = azurerm_resource_group.nsg_rg.name
  tags                = var.tags
}

# NSG for Firewall Trust Subnet
resource "azurerm_network_security_group" "nsg_fw_trust" {
  name                = var.nsg_fw_trust_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = azurerm_resource_group.nsg_rg.name
  tags                = var.tags
}

#--------------------------------------------------------------
# NSG Security Rules - Private Endpoints Subnet
#--------------------------------------------------------------

# Allow inbound from VNet to Private Endpoints
resource "azurerm_network_security_rule" "nsg_pe_allow_vnet_inbound" {
  name                        = "AllowVNetInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_pe.name
}

# Allow Azure Load Balancer inbound
resource "azurerm_network_security_rule" "nsg_pe_allow_lb_inbound" {
  name                        = "AllowAzureLoadBalancerInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_pe.name
}

# Deny all other inbound
resource "azurerm_network_security_rule" "nsg_pe_deny_all_inbound" {
  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_pe.name
}

# Allow VNet outbound
resource "azurerm_network_security_rule" "nsg_pe_allow_vnet_outbound" {
  name                        = "AllowVNetOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_pe.name
}

# Deny all other outbound
resource "azurerm_network_security_rule" "nsg_pe_deny_all_outbound" {
  name                        = "DenyAllOutbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_pe.name
}

#--------------------------------------------------------------
# NSG Security Rules - Tools Subnet
#--------------------------------------------------------------

# Allow inbound from VNet
resource "azurerm_network_security_rule" "nsg_tools_allow_vnet_inbound" {
  name                        = "AllowVNetInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_tools.name
}

# Allow Azure Load Balancer inbound
resource "azurerm_network_security_rule" "nsg_tools_allow_lb_inbound" {
  name                        = "AllowAzureLoadBalancerInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_tools.name
}

# Deny all other inbound
resource "azurerm_network_security_rule" "nsg_tools_deny_all_inbound" {
  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_tools.name
}

# Allow VNet outbound
resource "azurerm_network_security_rule" "nsg_tools_allow_vnet_outbound" {
  name                        = "AllowVNetOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_tools.name
}

# Allow internet outbound for updates
resource "azurerm_network_security_rule" "nsg_tools_allow_internet_outbound" {
  name                        = "AllowInternetOutbound"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_tools.name
}

# Deny all other outbound
resource "azurerm_network_security_rule" "nsg_tools_deny_all_outbound" {
  name                        = "DenyAllOutbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_tools.name
}

#--------------------------------------------------------------
# NSG Security Rules - Firewall Management Subnet
#--------------------------------------------------------------

# Allow HTTPS inbound for management
resource "azurerm_network_security_rule" "nsg_fw_mgmt_allow_https_inbound" {
  name                        = "AllowHTTPSInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_fw_mgmt.name
}

# Allow SSH inbound for management
resource "azurerm_network_security_rule" "nsg_fw_mgmt_allow_ssh_inbound" {
  name                        = "AllowSSHInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_fw_mgmt.name
}

# Allow Azure Load Balancer inbound
resource "azurerm_network_security_rule" "nsg_fw_mgmt_allow_lb_inbound" {
  name                        = "AllowAzureLoadBalancerInbound"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_fw_mgmt.name
}

# Deny all other inbound
resource "azurerm_network_security_rule" "nsg_fw_mgmt_deny_all_inbound" {
  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_fw_mgmt.name
}

# Allow VNet outbound
resource "azurerm_network_security_rule" "nsg_fw_mgmt_allow_vnet_outbound" {
  name                        = "AllowVNetOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_fw_mgmt.name
}

# Allow internet outbound for updates
resource "azurerm_network_security_rule" "nsg_fw_mgmt_allow_internet_outbound" {
  name                        = "AllowInternetOutbound"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_fw_mgmt.name
}

# Deny all other outbound
resource "azurerm_network_security_rule" "nsg_fw_mgmt_deny_all_outbound" {
  name                        = "DenyAllOutbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_fw_mgmt.name
}

#--------------------------------------------------------------
# NSG Security Rules - Firewall Untrust Subnet
#--------------------------------------------------------------

# Allow all inbound (untrust zone receives external traffic)
resource "azurerm_network_security_rule" "nsg_fw_untrust_allow_all_inbound" {
  name                        = "AllowAllInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_fw_untrust.name
}

# Allow Azure Load Balancer inbound
resource "azurerm_network_security_rule" "nsg_fw_untrust_allow_lb_inbound" {
  name                        = "AllowAzureLoadBalancerInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_fw_untrust.name
}

# Deny all other inbound at lowest priority (after explicit allows)
resource "azurerm_network_security_rule" "nsg_fw_untrust_deny_all_inbound" {
  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_fw_untrust.name
}

# Allow all outbound (untrust zone sends to internet/external)
resource "azurerm_network_security_rule" "nsg_fw_untrust_allow_all_outbound" {
  name                        = "AllowAllOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_fw_untrust.name
}

# Deny all other outbound at lowest priority
resource "azurerm_network_security_rule" "nsg_fw_untrust_deny_all_outbound" {
  name                        = "DenyAllOutbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_fw_untrust.name
}

#--------------------------------------------------------------
# NSG Security Rules - Firewall Trust Subnet
#--------------------------------------------------------------

# Allow inbound from VNet (trust zone receives internal traffic)
resource "azurerm_network_security_rule" "nsg_fw_trust_allow_vnet_inbound" {
  name                        = "AllowVNetInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_fw_trust.name
}

# Allow Azure Load Balancer inbound
resource "azurerm_network_security_rule" "nsg_fw_trust_allow_lb_inbound" {
  name                        = "AllowAzureLoadBalancerInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_fw_trust.name
}

# Deny all other inbound
resource "azurerm_network_security_rule" "nsg_fw_trust_deny_all_inbound" {
  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_fw_trust.name
}

# Allow VNet outbound
resource "azurerm_network_security_rule" "nsg_fw_trust_allow_vnet_outbound" {
  name                        = "AllowVNetOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_fw_trust.name
}

# Deny all other outbound
resource "azurerm_network_security_rule" "nsg_fw_trust_deny_all_outbound" {
  name                        = "DenyAllOutbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_fw_trust.name
}

#--------------------------------------------------------------
# NSG to Subnet Associations
#--------------------------------------------------------------

# Associate NSG with Private Endpoints Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_pe_association" {
  subnet_id                 = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids[var.subnet_pe_name]
  network_security_group_id = azurerm_network_security_group.nsg_pe.id
}

# Associate NSG with Tools Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_tools_association" {
  subnet_id                 = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids[var.subnet_tools_name]
  network_security_group_id = azurerm_network_security_group.nsg_tools.id
}

# Associate NSG with Firewall Management Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_fw_mgmt_association" {
  subnet_id                 = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids[var.subnet_fw_mgmt_name]
  network_security_group_id = azurerm_network_security_group.nsg_fw_mgmt.id
}

# Associate NSG with Firewall Untrust Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_fw_untrust_association" {
  subnet_id                 = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids[var.subnet_fw_untrust_name]
  network_security_group_id = azurerm_network_security_group.nsg_fw_untrust.id
}

# Associate NSG with Firewall Trust Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_fw_trust_association" {
  subnet_id                 = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids[var.subnet_fw_trust_name]
  network_security_group_id = azurerm_network_security_group.nsg_fw_trust.id
}