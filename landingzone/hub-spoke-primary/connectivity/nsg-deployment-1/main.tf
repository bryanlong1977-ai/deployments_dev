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
  subscription_id = var.connectivity_subscription_id
}

# =============================================================================
# Resource Group for NSGs
# =============================================================================
resource "azurerm_resource_group" "this" {
  name     = var.connectivity_nsg_resource_group
  location = var.region
  tags     = var.tags
}

# =============================================================================
# Network Security Groups - one per subnet (using for_each)
# =============================================================================
resource "azurerm_network_security_group" "nsgs" {
  for_each            = var.connectivity_nsg_names
  name                = each.value
  location            = var.region
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

# =============================================================================
# NSG-to-Subnet Associations
# =============================================================================
resource "azurerm_subnet_network_security_group_association" "nsgs" {
  for_each                  = var.connectivity_nsg_names
  subnet_id                 = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids[each.key]
  network_security_group_id = azurerm_network_security_group.nsgs[each.key].id
}

# =============================================================================
# Default Deny Inbound Rules - Priority 4096
# =============================================================================
resource "azurerm_network_security_rule" "deny_all_inbound" {
  for_each                    = var.connectivity_nsg_names
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
# Default Deny Outbound Rules - Priority 4096
# =============================================================================
resource "azurerm_network_security_rule" "deny_all_outbound" {
  for_each                    = var.connectivity_nsg_names
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
# Allow VNet-to-VNet Inbound - Priority 100
# =============================================================================
resource "azurerm_network_security_rule" "allow_vnet_inbound" {
  for_each                    = var.connectivity_nsg_names
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
# Allow Azure Load Balancer Inbound - Priority 110
# =============================================================================
resource "azurerm_network_security_rule" "allow_azure_lb_inbound" {
  for_each                    = var.connectivity_nsg_names
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
# Allow VNet-to-VNet Outbound - Priority 100
# =============================================================================
resource "azurerm_network_security_rule" "allow_vnet_outbound" {
  for_each                    = var.connectivity_nsg_names
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
# Allow HTTPS Outbound to Internet - Priority 110
# =============================================================================
resource "azurerm_network_security_rule" "allow_https_outbound" {
  for_each                    = var.connectivity_nsg_names
  name                        = "AllowHTTPSOutbound"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[each.key].name
}

# =============================================================================
# Allow Azure Storage Outbound - Priority 120
# =============================================================================
resource "azurerm_network_security_rule" "allow_storage_outbound" {
  for_each                    = var.connectivity_nsg_names
  name                        = "AllowAzureStorageOutbound"
  priority                    = 120
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Storage"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[each.key].name
}

# =============================================================================
# Allow Azure Monitor Outbound - Priority 130
# =============================================================================
resource "azurerm_network_security_rule" "allow_azure_monitor_outbound" {
  for_each                    = var.connectivity_nsg_names
  name                        = "AllowAzureMonitorOutbound"
  priority                    = 130
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "AzureMonitor"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.nsgs[each.key].name
}