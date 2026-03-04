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
# Diagnostic Settings for Hub VNet
# =============================================================================
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "diag-${var.connectivity_vnet_name}"
  target_resource_id         = data.terraform_remote_state.connectivity_network_1.outputs.vnet_id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }
}

# =============================================================================
# Virtual Network Flow Log for Hub VNet
# =============================================================================
resource "azurerm_network_watcher_flow_log" "this" {
  name                 = "flowlog-${var.connectivity_vnet_name}"
  network_watcher_id   = data.terraform_remote_state.connectivity_network_1.outputs.network_watcher_id
  target_resource_id   = data.terraform_remote_state.connectivity_network_1.outputs.vnet_id
  storage_account_id   = data.terraform_remote_state.management_tools_1.outputs.storage_account_id
  enabled              = true
  version              = 2

  retention_policy {
    enabled = true
    days    = 90
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_guid
    workspace_resource_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id
    workspace_region      = var.region
    interval_in_minutes   = 10
  }
}

# =============================================================================
# Link Hub VNet to Private DNS Zones from Identity Subscription
# =============================================================================
resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_links" {
  for_each              = toset(var.private_dns_zones)
  name                  = "link-${var.connectivity_vnet_name}-${replace(each.value, ".", "-")}"
  resource_group_name   = var.dns_resource_group
  private_dns_zone_name = each.value
  virtual_network_id    = data.terraform_remote_state.connectivity_network_1.outputs.vnet_id
  registration_enabled  = false

  tags = var.tags
}
