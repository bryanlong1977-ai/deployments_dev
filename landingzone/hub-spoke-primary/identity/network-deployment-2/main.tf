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

# Local values for common configuration
locals {
  tags = {
    customer      = var.customer
    project       = var.project
    environment   = var.environment
    deployment_id = var.deployment_id
    managed_by    = "terraform"
  }
}

# Diagnostic setting for Identity VNet
resource "azurerm_monitor_diagnostic_setting" "vnet_diagnostics" {
  name                       = var.vnet_diagnostic_setting_name
  target_resource_id         = data.terraform_remote_state.identity_network_deployment_1.outputs.vnet_id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Virtual Network Flow Log for Identity VNet
resource "azurerm_network_watcher_flow_log" "vnet_flow_log" {
  name                 = var.vnet_flow_log_name
  network_watcher_name = data.terraform_remote_state.identity_network_deployment_1.outputs.network_watcher_name
  resource_group_name  = data.terraform_remote_state.identity_network_deployment_1.outputs.network_watcher_resource_group_name
  target_resource_id   = data.terraform_remote_state.identity_network_deployment_1.outputs.vnet_id
  storage_account_id   = data.terraform_remote_state.identity_tools_deployment_1.outputs.network_storage_account_id
  enabled              = var.flow_log_enabled
  version              = var.flow_log_version

  retention_policy {
    enabled = var.flow_log_retention_enabled
    days    = var.flow_log_retention_days
  }

  traffic_analytics {
    enabled               = var.traffic_analytics_enabled
    workspace_id          = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_workspace_id
    workspace_region      = var.management_region
    workspace_resource_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id
    interval_in_minutes   = var.traffic_analytics_interval
  }

  tags = local.tags
}