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

# NSG for Ingress Firewall Management subnet
resource "azurerm_network_security_group" "nsg_ifw_mgmt" {
  name                = var.nsg_ifw_mgmt_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = azurerm_resource_group.nsg_rg.name
  tags                = var.tags
}

# NSG for Ingress Firewall Untrust subnet
resource "azurerm_network_security_group" "nsg_ifw_untrust" {
  name                = var.nsg_ifw_untrust_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = azurerm_resource_group.nsg_rg.name
  tags                = var.tags
}

# NSG for Ingress Firewall Trust subnet
resource "azurerm_network_security_group" "nsg_ifw_trust" {
  name                = var.nsg_ifw_trust_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = azurerm_resource_group.nsg_rg.name
  tags                = var.tags
}

# ==========================================
# NSG Security Rules - Private Endpoints
# ==========================================

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
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_pe.name
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
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_pe.name
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
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_pe.name
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
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_pe.name
}

# ==========================================
# NSG Security Rules - Tools
# ==========================================

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
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_tools.name
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
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_tools.name
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
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_tools.name
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
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_tools.name
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
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_tools.name
}

# ==========================================
# NSG Security Rules - Ingress Firewall Management
# ==========================================

resource "azurerm_network_security_rule" "ifw_mgmt_deny_all_inbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ifw_mgmt.name
}

resource "azurerm_network_security_rule" "ifw_mgmt_deny_all_outbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ifw_mgmt.name
}

resource "azurerm_network_security_rule" "ifw_mgmt_allow_vnet_inbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ifw_mgmt.name
}

resource "azurerm_network_security_rule" "ifw_mgmt_allow_vnet_outbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ifw_mgmt.name
}

resource "azurerm_network_security_rule" "ifw_mgmt_allow_https_mgmt_inbound" {
  name                        = "AllowHTTPSMgmtInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_ifw_mgmt.name
}

resource "azurerm_network_security_rule" "ifw_mgmt_allow_ssh_inbound" {
  name                        = "AllowSSHInbound"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_ifw_mgmt.name
}

resource "azurerm_network_security_rule" "ifw_mgmt_allow_internet_outbound" {
  name                        = "AllowInternetOutbound"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_ifw_mgmt.name
}

# ==========================================
# NSG Security Rules - Ingress Firewall Untrust
# ==========================================

resource "azurerm_network_security_rule" "ifw_untrust_deny_all_inbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ifw_untrust.name
}

resource "azurerm_network_security_rule" "ifw_untrust_deny_all_outbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ifw_untrust.name
}

resource "azurerm_network_security_rule" "ifw_untrust_allow_internet_inbound" {
  name                        = "AllowInternetInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_ifw_untrust.name
}

resource "azurerm_network_security_rule" "ifw_untrust_allow_azure_lb_inbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ifw_untrust.name
}

resource "azurerm_network_security_rule" "ifw_untrust_allow_vnet_outbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ifw_untrust.name
}

# ==========================================
# NSG Security Rules - Ingress Firewall Trust
# ==========================================

resource "azurerm_network_security_rule" "ifw_trust_deny_all_inbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ifw_trust.name
}

resource "azurerm_network_security_rule" "ifw_trust_deny_all_outbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ifw_trust.name
}

resource "azurerm_network_security_rule" "ifw_trust_allow_vnet_inbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ifw_trust.name
}

resource "azurerm_network_security_rule" "ifw_trust_allow_vnet_outbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ifw_trust.name
}

resource "azurerm_network_security_rule" "ifw_trust_allow_azure_lb_inbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_ifw_trust.name
}

# ==========================================
# NSG to Subnet Associations
# ==========================================

resource "azurerm_subnet_network_security_group_association" "pe_nsg_assoc" {
  subnet_id                 = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_pe_id
  network_security_group_id = azurerm_network_security_group.nsg_pe.id
}

resource "azurerm_subnet_network_security_group_association" "tools_nsg_assoc" {
  subnet_id                 = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_tools_id
  network_security_group_id = azurerm_network_security_group.nsg_tools.id
}

resource "azurerm_subnet_network_security_group_association" "ifw_mgmt_nsg_assoc" {
  subnet_id                 = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ifw_mgmt_id
  network_security_group_id = azurerm_network_security_group.nsg_ifw_mgmt.id
}

resource "azurerm_subnet_network_security_group_association" "ifw_untrust_nsg_assoc" {
  subnet_id                 = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ifw_untrust_id
  network_security_group_id = azurerm_network_security_group.nsg_ifw_untrust.id
}

resource "azurerm_subnet_network_security_group_association" "ifw_trust_nsg_assoc" {
  subnet_id                 = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ifw_trust_id
  network_security_group_id = azurerm_network_security_group.nsg_ifw_trust.id
}