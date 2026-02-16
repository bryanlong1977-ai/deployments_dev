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

# Data source for current client configuration
data "azurerm_client_config" "current" {}

# =============================================================================
# Resource Groups
# =============================================================================

# Resource Group for Azure Monitor Private Link Scope
resource "azurerm_resource_group" "ampls" {
  name     = var.ampls_resource_group_name
  location = var.region
  tags     = var.tags
}

# Resource Group for Storage Accounts
resource "azurerm_resource_group" "storage" {
  name     = var.storage_resource_group_name
  location = var.region
  tags     = var.tags
}

# =============================================================================
# Azure Monitor Private Link Scope
# =============================================================================

resource "azurerm_monitor_private_link_scope" "ampls" {
  name                  = var.ampls_name
  resource_group_name   = azurerm_resource_group.ampls.name
  ingestion_access_mode = var.ampls_ingestion_access_mode
  query_access_mode     = var.ampls_query_access_mode
  tags                  = var.tags
}

# Link AMPLS to Log Analytics Workspace in Management Subscription
resource "azurerm_monitor_private_link_scoped_service" "law" {
  name                = "scoped-service-law"
  resource_group_name = azurerm_resource_group.ampls.name
  scope_name          = azurerm_monitor_private_link_scope.ampls.name
  linked_resource_id  = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id
}

# Private Endpoint for Azure Monitor Private Link Scope
resource "azurerm_private_endpoint" "ampls" {
  name                = "pep-${var.ampls_name}"
  location            = var.region
  resource_group_name = azurerm_resource_group.ampls.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.ampls_name}"
    private_connection_resource_id = azurerm_monitor_private_link_scope.ampls.id
    subresource_names              = ["azuremonitor"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "dns-zone-group-ampls"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.monitor.azure.com"],
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.oms.opinsights.azure.com"],
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.ods.opinsights.azure.com"],
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.agentsvc.azure-automation.net"]
    ]
  }
}

# =============================================================================
# Storage Accounts
# =============================================================================

# VM Storage Account
resource "azurerm_storage_account" "vm" {
  name                            = var.storage_account_vm_name
  resource_group_name             = azurerm_resource_group.storage.name
  location                        = var.region
  account_tier                    = var.storage_account_tier
  account_replication_type        = var.storage_account_replication_type
  account_kind                    = var.storage_account_kind
  min_tls_version                 = var.storage_min_tls_version
  allow_nested_items_to_be_public = var.storage_allow_nested_items_to_be_public
  public_network_access_enabled   = var.storage_public_network_access_enabled
  tags                            = var.tags

  blob_properties {
    delete_retention_policy {
      days = var.storage_blob_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_container_delete_retention_days
    }
  }
}

# Network Storage Account
resource "azurerm_storage_account" "ntwk" {
  name                            = var.storage_account_ntwk_name
  resource_group_name             = azurerm_resource_group.storage.name
  location                        = var.region
  account_tier                    = var.storage_account_tier
  account_replication_type        = var.storage_account_replication_type
  account_kind                    = var.storage_account_kind
  min_tls_version                 = var.storage_min_tls_version
  allow_nested_items_to_be_public = var.storage_allow_nested_items_to_be_public
  public_network_access_enabled   = var.storage_public_network_access_enabled
  tags                            = var.tags

  blob_properties {
    delete_retention_policy {
      days = var.storage_blob_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_container_delete_retention_days
    }
  }
}

# =============================================================================
# Private Endpoints for Storage Accounts
# =============================================================================

# VM Storage Account - Blob Private Endpoint
resource "azurerm_private_endpoint" "vm_blob" {
  name                = "pep-${var.storage_account_vm_name}-blob"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-blob"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-zone-group-blob"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
  }
}

# VM Storage Account - File Private Endpoint
resource "azurerm_private_endpoint" "vm_file" {
  name                = "pep-${var.storage_account_vm_name}-file"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-file"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-zone-group-file"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"]]
  }
}

# VM Storage Account - Queue Private Endpoint
resource "azurerm_private_endpoint" "vm_queue" {
  name                = "pep-${var.storage_account_vm_name}-queue"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-queue"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-zone-group-queue"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"]]
  }
}

# VM Storage Account - Table Private Endpoint
resource "azurerm_private_endpoint" "vm_table" {
  name                = "pep-${var.storage_account_vm_name}-table"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-table"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-zone-group-table"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"]]
  }
}

# Network Storage Account - Blob Private Endpoint
resource "azurerm_private_endpoint" "ntwk_blob" {
  name                = "pep-${var.storage_account_ntwk_name}-blob"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-blob"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-zone-group-blob"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
  }
}

# Network Storage Account - File Private Endpoint
resource "azurerm_private_endpoint" "ntwk_file" {
  name                = "pep-${var.storage_account_ntwk_name}-file"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-file"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-zone-group-file"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"]]
  }
}

# Network Storage Account - Queue Private Endpoint
resource "azurerm_private_endpoint" "ntwk_queue" {
  name                = "pep-${var.storage_account_ntwk_name}-queue"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-queue"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-zone-group-queue"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"]]
  }
}

# Network Storage Account - Table Private Endpoint
resource "azurerm_private_endpoint" "ntwk_table" {
  name                = "pep-${var.storage_account_ntwk_name}-table"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-table"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-zone-group-table"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"]]
  }
}

# =============================================================================
# Diagnostic Settings for Storage Accounts
# =============================================================================

# VM Storage Account - Blob Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "vm_blob" {
  name                       = "diag-${var.storage_account_vm_name}-blob"
  target_resource_id         = "${azurerm_storage_account.vm.id}/blobServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }
  enabled_log {
    category = "StorageWrite"
  }
  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# VM Storage Account - File Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "vm_file" {
  name                       = "diag-${var.storage_account_vm_name}-file"
  target_resource_id         = "${azurerm_storage_account.vm.id}/fileServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }
  enabled_log {
    category = "StorageWrite"
  }
  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# VM Storage Account - Queue Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "vm_queue" {
  name                       = "diag-${var.storage_account_vm_name}-queue"
  target_resource_id         = "${azurerm_storage_account.vm.id}/queueServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }
  enabled_log {
    category = "StorageWrite"
  }
  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# VM Storage Account - Table Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "vm_table" {
  name                       = "diag-${var.storage_account_vm_name}-table"
  target_resource_id         = "${azurerm_storage_account.vm.id}/tableServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }
  enabled_log {
    category = "StorageWrite"
  }
  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# Network Storage Account - Blob Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "ntwk_blob" {
  name                       = "diag-${var.storage_account_ntwk_name}-blob"
  target_resource_id         = "${azurerm_storage_account.ntwk.id}/blobServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }
  enabled_log {
    category = "StorageWrite"
  }
  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# Network Storage Account - File Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "ntwk_file" {
  name                       = "diag-${var.storage_account_ntwk_name}-file"
  target_resource_id         = "${azurerm_storage_account.ntwk.id}/fileServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }
  enabled_log {
    category = "StorageWrite"
  }
  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# Network Storage Account - Queue Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "ntwk_queue" {
  name                       = "diag-${var.storage_account_ntwk_name}-queue"
  target_resource_id         = "${azurerm_storage_account.ntwk.id}/queueServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }
  enabled_log {
    category = "StorageWrite"
  }
  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# Network Storage Account - Table Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "ntwk_table" {
  name                       = "diag-${var.storage_account_ntwk_name}-table"
  target_resource_id         = "${azurerm_storage_account.ntwk.id}/tableServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }
  enabled_log {
    category = "StorageWrite"
  }
  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}