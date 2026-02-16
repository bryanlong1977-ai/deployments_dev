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

# Provider for Management subscription (for Log Analytics)
provider "azurerm" {
  alias           = "management"
  features {}
  subscription_id = var.management_subscription_id
}

# Local values for tags
locals {
  tags = merge(var.tags, {
    customer      = var.customer_name
    project       = var.project_name
    environment   = var.environment
    deployment_id = var.deployment_id
  })
}

# Data source for existing Identity VNet from Network Deployment 1
data "azurerm_virtual_network" "identity_vnet" {
  name                = data.terraform_remote_state.identity_network_deployment_1.outputs.vnet_name
  resource_group_name = data.terraform_remote_state.identity_network_deployment_1.outputs.resource_group_name
}

# Data source for existing Network Watcher from Identity Network Deployment 1
data "azurerm_network_watcher" "identity_nw" {
  name                = data.terraform_remote_state.identity_network_deployment_1.outputs.network_watcher_name
  resource_group_name = data.terraform_remote_state.identity_network_deployment_1.outputs.network_watcher_resource_group_name
}

# Data source for Log Analytics Workspace in Management Subscription
data "azurerm_log_analytics_workspace" "management_law" {
  provider            = azurerm.management
  name                = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_name
  resource_group_name = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_resource_group_name
}

# Data source for Network Storage Account from Identity Tools Deployment 1
data "azurerm_storage_account" "identity_network_storage" {
  name                = data.terraform_remote_state.identity_tools_deployment_1.outputs.network_storage_account_name
  resource_group_name = data.terraform_remote_state.identity_tools_deployment_1.outputs.storage_resource_group_name
}

# Diagnostic Settings for Identity VNet
resource "azurerm_monitor_diagnostic_setting" "identity_vnet_diag" {
  name                       = var.vnet_diagnostic_setting_name
  target_resource_id         = data.azurerm_virtual_network.identity_vnet.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.management_law.id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  metric {
    category = "AllMetrics"
    enabled  = var.enable_metrics
  }
}

# Virtual Network Flow Log for Identity VNet
resource "azurerm_network_watcher_flow_log" "identity_vnet_flow_log" {
  name                 = var.vnet_flow_log_name
  network_watcher_name = data.azurerm_network_watcher.identity_nw.name
  resource_group_name  = data.azurerm_network_watcher.identity_nw.resource_group_name
  target_resource_id   = data.azurerm_virtual_network.identity_vnet.id
  storage_account_id   = data.azurerm_storage_account.identity_network_storage.id
  enabled              = var.flow_log_enabled
  version              = var.flow_log_version

  retention_policy {
    enabled = var.flow_log_retention_enabled
    days    = var.flow_log_retention_days
  }

  traffic_analytics {
    enabled               = var.traffic_analytics_enabled
    workspace_id          = data.azurerm_log_analytics_workspace.management_law.workspace_id
    workspace_region      = data.azurerm_log_analytics_workspace.management_law.location
    workspace_resource_id = data.azurerm_log_analytics_workspace.management_law.id
    interval_in_minutes   = var.traffic_analytics_interval
  }

  tags = local.tags
}