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

# Resource Group for NSGs
resource "azurerm_resource_group" "nsg" {
  name     = var.nsg_resource_group_name
  location = var.region
  tags     = var.tags
}

# NSG for Private Endpoints Subnet
resource "azurerm_network_security_group" "pe" {
  name                = var.nsg_pe_name
  location            = azurerm_resource_group.nsg.location
  resource_group_name = azurerm_resource_group.nsg.name
  tags                = var.tags
}

# NSG for Tools Subnet
resource "azurerm_network_security_group" "tools" {
  name                = var.nsg_tools_name
  location            = azurerm_resource_group.nsg.location
  resource_group_name = azurerm_resource_group.nsg.name
  tags                = var.tags
}

# NSG for Firewall Management Subnet
resource "azurerm_network_security_group" "fw_mgmt" {
  name                = var.nsg_fw_mgmt_name
  location            = azurerm_resource_group.nsg.location
  resource_group_name = azurerm_resource_group.nsg.name
  tags                = var.tags
}

# NSG for Firewall Untrust Subnet
resource "azurerm_network_security_group" "fw_untrust" {
  name                = var.nsg_fw_untrust_name
  location            = azurerm_resource_group.nsg.location
  resource_group_name = azurerm_resource_group.nsg.name
  tags                = var.tags
}

# NSG for Firewall Trust Subnet
resource "azurerm_network_security_group" "fw_trust" {
  name                = var.nsg_fw_trust_name
  location            = azurerm_resource_group.nsg.location
  resource_group_name = azurerm_resource_group.nsg.name
  tags                = var.tags
}

# Security Rules for PE Subnet NSG
resource "azurerm_network_security_rule" "pe_deny_all_inbound" {
  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.pe.name
}

resource "azurerm_network_security_rule" "pe_deny_all_outbound" {
  name                        = "DenyAllOutbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.pe.name
}

resource "azurerm_network_security_rule" "pe_allow_vnet_inbound" {
  name                        = "AllowVNetInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.pe.name
}

resource "azurerm_network_security_rule" "pe_allow_vnet_outbound" {
  name                        = "AllowVNetOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.pe.name
}

# Security Rules for Tools Subnet NSG
resource "azurerm_network_security_rule" "tools_deny_all_inbound" {
  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.tools.name
}

resource "azurerm_network_security_rule" "tools_deny_all_outbound" {
  name                        = "DenyAllOutbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.tools.name
}

resource "azurerm_network_security_rule" "tools_allow_vnet_inbound" {
  name                        = "AllowVNetInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.tools.name
}

resource "azurerm_network_security_rule" "tools_allow_vnet_outbound" {
  name                        = "AllowVNetOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.tools.name
}

resource "azurerm_network_security_rule" "tools_allow_azure_lb_inbound" {
  name                        = "AllowAzureLoadBalancerInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.tools.name
}

# Security Rules for Firewall Management Subnet NSG
resource "azurerm_network_security_rule" "fw_mgmt_deny_all_inbound" {
  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_mgmt.name
}

resource "azurerm_network_security_rule" "fw_mgmt_deny_all_outbound" {
  name                        = "DenyAllOutbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_mgmt.name
}

resource "azurerm_network_security_rule" "fw_mgmt_allow_vnet_inbound" {
  name                        = "AllowVNetInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_mgmt.name
}

resource "azurerm_network_security_rule" "fw_mgmt_allow_vnet_outbound" {
  name                        = "AllowVNetOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_mgmt.name
}

resource "azurerm_network_security_rule" "fw_mgmt_allow_https_inbound" {
  name                        = "AllowHTTPSInbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_mgmt.name
}

resource "azurerm_network_security_rule" "fw_mgmt_allow_ssh_inbound" {
  name                        = "AllowSSHInbound"
  priority                    = 210
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_mgmt.name
}

resource "azurerm_network_security_rule" "fw_mgmt_allow_internet_outbound" {
  name                        = "AllowInternetOutbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_mgmt.name
}

# Security Rules for Firewall Untrust Subnet NSG
resource "azurerm_network_security_rule" "fw_untrust_deny_all_inbound" {
  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_untrust.name
}

resource "azurerm_network_security_rule" "fw_untrust_deny_all_outbound" {
  name                        = "DenyAllOutbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_untrust.name
}

resource "azurerm_network_security_rule" "fw_untrust_allow_vnet_inbound" {
  name                        = "AllowVNetInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_untrust.name
}

resource "azurerm_network_security_rule" "fw_untrust_allow_vnet_outbound" {
  name                        = "AllowVNetOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_untrust.name
}

resource "azurerm_network_security_rule" "fw_untrust_allow_internet_inbound" {
  name                        = "AllowInternetInbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_untrust.name
}

resource "azurerm_network_security_rule" "fw_untrust_allow_internet_outbound" {
  name                        = "AllowInternetOutbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_untrust.name
}

resource "azurerm_network_security_rule" "fw_untrust_allow_azure_lb_inbound" {
  name                        = "AllowAzureLoadBalancerInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_untrust.name
}

# Security Rules for Firewall Trust Subnet NSG
resource "azurerm_network_security_rule" "fw_trust_deny_all_inbound" {
  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_trust.name
}

resource "azurerm_network_security_rule" "fw_trust_deny_all_outbound" {
  name                        = "DenyAllOutbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_trust.name
}

resource "azurerm_network_security_rule" "fw_trust_allow_vnet_inbound" {
  name                        = "AllowVNetInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_trust.name
}

resource "azurerm_network_security_rule" "fw_trust_allow_vnet_outbound" {
  name                        = "AllowVNetOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_trust.name
}

resource "azurerm_network_security_rule" "fw_trust_allow_azure_lb_inbound" {
  name                        = "AllowAzureLoadBalancerInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.fw_trust.name
}

# Associate NSGs with Subnets
resource "azurerm_subnet_network_security_group_association" "pe" {
  subnet_id                 = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids[var.subnet_pe_name]
  network_security_group_id = azurerm_network_security_group.pe.id
}

resource "azurerm_subnet_network_security_group_association" "tools" {
  subnet_id                 = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids[var.subnet_tools_name]
  network_security_group_id = azurerm_network_security_group.tools.id
}

resource "azurerm_subnet_network_security_group_association" "fw_mgmt" {
  subnet_id                 = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids[var.subnet_fw_mgmt_name]
  network_security_group_id = azurerm_network_security_group.fw_mgmt.id
}

resource "azurerm_subnet_network_security_group_association" "fw_untrust" {
  subnet_id                 = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids[var.subnet_fw_untrust_name]
  network_security_group_id = azurerm_network_security_group.fw_untrust.id
}

resource "azurerm_subnet_network_security_group_association" "fw_trust" {
  subnet_id                 = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids[var.subnet_fw_trust_name]
  network_security_group_id = azurerm_network_security_group.fw_trust.id
}