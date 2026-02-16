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
  features {
    recovery_services_vaults {
      recover_soft_deleted_backup_protected_vm = true
    }
  }
  subscription_id = var.subscription_id
}

# Provider for Identity subscription (for DNS zone links)
provider "azurerm" {
  alias           = "identity"
  features {}
  subscription_id = var.identity_subscription_id
}

# Provider for Management subscription (for Log Analytics)
provider "azurerm" {
  alias           = "management"
  features {}
  subscription_id = var.management_subscription_id
}

#------------------------------------------------------------------------------
# Resource Groups
#------------------------------------------------------------------------------

resource "azurerm_resource_group" "storage" {
  name     = var.storage_resource_group_name
  location = var.region
  tags     = var.tags
}

resource "azurerm_resource_group" "rsv" {
  name     = var.rsv_resource_group_name
  location = var.region
  tags     = var.tags
}

#------------------------------------------------------------------------------
# Storage Accounts
#------------------------------------------------------------------------------

# VM Storage Account
resource "azurerm_storage_account" "vm" {
  name                            = var.storage_account_vm_name
  resource_group_name             = azurerm_resource_group.storage.name
  location                        = azurerm_resource_group.storage.location
  account_tier                    = var.storage_account_tier
  account_replication_type        = var.storage_account_replication_type
  account_kind                    = var.storage_account_kind
  min_tls_version                 = var.storage_min_tls_version
  public_network_access_enabled   = var.storage_public_network_access_enabled
  allow_nested_items_to_be_public = var.storage_allow_nested_items_public
  shared_access_key_enabled       = var.storage_shared_access_key_enabled

  blob_properties {
    delete_retention_policy {
      days = var.blob_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.container_delete_retention_days
    }
  }

  tags = var.tags
}

# Network Storage Account
resource "azurerm_storage_account" "network" {
  name                            = var.storage_account_network_name
  resource_group_name             = azurerm_resource_group.storage.name
  location                        = azurerm_resource_group.storage.location
  account_tier                    = var.storage_account_tier
  account_replication_type        = var.storage_account_replication_type
  account_kind                    = var.storage_account_kind
  min_tls_version                 = var.storage_min_tls_version
  public_network_access_enabled   = var.storage_public_network_access_enabled
  allow_nested_items_to_be_public = var.storage_allow_nested_items_public
  shared_access_key_enabled       = var.storage_shared_access_key_enabled

  blob_properties {
    delete_retention_policy {
      days = var.blob_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.container_delete_retention_days
    }
  }

  tags = var.tags
}

#------------------------------------------------------------------------------
# Private Endpoints for Storage Accounts - VM Storage
#------------------------------------------------------------------------------

resource "azurerm_private_endpoint" "storage_vm_blob" {
  name                = var.pe_storage_vm_blob_name
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-blob"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_vm_file" {
  name                = var.pe_storage_vm_file_name
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-file"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_vm_queue" {
  name                = var.pe_storage_vm_queue_name
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-queue"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_vm_table" {
  name                = var.pe_storage_vm_table_name
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-table"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"]]
  }

  tags = var.tags
}

#------------------------------------------------------------------------------
# Private Endpoints for Storage Accounts - Network Storage
#------------------------------------------------------------------------------

resource "azurerm_private_endpoint" "storage_network_blob" {
  name                = var.pe_storage_network_blob_name
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_network_name}-blob"
    private_connection_resource_id = azurerm_storage_account.network.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_network_file" {
  name                = var.pe_storage_network_file_name
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_network_name}-file"
    private_connection_resource_id = azurerm_storage_account.network.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_network_queue" {
  name                = var.pe_storage_network_queue_name
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_network_name}-queue"
    private_connection_resource_id = azurerm_storage_account.network.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_network_table" {
  name                = var.pe_storage_network_table_name
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_network_name}-table"
    private_connection_resource_id = azurerm_storage_account.network.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"]]
  }

  tags = var.tags
}

#------------------------------------------------------------------------------
# Diagnostic Settings for Storage Accounts
#------------------------------------------------------------------------------

resource "azurerm_monitor_diagnostic_setting" "storage_vm_blob" {
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

resource "azurerm_monitor_diagnostic_setting" "storage_vm_file" {
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

resource "azurerm_monitor_diagnostic_setting" "storage_vm_queue" {
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

resource "azurerm_monitor_diagnostic_setting" "storage_vm_table" {
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

resource "azurerm_monitor_diagnostic_setting" "storage_network_blob" {
  name                       = "diag-${var.storage_account_network_name}-blob"
  target_resource_id         = "${azurerm_storage_account.network.id}/blobServices/default"
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

resource "azurerm_monitor_diagnostic_setting" "storage_network_file" {
  name                       = "diag-${var.storage_account_network_name}-file"
  target_resource_id         = "${azurerm_storage_account.network.id}/fileServices/default"
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

resource "azurerm_monitor_diagnostic_setting" "storage_network_queue" {
  name                       = "diag-${var.storage_account_network_name}-queue"
  target_resource_id         = "${azurerm_storage_account.network.id}/queueServices/default"
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

resource "azurerm_monitor_diagnostic_setting" "storage_network_table" {
  name                       = "diag-${var.storage_account_network_name}-table"
  target_resource_id         = "${azurerm_storage_account.network.id}/tableServices/default"
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