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
# Diagnostic Setting for Identity VNet
# =============================================================================
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "diag-${var.identity_vnet_name}"
  target_resource_id         = data.terraform_remote_state.identity_network_deployment_1.outputs.vnet_id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }

  enabled_log {
    category = "VMProtectionAlerts"
  }
}

# =============================================================================
# Virtual Network Flow Log for Identity VNet
# =============================================================================
resource "azurerm_network_watcher_flow_log" "this" {
  name                 = "flowlog-${var.identity_vnet_name}"
  network_watcher_id   = data.terraform_remote_state.connectivity_network_deployment_1.outputs.network_watcher_id
  target_resource_id   = data.terraform_remote_state.identity_network_deployment_1.outputs.vnet_id
  storage_account_id   = data.terraform_remote_state.management_tools_deployment_1.outputs.storage_account_id
  enabled              = true
  version              = 2

  retention_policy {
    enabled = true
    days    = 90
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_guid
    workspace_resource_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id
    workspace_region      = var.region
    interval_in_minutes   = 10
  }

  tags = var.tags
}
