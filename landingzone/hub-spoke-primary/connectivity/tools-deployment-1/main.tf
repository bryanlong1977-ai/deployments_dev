# Connectivity Subscription - Tools Deployment 1
# Azure Monitor Private Link Scope and Storage Accounts

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

# Provider for Management subscription (for Log Analytics reference)
provider "azurerm" {
  alias           = "management"
  features {}
  subscription_id = var.management_subscription_id
}

# Provider for Identity subscription (for Private DNS Zone reference)
provider "azurerm" {
  alias           = "identity"
  features {}
  subscription_id = var.identity_subscription_id
}

#--------------------------------------------------------------
# Data Sources
#--------------------------------------------------------------

data "azurerm_client_config" "current" {}

#--------------------------------------------------------------
# Resource Groups
#--------------------------------------------------------------

# Resource Group for Azure Monitor Private Link Scope
resource "azurerm_resource_group" "ampls_rg" {
  name     = var.ampls_resource_group_name
  location = var.region
  tags     = var.tags
}

# Resource Group for Storage Accounts
resource "azurerm_resource_group" "storage_rg" {
  name     = var.storage_resource_group_name
  location = var.region
  tags     = var.tags
}

#--------------------------------------------------------------
# Azure Monitor Private Link Scope
#--------------------------------------------------------------

resource "azurerm_monitor_private_link_scope" "ampls" {
  name                = var.ampls_name
  resource_group_name = azurerm_resource_group.ampls_rg.name
  tags                = var.tags

  ingestion_access_mode = var.ampls_ingestion_access_mode
  query_access_mode     = var.ampls_query_access_mode
}

# Link AMPLS to Log Analytics Workspace in Management Subscription
resource "azurerm_monitor_private_link_scoped_service" "law_link" {
  name                = "ampls-law-link"
  resource_group_name = azurerm_resource_group.ampls_rg.name
  scope_name          = azurerm_monitor_private_link_scope.ampls.name
  linked_resource_id  = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id
}

# Private Endpoint for Azure Monitor Private Link Scope
resource "azurerm_private_endpoint" "ampls_pe" {
  name                = var.ampls_private_endpoint_name
  location            = var.region
  resource_group_name = azurerm_resource_group.ampls_rg.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "${var.ampls_name}-connection"
    private_connection_resource_id = azurerm_monitor_private_link_scope.ampls.id
    subresource_names              = ["azuremonitor"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "ampls-dns-zone-group"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.monitor.azure.com"],
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.oms.opinsights.azure.com"],
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.ods.opinsights.azure.com"],
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.agentsvc.azure-automation.net"]
    ]
  }
}

#--------------------------------------------------------------
# Storage Account - VM Diagnostics
#--------------------------------------------------------------

resource "azurerm_storage_account" "vm_storage" {
  name                          = var.vm_storage_account_name
  resource_group_name           = azurerm_resource_group.storage_rg.name
  location                      = var.region
  account_tier                  = var.storage_account_tier
  account_replication_type      = var.storage_account_replication_type
  account_kind                  = var.storage_account_kind
  min_tls_version               = var.storage_min_tls_version
  public_network_access_enabled = var.storage_public_network_access_enabled
  tags                          = var.tags

  blob_properties {
    delete_retention_policy {
      days = var.blob_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.container_delete_retention_days
    }
  }

  network_rules {
    default_action = var.storage_network_default_action
    bypass         = var.storage_network_bypass
  }
}

# Private Endpoints for VM Storage Account
resource "azurerm_private_endpoint" "vm_storage_blob_pe" {
  name                = "${var.vm_storage_account_name}-blob-pe"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_rg.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "${var.vm_storage_account_name}-blob-connection"
    private_connection_resource_id = azurerm_storage_account.vm_storage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "blob-dns-zone-group"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
  }
}

resource "azurerm_private_endpoint" "vm_storage_file_pe" {
  name                = "${var.vm_storage_account_name}-file-pe"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_rg.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "${var.vm_storage_account_name}-file-connection"
    private_connection_resource_id = azurerm_storage_account.vm_storage.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "file-dns-zone-group"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"]]
  }
}

resource "azurerm_private_endpoint" "vm_storage_queue_pe" {
  name                = "${var.vm_storage_account_name}-queue-pe"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_rg.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "${var.vm_storage_account_name}-queue-connection"
    private_connection_resource_id = azurerm_storage_account.vm_storage.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "queue-dns-zone-group"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"]]
  }
}

resource "azurerm_private_endpoint" "vm_storage_table_pe" {
  name                = "${var.vm_storage_account_name}-table-pe"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_rg.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "${var.vm_storage_account_name}-table-connection"
    private_connection_resource_id = azurerm_storage_account.vm_storage.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "table-dns-zone-group"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"]]
  }
}

# Diagnostic Settings for VM Storage Account
resource "azurerm_monitor_diagnostic_setting" "vm_storage_diag" {
  name                       = "${var.vm_storage_account_name}-diag"
  target_resource_id         = azurerm_storage_account.vm_storage.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  metric {
    category = "Transaction"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "vm_storage_blob_diag" {
  name                       = "${var.vm_storage_account_name}-blob-diag"
  target_resource_id         = "${azurerm_storage_account.vm_storage.id}/blobServices/default"
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

resource "azurerm_monitor_diagnostic_setting" "vm_storage_file_diag" {
  name                       = "${var.vm_storage_account_name}-file-diag"
  target_resource_id         = "${azurerm_storage_account.vm_storage.id}/fileServices/default"
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

resource "azurerm_monitor_diagnostic_setting" "vm_storage_queue_diag" {
  name                       = "${var.vm_storage_account_name}-queue-diag"
  target_resource_id         = "${azurerm_storage_account.vm_storage.id}/queueServices/default"
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

resource "azurerm_monitor_diagnostic_setting" "vm_storage_table_diag" {
  name                       = "${var.vm_storage_account_name}-table-diag"
  target_resource_id         = "${azurerm_storage_account.vm_storage.id}/tableServices/default"
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

#--------------------------------------------------------------
# Storage Account - Network Diagnostics
#--------------------------------------------------------------

resource "azurerm_storage_account" "ntwk_storage" {
  name                          = var.ntwk_storage_account_name
  resource_group_name           = azurerm_resource_group.storage_rg.name
  location                      = var.region
  account_tier                  = var.storage_account_tier
  account_replication_type      = var.storage_account_replication_type
  account_kind                  = var.storage_account_kind
  min_tls_version               = var.storage_min_tls_version
  public_network_access_enabled = var.storage_public_network_access_enabled
  tags                          = var.tags

  blob_properties {
    delete_retention_policy {
      days = var.blob_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.container_delete_retention_days
    }
  }

  network_rules {
    default_action = var.storage_network_default_action
    bypass         = var.storage_network_bypass
  }
}

# Private Endpoints for Network Storage Account
resource "azurerm_private_endpoint" "ntwk_storage_blob_pe" {
  name                = "${var.ntwk_storage_account_name}-blob-pe"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_rg.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "${var.ntwk_storage_account_name}-blob-connection"
    private_connection_resource_id = azurerm_storage_account.ntwk_storage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "blob-dns-zone-group"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
  }
}

resource "azurerm_private_endpoint" "ntwk_storage_file_pe" {
  name                = "${var.ntwk_storage_account_name}-file-pe"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_rg.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "${var.ntwk_storage_account_name}-file-connection"
    private_connection_resource_id = azurerm_storage_account.ntwk_storage.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "file-dns-zone-group"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"]]
  }
}

resource "azurerm_private_endpoint" "ntwk_storage_queue_pe" {
  name                = "${var.ntwk_storage_account_name}-queue-pe"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_rg.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "${var.ntwk_storage_account_name}-queue-connection"
    private_connection_resource_id = azurerm_storage_account.ntwk_storage.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "queue-dns-zone-group"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"]]
  }
}

resource "azurerm_private_endpoint" "ntwk_storage_table_pe" {
  name                = "${var.ntwk_storage_account_name}-table-pe"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_rg.name
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids["snet-pe-hub-wus3-01"]
  tags                = var.tags

  private_service_connection {
    name                           = "${var.ntwk_storage_account_name}-table-connection"
    private_connection_resource_id = azurerm_storage_account.ntwk_storage.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "table-dns-zone-group"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"]]
  }
}

# Diagnostic Settings for Network Storage Account
resource "azurerm_monitor_diagnostic_setting" "ntwk_storage_diag" {
  name                       = "${var.ntwk_storage_account_name}-diag"
  target_resource_id         = azurerm_storage_account.ntwk_storage.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  metric {
    category = "Transaction"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "ntwk_storage_blob_diag" {
  name                       = "${var.ntwk_storage_account_name}-blob-diag"
  target_resource_id         = "${azurerm_storage_account.ntwk_storage.id}/blobServices/default"
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

resource "azurerm_monitor_diagnostic_setting" "ntwk_storage_file_diag" {
  name                       = "${var.ntwk_storage_account_name}-file-diag"
  target_resource_id         = "${azurerm_storage_account.ntwk_storage.id}/fileServices/default"
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

resource "azurerm_monitor_diagnostic_setting" "ntwk_storage_queue_diag" {
  name                       = "${var.ntwk_storage_account_name}-queue-diag"
  target_resource_id         = "${azurerm_storage_account.ntwk_storage.id}/queueServices/default"
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

resource "azurerm_monitor_diagnostic_setting" "ntwk_storage_table_diag" {
  name                       = "${var.ntwk_storage_account_name}-table-diag"
  target_resource_id         = "${azurerm_storage_account.ntwk_storage.id}/tableServices/default"
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