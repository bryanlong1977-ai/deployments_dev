terraform {
  required_version = ">= 1.10.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.identity_subscription_id
}

# -----------------------------------------------------------------------------
# Resource Group for NSGs
# -----------------------------------------------------------------------------
resource "azurerm_resource_group" "this" {
  name     = var.identity_nsg_resource_group
  location = var.region
  tags     = var.tags
}

# -----------------------------------------------------------------------------
# Network Security Groups — one per subnet in the Identity VNet
# -----------------------------------------------------------------------------
resource "azurerm_network_security_group" "nsgs" {
  for_each = var.identity_nsg_names

  name                = each.value
  location            = var.region
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# NSG-to-Subnet Associations
# -----------------------------------------------------------------------------
resource "azurerm_subnet_network_security_group_association" "nsgs" {
  for_each = var.identity_nsg_names

  subnet_id                 = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids[each.key]
  network_security_group_id = azurerm_network_security_group.nsgs[each.key].id
}

# -----------------------------------------------------------------------------
# Default Deny Inbound Rules — one per NSG
# -----------------------------------------------------------------------------
resource "azurerm_network_security_rule" "deny_all_inbound" {
  for_each = var.identity_nsg_names

  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[each.key].name
}

# -----------------------------------------------------------------------------
# Default Deny Outbound Rules — one per NSG
# -----------------------------------------------------------------------------
resource "azurerm_network_security_rule" "deny_all_outbound" {
  for_each = var.identity_nsg_names

  name                        = "DenyAllOutbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[each.key].name
}

# -----------------------------------------------------------------------------
# Allow VNet Inbound — all NSGs
# -----------------------------------------------------------------------------
resource "azurerm_network_security_rule" "allow_vnet_inbound" {
  for_each = var.identity_nsg_names

  name                        = "AllowVNetInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[each.key].name
}

# -----------------------------------------------------------------------------
# Allow Azure Load Balancer Inbound — all NSGs
# -----------------------------------------------------------------------------
resource "azurerm_network_security_rule" "allow_alb_inbound" {
  for_each = var.identity_nsg_names

  name                        = "AllowAzureLoadBalancerInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[each.key].name
}

# -----------------------------------------------------------------------------
# Allow VNet Outbound — all NSGs
# -----------------------------------------------------------------------------
resource "azurerm_network_security_rule" "allow_vnet_outbound" {
  for_each = var.identity_nsg_names

  name                        = "AllowVNetOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[each.key].name
}

# -----------------------------------------------------------------------------
# Allow HTTPS Outbound — all NSGs (for Azure services / management)
# -----------------------------------------------------------------------------
resource "azurerm_network_security_rule" "allow_https_outbound" {
  for_each = var.identity_nsg_names

  name                        = "AllowHttpsOutbound"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[each.key].name
}

# -----------------------------------------------------------------------------
# DC subnet — Allow AD DS inbound from VNet (LDAP, Kerberos, DNS, etc.)
# -----------------------------------------------------------------------------
resource "azurerm_network_security_rule" "dc_allow_ad_inbound_tcp" {
  name                        = "AllowADInboundTcp"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["53", "88", "135", "389", "445", "464", "636", "3268", "3269", "5722", "9389", "49152-65535"]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_dc_idm_eus2_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_dc_idm_eus2_01_subnet_name].name
}

resource "azurerm_network_security_rule" "dc_allow_ad_inbound_udp" {
  name                        = "AllowADInboundUdp"
  priority                    = 210
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_ranges     = ["53", "88", "123", "389", "464", "500", "4500"]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_dc_idm_eus2_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_dc_idm_eus2_01_subnet_name].name
}

# -----------------------------------------------------------------------------
# DNS Resolver Inbound subnet — Allow DNS inbound from VNet
# -----------------------------------------------------------------------------
resource "azurerm_network_security_rule" "inbound_allow_dns_tcp" {
  name                        = "AllowDnsInboundTcp"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_inbound_idm_eus2_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_inbound_idm_eus2_01_subnet_name].name
}

resource "azurerm_network_security_rule" "inbound_allow_dns_udp" {
  name                        = "AllowDnsInboundUdp"
  priority                    = 210
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_inbound_idm_eus2_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_inbound_idm_eus2_01_subnet_name].name
}

# -----------------------------------------------------------------------------
# DNS Resolver Outbound subnet — Allow DNS outbound
# -----------------------------------------------------------------------------
resource "azurerm_network_security_rule" "outbound_allow_dns_tcp" {
  name                        = "AllowDnsOutboundTcp"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = var.identity_subnet_cidrs[var.snet_outbound_idm_eus2_01_subnet_name]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_outbound_idm_eus2_01_subnet_name].name
}