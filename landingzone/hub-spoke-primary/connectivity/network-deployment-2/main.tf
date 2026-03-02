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

# Provider alias for identity subscription (DNS zones are there)
provider "azurerm" {
  alias           = "identity"
  features {}
  subscription_id = var.identity_subscription_id
}

# ============================================
# Diagnostic Settings for Hub VNet
# ============================================
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "diag-${var.connectivity_vnet_name}"
  target_resource_id         = data.terraform_remote_state.connectivity_network_1.outputs.vnet_id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# ============================================
# Private DNS Zone Virtual Network Links
# Link the Hub VNet to all Private DNS Zones in the Identity subscription
# ============================================
resource "azurerm_private_dns_zone_virtual_network_link" "dns_links" {
  provider = azurerm.identity

  for_each = toset(var.private_dns_zones)

  name                  = "vnetlink-${var.connectivity_vnet_name}-${replace(each.key, ".", "-")}"
  resource_group_name   = var.dns_resource_group
  private_dns_zone_name = each.key
  virtual_network_id    = data.terraform_remote_state.connectivity_network_1.outputs.vnet_id
  registration_enabled  = false

  tags = var.tags
}

# ============================================
# Virtual Network Flow Logs
# ============================================
resource "azurerm_network_watcher_flow_log" "this" {
  name                 = "flowlog-${var.connectivity_vnet_name}"
  network_watcher_name = data.terraform_remote_state.connectivity_network_1.outputs.network_watcher_name
  resource_group_name  = data.terraform_remote_state.connectivity_network_1.outputs.network_watcher_resource_group_name
  target_resource_id   = data.terraform_remote_state.connectivity_network_1.outputs.vnet_id
  storage_account_id   = data.terraform_remote_state.connectivity_tools_1.outputs.storage_account_ntwk_id
  enabled              = true
  version              = 2

  retention_policy {
    enabled = true
    days    = 90
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_guid
    workspace_region      = var.region
    workspace_resource_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id
    interval_in_minutes   = 10
  }

  tags = var.tags
}