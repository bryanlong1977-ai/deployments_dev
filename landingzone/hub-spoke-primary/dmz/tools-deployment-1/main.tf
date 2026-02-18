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

# Data source for current client configuration
data "azurerm_client_config" "current" {}

# Resource Group for Storage Accounts
resource "azurerm_resource_group" "storage" {
  name     = var.storage_resource_group_name
  location = var.region
  tags     = var.tags
}

# Resource Group for Recovery Services Vault
resource "azurerm_resource_group" "rsv" {
  name     = var.rsv_resource_group_name
  location = var.region
  tags     = var.tags
}

# Storage Account for VM diagnostics
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
      days = var.storage_blob_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_container_retention_days
    }
  }

  tags = var.tags
}

# Storage Account for Network diagnostics
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
      days = var.storage_blob_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_container_retention_days
    }
  }

  tags = var.tags
}

# Private Endpoints for VM Storage Account
resource "azurerm_private_endpoint" "storage_vm_blob" {
  name                = "pep-${var.storage_account_vm_name}-blob"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-blob"
    private_connection_resource_id = azurerm_storage_account.vm.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "pdnszg-blob"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_blob_id]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_vm_file" {
  name                = "pep-${var.storage_account_vm_name}-file"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-file"
    private_connection_resource_id = azurerm_storage_account.vm.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "pdnszg-file"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_file_id]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_vm_queue" {
  name                = "pep-${var.storage_account_vm_name}-queue"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-queue"
    private_connection_resource_id = azurerm_storage_account.vm.id
    is_manual_connection           = false
    subresource_names              = ["queue"]
  }

  private_dns_zone_group {
    name                 = "pdnszg-queue"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_queue_id]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_vm_table" {
  name                = "pep-${var.storage_account_vm_name}-table"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-table"
    private_connection_resource_id = azurerm_storage_account.vm.id
    is_manual_connection           = false
    subresource_names              = ["table"]
  }

  private_dns_zone_group {
    name                 = "pdnszg-table"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_table_id]
  }

  tags = var.tags
}

# Private Endpoints for Network Storage Account
resource "azurerm_private_endpoint" "storage_network_blob" {
  name                = "pep-${var.storage_account_network_name}-blob"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_network_name}-blob"
    private_connection_resource_id = azurerm_storage_account.network.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "pdnszg-blob"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_blob_id]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_network_file" {
  name                = "pep-${var.storage_account_network_name}-file"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_network_name}-file"
    private_connection_resource_id = azurerm_storage_account.network.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "pdnszg-file"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_file_id]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_network_queue" {
  name                = "pep-${var.storage_account_network_name}-queue"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_network_name}-queue"
    private_connection_resource_id = azurerm_storage_account.network.id
    is_manual_connection           = false
    subresource_names              = ["queue"]
  }

  private_dns_zone_group {
    name                 = "pdnszg-queue"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_queue_id]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_network_table" {
  name                = "pep-${var.storage_account_network_name}-table"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_network_name}-table"
    private_connection_resource_id = azurerm_storage_account.network.id
    is_manual_connection           = false
    subresource_names              = ["table"]
  }

  private_dns_zone_group {
    name                 = "pdnszg-table"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_table_id]
  }

  tags = var.tags
}

# Recovery Services Vault
resource "azurerm_recovery_services_vault" "dmz" {
  name                          = var.recovery_services_vault_name
  location                      = azurerm_resource_group.rsv.location
  resource_group_name           = azurerm_resource_group.rsv.name
  sku                           = var.rsv_sku
  storage_mode_type             = var.rsv_storage_mode_type
  cross_region_restore_enabled  = var.rsv_cross_region_restore_enabled
  soft_delete_enabled           = var.rsv_soft_delete_enabled
  public_network_access_enabled = var.rsv_public_network_access_enabled

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Diagnostic settings for Storage Account VM
resource "azurerm_monitor_diagnostic_setting" "storage_vm" {
  name                       = "diag-${var.storage_account_vm_name}"
  target_resource_id         = azurerm_storage_account.vm.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  metric {
    category = "Transaction"
    enabled  = true
  }
}

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

# Diagnostic settings for Storage Account Network
resource "azurerm_monitor_diagnostic_setting" "storage_network" {
  name                       = "diag-${var.storage_account_network_name}"
  target_resource_id         = azurerm_storage_account.network.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

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

# Diagnostic settings for Recovery Services Vault
resource "azurerm_monitor_diagnostic_setting" "rsv" {
  name                       = "diag-${var.recovery_services_vault_name}"
  target_resource_id         = azurerm_recovery_services_vault.dmz.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "CoreAzureBackup"
  }
  enabled_log {
    category = "AddonAzureBackupJobs"
  }
  enabled_log {
    category = "AddonAzureBackupAlerts"
  }
  enabled_log {
    category = "AddonAzureBackupPolicy"
  }
  enabled_log {
    category = "AddonAzureBackupStorage"
  }
  enabled_log {
    category = "AddonAzureBackupProtectedInstance"
  }
  enabled_log {
    category = "AzureSiteRecoveryJobs"
  }
  enabled_log {
    category = "AzureSiteRecoveryEvents"
  }
  enabled_log {
    category = "AzureSiteRecoveryReplicatedItems"
  }
  enabled_log {
    category = "AzureSiteRecoveryReplicationStats"
  }
  enabled_log {
    category = "AzureSiteRecoveryRecoveryPoints"
  }
  enabled_log {
    category = "AzureSiteRecoveryReplicationDataUploadRate"
  }
  enabled_log {
    category = "AzureSiteRecoveryProtectedDiskDataChurn"
  }

  metric {
    category = "Health"
    enabled  = true
  }
}