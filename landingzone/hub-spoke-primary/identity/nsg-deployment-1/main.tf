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

# NSG for DNS Resolver Inbound Subnet
resource "azurerm_network_security_group" "inbound" {
  name                = var.nsg_inbound_name
  location            = azurerm_resource_group.nsg.location
  resource_group_name = azurerm_resource_group.nsg.name
  tags                = var.tags
}

# NSG for DNS Resolver Outbound Subnet
resource "azurerm_network_security_group" "outbound" {
  name                = var.nsg_outbound_name
  location            = azurerm_resource_group.nsg.location
  resource_group_name = azurerm_resource_group.nsg.name
  tags                = var.tags
}

# NSG for Domain Controllers Subnet
resource "azurerm_network_security_group" "dc" {
  name                = var.nsg_dc_name
  location            = azurerm_resource_group.nsg.location
  resource_group_name = azurerm_resource_group.nsg.name
  tags                = var.tags
}

# NSG for Infoblox Management Subnet
resource "azurerm_network_security_group" "ib_mgmt" {
  name                = var.nsg_ib_mgmt_name
  location            = azurerm_resource_group.nsg.location
  resource_group_name = azurerm_resource_group.nsg.name
  tags                = var.tags
}

# NSG for Infoblox LAN1 Subnet
resource "azurerm_network_security_group" "ib_lan1" {
  name                = var.nsg_ib_lan1_name
  location            = azurerm_resource_group.nsg.location
  resource_group_name = azurerm_resource_group.nsg.name
  tags                = var.tags
}

# Default Deny Inbound Rules for all NSGs
resource "azurerm_network_security_rule" "pe_deny_inbound" {
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

resource "azurerm_network_security_rule" "pe_deny_outbound" {
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

resource "azurerm_network_security_rule" "tools_deny_inbound" {
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

resource "azurerm_network_security_rule" "tools_deny_outbound" {
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

resource "azurerm_network_security_rule" "inbound_deny_inbound" {
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
  network_security_group_name = azurerm_network_security_group.inbound.name
}

resource "azurerm_network_security_rule" "inbound_deny_outbound" {
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
  network_security_group_name = azurerm_network_security_group.inbound.name
}

resource "azurerm_network_security_rule" "inbound_allow_dns_inbound" {
  name                        = "AllowDNSInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.inbound.name
}

resource "azurerm_network_security_rule" "inbound_allow_vnet_outbound" {
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
  network_security_group_name = azurerm_network_security_group.inbound.name
}

resource "azurerm_network_security_rule" "outbound_deny_inbound" {
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
  network_security_group_name = azurerm_network_security_group.outbound.name
}

resource "azurerm_network_security_rule" "outbound_deny_outbound" {
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
  network_security_group_name = azurerm_network_security_group.outbound.name
}

resource "azurerm_network_security_rule" "outbound_allow_vnet_inbound" {
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
  network_security_group_name = azurerm_network_security_group.outbound.name
}

resource "azurerm_network_security_rule" "outbound_allow_dns_outbound" {
  name                        = "AllowDNSOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.outbound.name
}

resource "azurerm_network_security_rule" "dc_deny_inbound" {
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
  network_security_group_name = azurerm_network_security_group.dc.name
}

resource "azurerm_network_security_rule" "dc_deny_outbound" {
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
  network_security_group_name = azurerm_network_security_group.dc.name
}

resource "azurerm_network_security_rule" "dc_allow_vnet_inbound" {
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
  network_security_group_name = azurerm_network_security_group.dc.name
}

resource "azurerm_network_security_rule" "dc_allow_vnet_outbound" {
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
  network_security_group_name = azurerm_network_security_group.dc.name
}

resource "azurerm_network_security_rule" "dc_allow_ad_ldap_tcp" {
  name                        = "AllowADLDAPTCP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "389"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.dc.name
}

resource "azurerm_network_security_rule" "dc_allow_ad_ldap_udp" {
  name                        = "AllowADLDAPUDP"
  priority                    = 111
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "389"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.dc.name
}

resource "azurerm_network_security_rule" "dc_allow_ad_ldaps" {
  name                        = "AllowADLDAPS"
  priority                    = 112
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "636"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.dc.name
}

resource "azurerm_network_security_rule" "dc_allow_ad_kerberos_tcp" {
  name                        = "AllowADKerberosTCP"
  priority                    = 113
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "88"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.dc.name
}

resource "azurerm_network_security_rule" "dc_allow_ad_kerberos_udp" {
  name                        = "AllowADKerberosUDP"
  priority                    = 114
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "88"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.dc.name
}

resource "azurerm_network_security_rule" "dc_allow_ad_dns_tcp" {
  name                        = "AllowADDNSTCP"
  priority                    = 115
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.dc.name
}

resource "azurerm_network_security_rule" "dc_allow_ad_dns_udp" {
  name                        = "AllowADDNSUDP"
  priority                    = 116
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.dc.name
}

resource "azurerm_network_security_rule" "ib_mgmt_deny_inbound" {
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
  network_security_group_name = azurerm_network_security_group.ib_mgmt.name
}

resource "azurerm_network_security_rule" "ib_mgmt_deny_outbound" {
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
  network_security_group_name = azurerm_network_security_group.ib_mgmt.name
}

resource "azurerm_network_security_rule" "ib_mgmt_allow_vnet_inbound" {
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
  network_security_group_name = azurerm_network_security_group.ib_mgmt.name
}

resource "azurerm_network_security_rule" "ib_mgmt_allow_vnet_outbound" {
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
  network_security_group_name = azurerm_network_security_group.ib_mgmt.name
}

resource "azurerm_network_security_rule" "ib_mgmt_allow_https" {
  name                        = "AllowHTTPS"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.ib_mgmt.name
}

resource "azurerm_network_security_rule" "ib_lan1_deny_inbound" {
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
  network_security_group_name = azurerm_network_security_group.ib_lan1.name
}

resource "azurerm_network_security_rule" "ib_lan1_deny_outbound" {
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
  network_security_group_name = azurerm_network_security_group.ib_lan1.name
}

resource "azurerm_network_security_rule" "ib_lan1_allow_vnet_inbound" {
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
  network_security_group_name = azurerm_network_security_group.ib_lan1.name
}

resource "azurerm_network_security_rule" "ib_lan1_allow_vnet_outbound" {
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
  network_security_group_name = azurerm_network_security_group.ib_lan1.name
}

resource "azurerm_network_security_rule" "ib_lan1_allow_dns_tcp" {
  name                        = "AllowDNSTCP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.ib_lan1.name
}

resource "azurerm_network_security_rule" "ib_lan1_allow_dns_udp" {
  name                        = "AllowDNSUDP"
  priority                    = 111
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.ib_lan1.name
}

# Associate NSGs with Subnets
resource "azurerm_subnet_network_security_group_association" "pe" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids["snet-pe-idm-eus2-01"]
  network_security_group_id = azurerm_network_security_group.pe.id
}

resource "azurerm_subnet_network_security_group_association" "tools" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids["snet-tools-idm-eus2-01"]
  network_security_group_id = azurerm_network_security_group.tools.id
}

resource "azurerm_subnet_network_security_group_association" "inbound" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids["snet-inbound-idm-eus2-01"]
  network_security_group_id = azurerm_network_security_group.inbound.id
}

resource "azurerm_subnet_network_security_group_association" "outbound" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids["snet-outbound-idm-eus2-01"]
  network_security_group_id = azurerm_network_security_group.outbound.id
}

resource "azurerm_subnet_network_security_group_association" "dc" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids["snet-dc-idm-eus2-01"]
  network_security_group_id = azurerm_network_security_group.dc.id
}

resource "azurerm_subnet_network_security_group_association" "ib_mgmt" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids["snet-ib-mgmt-idm-eus2-01"]
  network_security_group_id = azurerm_network_security_group.ib_mgmt.id
}

resource "azurerm_subnet_network_security_group_association" "ib_lan1" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids["snet-ib-lan1-idm-eus2-01"]
  network_security_group_id = azurerm_network_security_group.ib_lan1.id
}