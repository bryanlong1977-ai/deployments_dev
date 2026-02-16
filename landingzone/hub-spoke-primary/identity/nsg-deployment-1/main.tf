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
resource "azurerm_resource_group" "nsg_rg" {
  name     = var.nsg_resource_group_name
  location = var.region
  tags     = var.tags
}

# NSG for Private Endpoints subnet
resource "azurerm_network_security_group" "nsg_pe" {
  name                = var.nsg_pe_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = azurerm_resource_group.nsg_rg.name
  tags                = var.tags
}

# NSG for Tools subnet
resource "azurerm_network_security_group" "nsg_tools" {
  name                = var.nsg_tools_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = azurerm_resource_group.nsg_rg.name
  tags                = var.tags
}

# NSG for DNS Resolver Inbound subnet
resource "azurerm_network_security_group" "nsg_inbound" {
  name                = var.nsg_inbound_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = azurerm_resource_group.nsg_rg.name
  tags                = var.tags
}

# NSG for DNS Resolver Outbound subnet
resource "azurerm_network_security_group" "nsg_outbound" {
  name                = var.nsg_outbound_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = azurerm_resource_group.nsg_rg.name
  tags                = var.tags
}

# NSG for Domain Controllers subnet
resource "azurerm_network_security_group" "nsg_dc" {
  name                = var.nsg_dc_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = azurerm_resource_group.nsg_rg.name
  tags                = var.tags
}

# NSG for Infoblox Management subnet
resource "azurerm_network_security_group" "nsg_ib_mgmt" {
  name                = var.nsg_ib_mgmt_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = azurerm_resource_group.nsg_rg.name
  tags                = var.tags
}

# NSG for Infoblox LAN1 subnet
resource "azurerm_network_security_group" "nsg_ib_lan1" {
  name                = var.nsg_ib_lan1_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = azurerm_resource_group.nsg_rg.name
  tags                = var.tags
}

# Security Rules for Private Endpoints NSG
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

# Security Rules for Tools NSG
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

# Security Rules for DNS Resolver Inbound NSG
resource "azurerm_network_security_rule" "nsg_inbound_deny_all_inbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_inbound.name
}

resource "azurerm_network_security_rule" "nsg_inbound_deny_all_outbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_inbound.name
}

resource "azurerm_network_security_rule" "nsg_inbound_allow_dns_udp" {
  name                        = "AllowDnsUdpInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_inbound.name
}

resource "azurerm_network_security_rule" "nsg_inbound_allow_dns_tcp" {
  name                        = "AllowDnsTcpInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_inbound.name
}

resource "azurerm_network_security_rule" "nsg_inbound_allow_vnet_outbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_inbound.name
}

# Security Rules for DNS Resolver Outbound NSG
resource "azurerm_network_security_rule" "nsg_outbound_deny_all_inbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_outbound.name
}

resource "azurerm_network_security_rule" "nsg_outbound_deny_all_outbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_outbound.name
}

resource "azurerm_network_security_rule" "nsg_outbound_allow_dns_udp" {
  name                        = "AllowDnsUdpOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_outbound.name
}

resource "azurerm_network_security_rule" "nsg_outbound_allow_dns_tcp" {
  name                        = "AllowDnsTcpOutbound"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_outbound.name
}

resource "azurerm_network_security_rule" "nsg_outbound_allow_vnet_inbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_outbound.name
}

# Security Rules for Domain Controllers NSG
resource "azurerm_network_security_rule" "nsg_dc_deny_all_inbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_dc.name
}

resource "azurerm_network_security_rule" "nsg_dc_deny_all_outbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_dc.name
}

resource "azurerm_network_security_rule" "nsg_dc_allow_ad_dns_tcp" {
  name                        = "AllowADDnsTcpInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_dc.name
}

resource "azurerm_network_security_rule" "nsg_dc_allow_ad_dns_udp" {
  name                        = "AllowADDnsUdpInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_dc.name
}

resource "azurerm_network_security_rule" "nsg_dc_allow_kerberos_tcp" {
  name                        = "AllowKerberosTcpInbound"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "88"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_dc.name
}

resource "azurerm_network_security_rule" "nsg_dc_allow_kerberos_udp" {
  name                        = "AllowKerberosUdpInbound"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "88"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_dc.name
}

resource "azurerm_network_security_rule" "nsg_dc_allow_ldap_tcp" {
  name                        = "AllowLdapTcpInbound"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "389"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_dc.name
}

resource "azurerm_network_security_rule" "nsg_dc_allow_ldap_udp" {
  name                        = "AllowLdapUdpInbound"
  priority                    = 150
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "389"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_dc.name
}

resource "azurerm_network_security_rule" "nsg_dc_allow_ldaps" {
  name                        = "AllowLdapsInbound"
  priority                    = 160
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "636"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_dc.name
}

resource "azurerm_network_security_rule" "nsg_dc_allow_smb" {
  name                        = "AllowSmbInbound"
  priority                    = 170
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "445"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_dc.name
}

resource "azurerm_network_security_rule" "nsg_dc_allow_rpc" {
  name                        = "AllowRpcInbound"
  priority                    = 180
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "135"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_dc.name
}

resource "azurerm_network_security_rule" "nsg_dc_allow_gc" {
  name                        = "AllowGlobalCatalogInbound"
  priority                    = 190
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3268-3269"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_dc.name
}

resource "azurerm_network_security_rule" "nsg_dc_allow_rdp" {
  name                        = "AllowRdpInbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_dc.name
}

resource "azurerm_network_security_rule" "nsg_dc_allow_winrm" {
  name                        = "AllowWinRmInbound"
  priority                    = 210
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5985-5986"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_dc.name
}

resource "azurerm_network_security_rule" "nsg_dc_allow_vnet_outbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_dc.name
}

resource "azurerm_network_security_rule" "nsg_dc_allow_internet_outbound" {
  name                        = "AllowInternetOutbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_dc.name
}

# Security Rules for Infoblox Management NSG
resource "azurerm_network_security_rule" "nsg_ib_mgmt_deny_all_inbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ib_mgmt.name
}

resource "azurerm_network_security_rule" "nsg_ib_mgmt_deny_all_outbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ib_mgmt.name
}

resource "azurerm_network_security_rule" "nsg_ib_mgmt_allow_https" {
  name                        = "AllowHttpsInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_ib_mgmt.name
}

resource "azurerm_network_security_rule" "nsg_ib_mgmt_allow_ssh" {
  name                        = "AllowSshInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_ib_mgmt.name
}

resource "azurerm_network_security_rule" "nsg_ib_mgmt_allow_vnet_outbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ib_mgmt.name
}

resource "azurerm_network_security_rule" "nsg_ib_mgmt_allow_internet_outbound" {
  name                        = "AllowInternetOutbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_ib_mgmt.name
}

# Security Rules for Infoblox LAN1 NSG
resource "azurerm_network_security_rule" "nsg_ib_lan1_deny_all_inbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ib_lan1.name
}

resource "azurerm_network_security_rule" "nsg_ib_lan1_deny_all_outbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ib_lan1.name
}

resource "azurerm_network_security_rule" "nsg_ib_lan1_allow_dns_tcp" {
  name                        = "AllowDnsTcpInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_ib_lan1.name
}

resource "azurerm_network_security_rule" "nsg_ib_lan1_allow_dns_udp" {
  name                        = "AllowDnsUdpInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_ib_lan1.name
}

resource "azurerm_network_security_rule" "nsg_ib_lan1_allow_dhcp" {
  name                        = "AllowDhcpInbound"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "67-68"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_ib_lan1.name
}

resource "azurerm_network_security_rule" "nsg_ib_lan1_allow_vnet_outbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ib_lan1.name
}

resource "azurerm_network_security_rule" "nsg_ib_lan1_allow_dns_outbound" {
  name                        = "AllowDnsOutbound"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_ib_lan1.name
}

# Associate NSGs with Subnets
resource "azurerm_subnet_network_security_group_association" "nsg_pe_association" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_pe_name]
  network_security_group_id = azurerm_network_security_group.nsg_pe.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_tools_association" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_tools_name]
  network_security_group_id = azurerm_network_security_group.nsg_tools.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_inbound_association" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_inbound_name]
  network_security_group_id = azurerm_network_security_group.nsg_inbound.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_outbound_association" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_outbound_name]
  network_security_group_id = azurerm_network_security_group.nsg_outbound.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_dc_association" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_dc_name]
  network_security_group_id = azurerm_network_security_group.nsg_dc.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_ib_mgmt_association" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_ib_mgmt_name]
  network_security_group_id = azurerm_network_security_group.nsg_ib_mgmt.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_ib_lan1_association" {
  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[var.subnet_ib_lan1_name]
  network_security_group_id = azurerm_network_security_group.nsg_ib_lan1.id
}