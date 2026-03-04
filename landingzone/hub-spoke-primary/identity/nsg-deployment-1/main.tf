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

# =============================================================================
# Resource Group for NSGs
# =============================================================================
resource "azurerm_resource_group" "this" {
  name     = var.identity_nsg_resource_group
  location = var.region
  tags     = var.tags
}

# =============================================================================
# Network Security Groups - one per subnet
# =============================================================================
resource "azurerm_network_security_group" "nsgs" {
  for_each            = var.identity_nsg_names
  name                = each.value
  location            = var.region
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

# =============================================================================
# NSG-to-Subnet Associations
# =============================================================================
resource "azurerm_subnet_network_security_group_association" "nsgs" {
  for_each                  = var.identity_nsg_names
  subnet_id                 = data.terraform_remote_state.identity_network_1.outputs.subnet_ids[each.key]
  network_security_group_id = azurerm_network_security_group.nsgs[each.key].id
}

# =============================================================================
# Default Deny Inbound Rules - one per NSG
# =============================================================================
resource "azurerm_network_security_rule" "deny_all_inbound" {
  for_each                    = var.identity_nsg_names
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

# =============================================================================
# Default Deny Outbound Rules - one per NSG
# =============================================================================
resource "azurerm_network_security_rule" "deny_all_outbound" {
  for_each                    = var.identity_nsg_names
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

# =============================================================================
# Allow VNet Inbound - all NSGs
# =============================================================================
resource "azurerm_network_security_rule" "allow_vnet_inbound" {
  for_each                    = var.identity_nsg_names
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

# =============================================================================
# Allow Azure Load Balancer Inbound - all NSGs
# =============================================================================
resource "azurerm_network_security_rule" "allow_alb_inbound" {
  for_each                    = var.identity_nsg_names
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

# =============================================================================
# Allow VNet Outbound - all NSGs
# =============================================================================
resource "azurerm_network_security_rule" "allow_vnet_outbound" {
  for_each                    = var.identity_nsg_names
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

# =============================================================================
# Allow HTTPS Outbound - all NSGs (for Azure services)
# =============================================================================
resource "azurerm_network_security_rule" "allow_https_outbound" {
  for_each                    = var.identity_nsg_names
  name                        = "AllowHTTPSOutbound"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "AzureCloud"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[each.key].name
}

# =============================================================================
# DC Subnet - Allow AD DS Inbound (LDAP, Kerberos, DNS, RPC, etc.)
# =============================================================================
resource "azurerm_network_security_rule" "dc_allow_ldap_inbound" {
  name                        = "AllowLDAPInbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "389"
  source_address_prefix       = var.identity_vnet_address_space
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_dc_idm_cus_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_dc_idm_cus_01_subnet_name].name
}

resource "azurerm_network_security_rule" "dc_allow_ldaps_inbound" {
  name                        = "AllowLDAPSInbound"
  priority                    = 210
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "636"
  source_address_prefix       = var.identity_vnet_address_space
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_dc_idm_cus_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_dc_idm_cus_01_subnet_name].name
}

resource "azurerm_network_security_rule" "dc_allow_kerberos_inbound" {
  name                        = "AllowKerberosInbound"
  priority                    = 220
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "88"
  source_address_prefix       = var.identity_vnet_address_space
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_dc_idm_cus_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_dc_idm_cus_01_subnet_name].name
}

resource "azurerm_network_security_rule" "dc_allow_dns_inbound" {
  name                        = "AllowDNSInbound"
  priority                    = 230
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = var.regional_cidr
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_dc_idm_cus_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_dc_idm_cus_01_subnet_name].name
}

resource "azurerm_network_security_rule" "dc_allow_smb_inbound" {
  name                        = "AllowSMBInbound"
  priority                    = 240
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "445"
  source_address_prefix       = var.identity_vnet_address_space
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_dc_idm_cus_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_dc_idm_cus_01_subnet_name].name
}

resource "azurerm_network_security_rule" "dc_allow_rpc_inbound" {
  name                        = "AllowRPCInbound"
  priority                    = 250
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "135"
  source_address_prefix       = var.identity_vnet_address_space
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_dc_idm_cus_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_dc_idm_cus_01_subnet_name].name
}

resource "azurerm_network_security_rule" "dc_allow_rpc_dynamic_inbound" {
  name                        = "AllowRPCDynamicInbound"
  priority                    = 260
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "49152-65535"
  source_address_prefix       = var.identity_vnet_address_space
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_dc_idm_cus_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_dc_idm_cus_01_subnet_name].name
}

resource "azurerm_network_security_rule" "dc_allow_gc_inbound" {
  name                        = "AllowGlobalCatalogInbound"
  priority                    = 270
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3268-3269"
  source_address_prefix       = var.identity_vnet_address_space
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_dc_idm_cus_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_dc_idm_cus_01_subnet_name].name
}

resource "azurerm_network_security_rule" "dc_allow_rdp_inbound" {
  name                        = "AllowRDPInbound"
  priority                    = 280
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.regional_cidr
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_dc_idm_cus_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_dc_idm_cus_01_subnet_name].name
}

resource "azurerm_network_security_rule" "dc_allow_winrm_inbound" {
  name                        = "AllowWinRMInbound"
  priority                    = 290
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5985-5986"
  source_address_prefix       = var.regional_cidr
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_dc_idm_cus_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_dc_idm_cus_01_subnet_name].name
}

# =============================================================================
# DNS Resolver Inbound Subnet - Allow DNS Inbound
# =============================================================================
resource "azurerm_network_security_rule" "inbound_allow_dns" {
  name                        = "AllowDNSInbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = var.regional_cidr
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_inbound_idm_cus_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_inbound_idm_cus_01_subnet_name].name
}

# =============================================================================
# DNS Resolver Outbound Subnet - Allow DNS Outbound
# =============================================================================
resource "azurerm_network_security_rule" "outbound_allow_dns" {
  name                        = "AllowDNSOutbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = var.identity_subnet_cidrs[var.snet_outbound_idm_cus_01_subnet_name]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_outbound_idm_cus_01_subnet_name].name
}

# =============================================================================
# Private Endpoints Subnet - Allow HTTPS Inbound from VNet
# =============================================================================
resource "azurerm_network_security_rule" "pe_allow_https_inbound" {
  name                        = "AllowHTTPSInbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.regional_cidr
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_pe_idm_cus_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_pe_idm_cus_01_subnet_name].name
}

# =============================================================================
# Tools Subnet - Allow RDP and SSH Inbound from VNet
# =============================================================================
resource "azurerm_network_security_rule" "tools_allow_rdp_inbound" {
  name                        = "AllowRDPInbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.regional_cidr
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_tools_idm_cus_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_tools_idm_cus_01_subnet_name].name
}

resource "azurerm_network_security_rule" "tools_allow_ssh_inbound" {
  name                        = "AllowSSHInbound"
  priority                    = 210
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.regional_cidr
  destination_address_prefix  = var.identity_subnet_cidrs[var.snet_tools_idm_cus_01_subnet_name]
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[var.snet_tools_idm_cus_01_subnet_name].name
}