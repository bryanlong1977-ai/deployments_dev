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

# Security Rules for Private Endpoints NSG
# Default Deny Inbound Rule
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

# Default Deny Outbound Rule
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

# Allow HTTPS Inbound for Private Endpoints
resource "azurerm_network_security_rule" "nsg_pe_allow_https_inbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_pe.name
}

# Allow Azure Load Balancer Inbound
resource "azurerm_network_security_rule" "nsg_pe_allow_azurelb_inbound" {
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

# Allow VNet Outbound for Private Endpoints
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
# Default Deny Inbound Rule
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

# Default Deny Outbound Rule
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

# Allow HTTPS Inbound for Tools
resource "azurerm_network_security_rule" "nsg_tools_allow_https_inbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_tools.name
}

# Allow RDP Inbound for Tools (from VNet only)
resource "azurerm_network_security_rule" "nsg_tools_allow_rdp_inbound" {
  name                        = "AllowRDPInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_tools.name
}

# Allow SSH Inbound for Tools (from VNet only)
resource "azurerm_network_security_rule" "nsg_tools_allow_ssh_inbound" {
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
  network_security_group_name = azurerm_network_security_group.nsg_tools.name
}

# Allow Azure Load Balancer Inbound
resource "azurerm_network_security_rule" "nsg_tools_allow_azurelb_inbound" {
  name                        = "AllowAzureLoadBalancerInbound"
  priority                    = 130
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

# Allow VNet Outbound for Tools
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

# Allow HTTPS Outbound for Tools (Azure services)
resource "azurerm_network_security_rule" "nsg_tools_allow_https_outbound" {
  name                        = "AllowHTTPSOutbound"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.nsg_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_tools.name
}

# Associate NSGs with Subnets
resource "azurerm_subnet_network_security_group_association" "nsg_pe_association" {
  subnet_id                 = data.terraform_remote_state.management_network_deployment_1.outputs.subnet_ids[var.subnet_pe_name]
  network_security_group_id = azurerm_network_security_group.nsg_pe.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_tools_association" {
  subnet_id                 = data.terraform_remote_state.management_network_deployment_1.outputs.subnet_ids[var.subnet_tools_name]
  network_security_group_id = azurerm_network_security_group.nsg_tools.id
}