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

# Resource Group for NAT Gateway
resource "azurerm_resource_group" "nat_gateway_rg" {
  name     = var.nat_gateway_resource_group_name
  location = var.region
  tags     = var.tags
}

# Resource Group for ExpressRoute Gateway (using hub network RG from remote state)
# The GatewaySubnet is in the hub network resource group

# Public IP Prefix for NAT Gateway
resource "azurerm_public_ip_prefix" "nat_gateway_pip_prefix" {
  name                = var.public_ip_prefix_name
  location            = var.region
  resource_group_name = azurerm_resource_group.nat_gateway_rg.name
  prefix_length       = var.public_ip_prefix_length
  sku                 = var.public_ip_prefix_sku
  zones               = var.availability_zones
  tags                = var.tags
}

# NAT Gateway
resource "azurerm_nat_gateway" "hub_nat_gateway" {
  name                    = var.nat_gateway_name
  location                = var.region
  resource_group_name     = azurerm_resource_group.nat_gateway_rg.name
  sku_name                = var.nat_gateway_sku
  idle_timeout_in_minutes = var.nat_gateway_idle_timeout
  zones                   = var.availability_zones
  tags                    = var.tags
}

# Associate Public IP Prefix with NAT Gateway
resource "azurerm_nat_gateway_public_ip_prefix_association" "nat_gateway_pip_prefix_assoc" {
  nat_gateway_id      = azurerm_nat_gateway.hub_nat_gateway.id
  public_ip_prefix_id = azurerm_public_ip_prefix.nat_gateway_pip_prefix.id
}

# Associate NAT Gateway with Firewall Untrust Subnet
resource "azurerm_subnet_nat_gateway_association" "fw_untrust_nat_assoc" {
  subnet_id      = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-fw-untrust-hub-wus3-01"]
  nat_gateway_id = azurerm_nat_gateway.hub_nat_gateway.id
}

# Public IP for ExpressRoute Gateway
resource "azurerm_public_ip" "expressroute_gateway_pip" {
  name                = var.expressroute_gateway_pip_name
  location            = var.region
  resource_group_name = data.terraform_remote_state.connectivity_network_deployment_1.outputs.resource_group_name
  allocation_method   = var.expressroute_gateway_pip_allocation_method
  sku                 = var.expressroute_gateway_pip_sku
  zones               = var.availability_zones
  tags                = var.tags
}

# ExpressRoute Gateway
resource "azurerm_virtual_network_gateway" "expressroute_gateway" {
  name                = var.expressroute_gateway_name
  location            = var.region
  resource_group_name = data.terraform_remote_state.connectivity_network_deployment_1.outputs.resource_group_name
  type                = "ExpressRoute"
  sku                 = var.expressroute_gateway_sku
  tags                = var.tags

  ip_configuration {
    name                          = var.expressroute_gateway_ip_config_name
    public_ip_address_id          = azurerm_public_ip.expressroute_gateway_pip.id
    private_ip_address_allocation = var.expressroute_gateway_private_ip_allocation
    subnet_id                     = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["GatewaySubnet"]
  }
}

# Resource Group for External Load Balancer
resource "azurerm_resource_group" "external_lb_rg" {
  name     = var.external_lb_resource_group_name
  location = var.region
  tags     = var.tags
}

# Public IP Prefix for External Load Balancer
resource "azurerm_public_ip_prefix" "external_lb_pip_prefix" {
  name                = var.external_lb_pip_prefix_name
  location            = var.region
  resource_group_name = azurerm_resource_group.external_lb_rg.name
  prefix_length       = var.external_lb_pip_prefix_length
  sku                 = var.external_lb_pip_prefix_sku
  zones               = var.availability_zones
  tags                = var.tags
}

# Public IP for External Load Balancer (from prefix)
resource "azurerm_public_ip" "external_lb_pip" {
  name                = var.external_lb_pip_name
  location            = var.region
  resource_group_name = azurerm_resource_group.external_lb_rg.name
  allocation_method   = var.external_lb_pip_allocation_method
  sku                 = var.external_lb_pip_sku
  public_ip_prefix_id = azurerm_public_ip_prefix.external_lb_pip_prefix.id
  zones               = var.availability_zones
  tags                = var.tags
}

# External Load Balancer
resource "azurerm_lb" "external_lb" {
  name                = var.external_lb_name
  location            = var.region
  resource_group_name = azurerm_resource_group.external_lb_rg.name
  sku                 = var.external_lb_sku
  sku_tier            = var.external_lb_sku_tier
  tags                = var.tags

  frontend_ip_configuration {
    name                 = var.external_lb_frontend_ip_config_name
    public_ip_address_id = azurerm_public_ip.external_lb_pip.id
  }
}

# External Load Balancer Backend Address Pool
resource "azurerm_lb_backend_address_pool" "external_lb_backend_pool" {
  loadbalancer_id = azurerm_lb.external_lb.id
  name            = var.external_lb_backend_pool_name
}

# Diagnostic Settings for NAT Gateway
resource "azurerm_monitor_diagnostic_setting" "nat_gateway_diag" {
  name                       = var.nat_gateway_diagnostic_setting_name
  target_resource_id         = azurerm_nat_gateway.hub_nat_gateway.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Diagnostic Settings for ExpressRoute Gateway
resource "azurerm_monitor_diagnostic_setting" "expressroute_gateway_diag" {
  name                       = var.expressroute_gateway_diagnostic_setting_name
  target_resource_id         = azurerm_virtual_network_gateway.expressroute_gateway.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

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

# Diagnostic Settings for External Load Balancer
resource "azurerm_monitor_diagnostic_setting" "external_lb_diag" {
  name                       = var.external_lb_diagnostic_setting_name
  target_resource_id         = azurerm_lb.external_lb.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "LoadBalancerAlertEvent"
  }

  enabled_log {
    category = "LoadBalancerProbeHealthStatus"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Diagnostic Settings for Public IP Prefix (NAT Gateway)
resource "azurerm_monitor_diagnostic_setting" "nat_pip_prefix_diag" {
  name                       = var.nat_pip_prefix_diagnostic_setting_name
  target_resource_id         = azurerm_public_ip_prefix.nat_gateway_pip_prefix.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Diagnostic Settings for ExpressRoute Gateway Public IP
resource "azurerm_monitor_diagnostic_setting" "expressroute_pip_diag" {
  name                       = var.expressroute_pip_diagnostic_setting_name
  target_resource_id         = azurerm_public_ip.expressroute_gateway_pip.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

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

# Diagnostic Settings for Virtual Network (from Network Deployment 1)
resource "azurerm_monitor_diagnostic_setting" "vnet_diag" {
  name                       = var.vnet_diagnostic_setting_name
  target_resource_id         = data.terraform_remote_state.connectivity_network_deployment_1.outputs.vnet_id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Virtual Network Flow Logs
resource "azurerm_network_watcher_flow_log" "vnet_flow_log" {
  name                 = var.vnet_flow_log_name
  network_watcher_name = data.terraform_remote_state.connectivity_network_deployment_1.outputs.network_watcher_name
  resource_group_name  = data.terraform_remote_state.connectivity_network_deployment_1.outputs.network_watcher_resource_group_name
  target_resource_id   = data.terraform_remote_state.connectivity_network_deployment_1.outputs.vnet_id
  storage_account_id   = data.terraform_remote_state.connectivity_tools_deployment_1.outputs.network_storage_account_id
  enabled              = var.vnet_flow_log_enabled
  version              = var.vnet_flow_log_version

  retention_policy {
    enabled = var.vnet_flow_log_retention_enabled
    days    = var.vnet_flow_log_retention_days
  }

  traffic_analytics {
    enabled               = var.traffic_analytics_enabled
    workspace_id          = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_workspace_id
    workspace_region      = var.region
    workspace_resource_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id
    interval_in_minutes   = var.traffic_analytics_interval
  }

  tags = var.tags
}

# Link Hub VNet to DNS Forwarding Ruleset
resource "azurerm_private_dns_resolver_virtual_network_link" "hub_dns_link" {
  name                      = var.hub_dns_vnet_link_name
  dns_forwarding_ruleset_id = data.terraform_remote_state.identity_network_deployment_1.outputs.dns_forwarding_ruleset_id
  virtual_network_id        = data.terraform_remote_state.connectivity_network_deployment_1.outputs.vnet_id
}

# Link Hub VNet to Private DNS Zones
resource "azurerm_private_dns_zone_virtual_network_link" "hub_dns_zone_links" {
  for_each = toset(var.private_dns_zones)

  name                  = "link-hub-${replace(each.value, ".", "-")}"
  resource_group_name   = data.terraform_remote_state.identity_network_deployment_1.outputs.dns_resource_group_name
  private_dns_zone_name = each.value
  virtual_network_id    = data.terraform_remote_state.connectivity_network_deployment_1.outputs.vnet_id
  registration_enabled  = var.dns_zone_registration_enabled
  tags                  = var.tags
}