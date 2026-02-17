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

# Provider for Identity subscription (DNS zones and resolver)
provider "azurerm" {
  alias           = "identity"
  features {}
  subscription_id = var.identity_subscription_id
}

# Provider for Connectivity subscription (storage account for flow logs)
provider "azurerm" {
  alias           = "connectivity"
  features {}
  subscription_id = var.connectivity_subscription_id
}

#--------------------------------------------------------------
# Data Sources - Reference existing resources from remote state
#--------------------------------------------------------------

# Get VNet from Network Deployment 1 (Management)
locals {
  mgmt_vnet_id              = data.terraform_remote_state.management_network_deployment_1.outputs.vnet_id
  mgmt_vnet_name            = data.terraform_remote_state.management_network_deployment_1.outputs.vnet_name
  mgmt_resource_group_name  = data.terraform_remote_state.management_network_deployment_1.outputs.resource_group_name
  mgmt_network_watcher_name = data.terraform_remote_state.management_network_deployment_1.outputs.network_watcher_name
  mgmt_network_watcher_rg   = data.terraform_remote_state.management_network_deployment_1.outputs.network_watcher_resource_group_name
}

# Get Log Analytics Workspace from Management Tools Deployment 1
locals {
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id
}

# Get Network Storage Account from Connectivity Tools Deployment 1
locals {
  network_storage_account_id = data.terraform_remote_state.connectivity_tools_deployment_1.outputs.network_storage_account_id
}

# Get DNS resources from Identity Network Deployment 1
locals {
  private_dns_zone_ids          = data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids
  dns_forwarding_ruleset_id     = data.terraform_remote_state.identity_network_deployment_1.outputs.dns_forwarding_ruleset_id
}

#--------------------------------------------------------------
# Diagnostic Settings for Management VNet
#--------------------------------------------------------------

resource "azurerm_monitor_diagnostic_setting" "mgmt_vnet_diagnostics" {
  name                       = var.vnet_diagnostic_setting_name
  target_resource_id         = local.mgmt_vnet_id
  log_analytics_workspace_id = local.log_analytics_workspace_id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  metric {
    category = "AllMetrics"
    enabled  = var.enable_metrics
  }
}

#--------------------------------------------------------------
# Private DNS Zone Virtual Network Links
#--------------------------------------------------------------

resource "azurerm_private_dns_zone_virtual_network_link" "mgmt_vnet_dns_links" {
  provider = azurerm.identity
  for_each = var.private_dns_zones

  name                  = "vnetlink-${var.vnet_name}-${replace(each.value, ".", "-")}"
  resource_group_name   = var.dns_resource_group_name
  private_dns_zone_name = each.value
  virtual_network_id    = local.mgmt_vnet_id
  registration_enabled  = var.dns_registration_enabled

  tags = var.tags
}

#--------------------------------------------------------------
# DNS Forwarding Ruleset Virtual Network Link
#--------------------------------------------------------------

resource "azurerm_private_dns_resolver_virtual_network_link" "mgmt_vnet_dns_resolver_link" {
  provider = azurerm.identity

  name                      = var.dns_resolver_vnet_link_name
  dns_forwarding_ruleset_id = local.dns_forwarding_ruleset_id
  virtual_network_id        = local.mgmt_vnet_id

  metadata = var.tags
}

#--------------------------------------------------------------
# Virtual Network Flow Logs
#--------------------------------------------------------------

resource "azurerm_network_watcher_flow_log" "mgmt_vnet_flow_log" {
  name                 = var.vnet_flow_log_name
  network_watcher_name = local.mgmt_network_watcher_name
  resource_group_name  = local.mgmt_network_watcher_rg
  target_resource_id   = local.mgmt_vnet_id
  storage_account_id   = local.network_storage_account_id
  enabled              = var.flow_log_enabled
  version              = var.flow_log_version

  retention_policy {
    enabled = var.flow_log_retention_enabled
    days    = var.flow_log_retention_days
  }

  traffic_analytics {
    enabled               = var.traffic_analytics_enabled
    workspace_id          = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_workspace_id
    workspace_region      = var.region
    workspace_resource_id = local.log_analytics_workspace_id
    interval_in_minutes   = var.traffic_analytics_interval
  }

  tags = var.tags
}