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

# Provider for Identity subscription (for DNS zone links)
provider "azurerm" {
  alias           = "identity"
  features {}
  subscription_id = var.identity_subscription_id
}

# Provider for Connectivity subscription (for storage account reference)
provider "azurerm" {
  alias           = "connectivity"
  features {}
  subscription_id = var.connectivity_subscription_id
}

#--------------------------------------------------------------
# Local Variables
#--------------------------------------------------------------
locals {
  tags = {
    customer      = var.customer_name
    project       = var.project_name
    environment   = var.environment
    deployment_id = var.deployment_id
    deployed_by   = "terraform"
  }

  # Private DNS zones to link to the Management VNet
  private_dns_zones = var.private_dns_zones
}

#--------------------------------------------------------------
# Data Sources - Reference existing resources
#--------------------------------------------------------------

# Reference the Management VNet from Network Deployment 1
data "azurerm_virtual_network" "mgmt_vnet" {
  name                = data.terraform_remote_state.management_network_deployment_1.outputs.vnet_name
  resource_group_name = data.terraform_remote_state.management_network_deployment_1.outputs.resource_group_name
}

# Reference the Network Watcher from Network Deployment 1
data "azurerm_network_watcher" "mgmt_nw" {
  name                = data.terraform_remote_state.management_network_deployment_1.outputs.network_watcher_name
  resource_group_name = data.terraform_remote_state.management_network_deployment_1.outputs.network_watcher_resource_group_name
}

# Reference the Log Analytics Workspace from Management Tools Deployment 1
data "azurerm_log_analytics_workspace" "mgmt_law" {
  name                = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_name
  resource_group_name = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_resource_group_name
}

# Reference the Network Storage Account from Management Tools Deployment 2
data "azurerm_storage_account" "mgmt_ntwk_sa" {
  name                = data.terraform_remote_state.management_tools_deployment_2.outputs.network_storage_account_name
  resource_group_name = data.terraform_remote_state.management_tools_deployment_2.outputs.storage_account_resource_group_name
}

# Reference the DNS Forwarding Ruleset from Identity Network Deployment 1
data "azurerm_private_dns_resolver_dns_forwarding_ruleset" "identity_ruleset" {
  provider            = azurerm.identity
  name                = data.terraform_remote_state.identity_network_deployment_1.outputs.dns_forwarding_ruleset_name
  resource_group_name = data.terraform_remote_state.identity_network_deployment_1.outputs.dns_resource_group_name
}

# Reference Private DNS Zones from Identity subscription
data "azurerm_private_dns_zone" "zones" {
  provider            = azurerm.identity
  for_each            = toset(local.private_dns_zones)
  name                = each.value
  resource_group_name = data.terraform_remote_state.identity_network_deployment_1.outputs.dns_resource_group_name
}

#--------------------------------------------------------------
# Diagnostic Settings for Management VNet
#--------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "mgmt_vnet_diag" {
  name                       = var.vnet_diagnostic_setting_name
  target_resource_id         = data.azurerm_virtual_network.mgmt_vnet.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.mgmt_law.id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  metric {
    category = "AllMetrics"
    enabled  = var.enable_metrics
  }
}

#--------------------------------------------------------------
# Link Management VNet to DNS Forwarding Ruleset
#--------------------------------------------------------------
resource "azurerm_private_dns_resolver_virtual_network_link" "mgmt_vnet_dns_link" {
  provider                      = azurerm.identity
  name                          = var.dns_ruleset_vnet_link_name
  dns_forwarding_ruleset_id     = data.azurerm_private_dns_resolver_dns_forwarding_ruleset.identity_ruleset.id
  virtual_network_id            = data.azurerm_virtual_network.mgmt_vnet.id
  metadata                      = local.tags
}

#--------------------------------------------------------------
# Link Management VNet to Private DNS Zones
#--------------------------------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "mgmt_vnet_dns_zone_links" {
  provider              = azurerm.identity
  for_each              = toset(local.private_dns_zones)
  name                  = "${var.dns_zone_link_prefix}-${replace(each.value, ".", "-")}"
  resource_group_name   = data.terraform_remote_state.identity_network_deployment_1.outputs.dns_resource_group_name
  private_dns_zone_name = each.value
  virtual_network_id    = data.azurerm_virtual_network.mgmt_vnet.id
  registration_enabled  = var.dns_zone_auto_registration_enabled

  tags = local.tags
}

#--------------------------------------------------------------
# Virtual Network Flow Logs
#--------------------------------------------------------------
resource "azurerm_network_watcher_flow_log" "mgmt_vnet_flow_log" {
  name                 = var.vnet_flow_log_name
  network_watcher_name = data.azurerm_network_watcher.mgmt_nw.name
  resource_group_name  = data.azurerm_network_watcher.mgmt_nw.resource_group_name
  target_resource_id   = data.azurerm_virtual_network.mgmt_vnet.id
  storage_account_id   = data.azurerm_storage_account.mgmt_ntwk_sa.id
  enabled              = var.flow_log_enabled
  version              = var.flow_log_version

  retention_policy {
    enabled = var.flow_log_retention_enabled
    days    = var.flow_log_retention_days
  }

  traffic_analytics {
    enabled               = var.traffic_analytics_enabled
    workspace_id          = data.azurerm_log_analytics_workspace.mgmt_law.workspace_id
    workspace_region      = data.azurerm_log_analytics_workspace.mgmt_law.location
    workspace_resource_id = data.azurerm_log_analytics_workspace.mgmt_law.id
    interval_in_minutes   = var.traffic_analytics_interval_minutes
  }

  tags = local.tags
}