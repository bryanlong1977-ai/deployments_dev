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

provider "azurerm" {
  alias           = "management"
  features {}
  subscription_id = var.management_subscription_id
}

provider "azurerm" {
  alias           = "identity"
  features {}
  subscription_id = var.identity_subscription_id
}

# Local values for common configurations
locals {
  tags = {
    customer      = var.customer_name
    project       = var.project_name
    environment   = var.environment
    deployment_id = var.deployment_id
    deployed_by   = "terraform"
  }
}

#------------------------------------------------------------------------------
# Resource Group for NAT Gateway
#------------------------------------------------------------------------------
resource "azurerm_resource_group" "natgw" {
  name     = var.nat_gateway_resource_group_name
  location = var.region
  tags     = local.tags
}

#------------------------------------------------------------------------------
# Resource Group for ExpressRoute Gateway
#------------------------------------------------------------------------------
resource "azurerm_resource_group" "ergw" {
  name     = var.expressroute_gateway_resource_group_name
  location = var.region
  tags     = local.tags
}

#------------------------------------------------------------------------------
# Public IP Prefix for NAT Gateway
#------------------------------------------------------------------------------
resource "azurerm_public_ip_prefix" "natgw" {
  name                = var.public_ip_prefix_name
  location            = var.region
  resource_group_name = azurerm_resource_group.natgw.name
  prefix_length       = var.public_ip_prefix_length
  sku                 = var.public_ip_prefix_sku
  zones               = var.public_ip_prefix_zones
  tags                = local.tags
}

#------------------------------------------------------------------------------
# NAT Gateway
#------------------------------------------------------------------------------
resource "azurerm_nat_gateway" "hub" {
  name                    = var.nat_gateway_name
  location                = var.region
  resource_group_name     = azurerm_resource_group.natgw.name
  sku_name                = var.nat_gateway_sku
  idle_timeout_in_minutes = var.nat_gateway_idle_timeout
  zones                   = var.nat_gateway_zones
  tags                    = local.tags
}

#------------------------------------------------------------------------------
# NAT Gateway Public IP Prefix Association
#------------------------------------------------------------------------------
resource "azurerm_nat_gateway_public_ip_prefix_association" "natgw" {
  nat_gateway_id      = azurerm_nat_gateway.hub.id
  public_ip_prefix_id = azurerm_public_ip_prefix.natgw.id
}

#------------------------------------------------------------------------------
# NAT Gateway Subnet Association - Firewall Untrust Subnet
#------------------------------------------------------------------------------
resource "azurerm_subnet_nat_gateway_association" "fw_untrust" {
  subnet_id      = data.terraform_remote_state.connectivity_network_1.outputs.subnet_ids["snet-fw-untrust-hub-eus2-01"]
  nat_gateway_id = azurerm_nat_gateway.hub.id
}

#------------------------------------------------------------------------------
# Public IP for ExpressRoute Gateway
#------------------------------------------------------------------------------
resource "azurerm_public_ip" "ergw" {
  name                = var.expressroute_gateway_pip_name
  location            = var.region
  resource_group_name = azurerm_resource_group.ergw.name
  allocation_method   = var.expressroute_gateway_pip_allocation_method
  sku                 = var.expressroute_gateway_pip_sku
  zones               = var.expressroute_gateway_pip_zones
  tags                = local.tags
}

#------------------------------------------------------------------------------
# ExpressRoute Gateway
#------------------------------------------------------------------------------
resource "azurerm_virtual_network_gateway" "expressroute" {
  name                = var.expressroute_gateway_name
  location            = var.region
  resource_group_name = azurerm_resource_group.ergw.name

  type     = "ExpressRoute"
  vpn_type = "RouteBased"
  sku      = var.expressroute_gateway_sku

  active_active = var.expressroute_gateway_active_active
  enable_bgp    = var.expressroute_gateway_enable_bgp

  ip_configuration {
    name                          = var.expressroute_gateway_ip_config_name
    public_ip_address_id          = azurerm_public_ip.ergw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.terraform_remote_state.connectivity_network_1.outputs.subnet_ids["GatewaySubnet"]
  }

  tags = local.tags
}

#------------------------------------------------------------------------------
# Diagnostic Settings for NAT Gateway
#------------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "natgw" {
  name                       = var.nat_gateway_diagnostic_setting_name
  target_resource_id         = azurerm_nat_gateway.hub.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

#------------------------------------------------------------------------------
# Diagnostic Settings for Public IP Prefix
#------------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "pip_prefix" {
  name                       = var.public_ip_prefix_diagnostic_setting_name
  target_resource_id         = azurerm_public_ip_prefix.natgw.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

#------------------------------------------------------------------------------
# Diagnostic Settings for ExpressRoute Gateway Public IP
#------------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "ergw_pip" {
  name                       = var.expressroute_gateway_pip_diagnostic_setting_name
  target_resource_id         = azurerm_public_ip.ergw.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "DDoSProtectionNotifications"
  }

  enabled_log {
    category = "DDoSMitigationFlowLogs"
  }

  enabled_log {
    category = "DDoSMitigationReports"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

#------------------------------------------------------------------------------
# Diagnostic Settings for ExpressRoute Gateway
#------------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "ergw" {
  name                       = var.expressroute_gateway_diagnostic_setting_name
  target_resource_id         = azurerm_virtual_network_gateway.expressroute.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "GatewayDiagnosticLog"
  }

  enabled_log {
    category = "TunnelDiagnosticLog"
  }

  enabled_log {
    category = "RouteDiagnosticLog"
  }

  enabled_log {
    category = "IKEDiagnosticLog"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

#------------------------------------------------------------------------------
# Diagnostic Settings for Hub VNet (from Network Deployment 1)
#------------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "hub_vnet" {
  name                       = var.hub_vnet_diagnostic_setting_name
  target_resource_id         = data.terraform_remote_state.connectivity_network_1.outputs.vnet_id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

#------------------------------------------------------------------------------
# Virtual Network Flow Log for Hub VNet
#------------------------------------------------------------------------------
resource "azurerm_network_watcher_flow_log" "hub_vnet" {
  name                 = var.hub_vnet_flow_log_name
  network_watcher_name = data.terraform_remote_state.connectivity_network_1.outputs.network_watcher_name
  resource_group_name  = data.terraform_remote_state.connectivity_network_1.outputs.network_watcher_resource_group_name
  target_resource_id   = data.terraform_remote_state.connectivity_network_1.outputs.vnet_id
  storage_account_id   = data.terraform_remote_state.connectivity_tools_1.outputs.network_storage_account_id
  enabled              = var.flow_log_enabled
  version              = var.flow_log_version

  retention_policy {
    enabled = var.flow_log_retention_enabled
    days    = var.flow_log_retention_days
  }

  traffic_analytics {
    enabled               = var.traffic_analytics_enabled
    workspace_id          = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_workspace_id
    workspace_region      = var.region
    workspace_resource_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id
    interval_in_minutes   = var.traffic_analytics_interval
  }

  tags = local.tags
}

#------------------------------------------------------------------------------
# Private DNS Zone Links to Hub VNet
#------------------------------------------------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "hub_vnet_links" {
  for_each = toset(var.private_dns_zones)

  name                  = "link-${var.vnet_name}-${replace(each.value, ".", "-")}"
  resource_group_name   = data.terraform_remote_state.identity_network_1.outputs.dns_resource_group_name
  private_dns_zone_name = each.value
  virtual_network_id    = data.terraform_remote_state.connectivity_network_1.outputs.vnet_id
  registration_enabled  = false

  tags = local.tags

  provider = azurerm.identity
}

#------------------------------------------------------------------------------
# DNS Forwarding Ruleset Link to Hub VNet
#------------------------------------------------------------------------------
resource "azurerm_private_dns_resolver_virtual_network_link" "hub_vnet" {
  name                      = "link-${var.vnet_name}"
  dns_forwarding_ruleset_id = data.terraform_remote_state.identity_network_1.outputs.dns_forwarding_ruleset_id
  virtual_network_id        = data.terraform_remote_state.connectivity_network_1.outputs.vnet_id
}