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

# Allow VNet inbound rules
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

# DNS Resolver Inbound - Allow DNS traffic
resource "azurerm_network_security_rule" "inbound_allow_dns_tcp" {
  name                        = "AllowDnsTcpInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.inbound.name
}

resource "azurerm_network_security_rule" "inbound_allow_dns_udp" {
  name                        = "AllowDnsUdpInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
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

# DNS Resolver Outbound - Allow DNS traffic
resource "azurerm_network_security_rule" "outbound_allow_dns_tcp" {
  name                        = "AllowDnsTcpOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.outbound.name
}

resource "azurerm_network_security_rule" "outbound_allow_dns_udp" {
  name                        = "AllowDnsUdpOutbound"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "53"
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

# Domain Controllers - Allow AD traffic
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

resource "azurerm_network_security_rule" "dc_allow_ldap" {
  name                        = "AllowLdapInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["389", "636"]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.dc.name
}

resource "azurerm_network_security_rule" "dc_allow_kerberos" {
  name                        = "AllowKerberosInbound"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "88"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.dc.name
}

resource "azurerm_network_security_rule" "dc_allow_dns" {
  name                        = "AllowDnsInbound"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.dc.name
}

# Infoblox Management - Allow management traffic
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
  name                        = "AllowHttpsInbound"
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

resource "azurerm_network_security_rule" "ib_mgmt_allow_ssh" {
  name                        = "AllowSshInbound"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.ib_mgmt.name
}

# Infoblox LAN1 - Allow DNS and DHCP traffic
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

resource "azurerm_network_security_rule" "ib_lan1_allow_dns" {
  name                        = "AllowDnsInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.ib_lan1.name
}

resource "azurerm_network_security_rule" "ib_lan1_allow_dhcp" {
  name                        = "AllowDhcpInbound"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_ranges     = ["67", "68"]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg.name
  network_security_group_name = azurerm_network_security_group.ib_lan1.name
}

# NSG to Subnet Associations
resource "azurerm_subnet_network_security_group_association" "pe" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_pe_name]
  network_security_group_id = azurerm_network_security_group.pe.id
}

resource "azurerm_subnet_network_security_group_association" "tools" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_tools_name]
  network_security_group_id = azurerm_network_security_group.tools.id
}

resource "azurerm_subnet_network_security_group_association" "inbound" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_inbound_name]
  network_security_group_id = azurerm_network_security_group.inbound.id
}

resource "azurerm_subnet_network_security_group_association" "outbound" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_outbound_name]
  network_security_group_id = azurerm_network_security_group.outbound.id
}

resource "azurerm_subnet_network_security_group_association" "dc" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_dc_name]
  network_security_group_id = azurerm_network_security_group.dc.id
}

resource "azurerm_subnet_network_security_group_association" "ib_mgmt" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_ib_mgmt_name]
  network_security_group_id = azurerm_network_security_group.ib_mgmt.id
}

resource "azurerm_subnet_network_security_group_association" "ib_lan1" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_ib_lan1_name]
  network_security_group_id = azurerm_network_security_group.ib_lan1.id
}