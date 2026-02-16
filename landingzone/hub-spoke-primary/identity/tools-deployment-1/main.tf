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

# Provider for management subscription (for Log Analytics reference)
provider "azurerm" {
  alias           = "management"
  features {}
  subscription_id = var.management_subscription_id
}

# Provider for identity subscription DNS zones
provider "azurerm" {
  alias           = "identity_dns"
  features {}
  subscription_id = var.subscription_id
}

#------------------------------------------------------------------------------
# Resource Groups
#------------------------------------------------------------------------------

# Resource Group for Recovery Services Vault
resource "azurerm_resource_group" "rsv" {
  name     = var.rsv_resource_group_name
  location = var.region
  tags     = var.tags
}

# Resource Group for Storage Accounts
resource "azurerm_resource_group" "storage" {
  name     = var.storage_resource_group_name
  location = var.region
  tags     = var.tags
}

#------------------------------------------------------------------------------
# Recovery Services Vault
#------------------------------------------------------------------------------

resource "azurerm_recovery_services_vault" "rsv" {
  name                          = var.rsv_name
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

# Private Endpoint for Recovery Services Vault - Azure Backup
resource "azurerm_private_endpoint" "rsv_backup" {
  name                = var.rsv_backup_pe_name
  location            = azurerm_resource_group.rsv.location
  resource_group_name = azurerm_resource_group.rsv.name
  subnet_id           = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids["snet-pe-idm-wus3-01"]

  private_service_connection {
    name                           = "psc-${var.rsv_name}-backup"
    private_connection_resource_id = azurerm_recovery_services_vault.rsv.id
    subresource_names              = ["AzureBackup"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.wus3.backup.windowsazure.com"]]
  }

  tags = var.tags
}

# Private Endpoint for Recovery Services Vault - Site Recovery
resource "azurerm_private_endpoint" "rsv_siterecovery" {
  name                = var.rsv_siterecovery_pe_name
  location            = azurerm_resource_group.rsv.location
  resource_group_name = azurerm_resource_group.rsv.name
  subnet_id           = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids["snet-pe-idm-wus3-01"]

  private_service_connection {
    name                           = "psc-${var.rsv_name}-siterecovery"
    private_connection_resource_id = azurerm_recovery_services_vault.rsv.id
    subresource_names              = ["AzureSiteRecovery"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.siterecovery.windowsazure.com"]]
  }

  tags = var.tags
}

# Diagnostic Settings for Recovery Services Vault
resource "azurerm_monitor_diagnostic_setting" "rsv" {
  name                       = "diag-${var.rsv_name}"
  target_resource_id         = azurerm_recovery_services_vault.rsv.id
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

#------------------------------------------------------------------------------
# Storage Account - VM Diagnostics
#------------------------------------------------------------------------------

resource "azurerm_storage_account" "vm" {
  name                            = var.storage_account_vm_name
  resource_group_name             = azurerm_resource_group.storage.name
  location                        = azurerm_resource_group.storage.location
  account_tier                    = var.storage_account_tier
  account_replication_type        = var.storage_account_replication_type
  account_kind                    = var.storage_account_kind
  min_tls_version                 = var.storage_account_min_tls_version
  allow_nested_items_to_be_public = var.storage_account_allow_blob_public_access
  public_network_access_enabled   = var.storage_account_public_network_access_enabled
  shared_access_key_enabled       = var.storage_account_shared_access_key_enabled

  network_rules {
    default_action = var.storage_account_default_network_action
    bypass         = var.storage_account_network_bypass
  }

  blob_properties {
    delete_retention_policy {
      days = var.storage_account_blob_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_account_container_retention_days
    }
  }

  tags = var.tags
}

# Private Endpoints for VM Storage Account
resource "azurerm_private_endpoint" "storage_vm_blob" {
  name                = var.storage_vm_blob_pe_name
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids["snet-pe-idm-wus3-01"]

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
  name                = var.storage_vm_file_pe_name
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids["snet-pe-idm-wus3-01"]

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
  name                = var.storage_vm_queue_pe_name
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids["snet-pe-idm-wus3-01"]

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
  name                = var.storage_vm_table_pe_name
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids["snet-pe-idm-wus3-01"]

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

# Diagnostic Settings for VM Storage Account
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

#------------------------------------------------------------------------------
# Storage Account - Network Diagnostics
#------------------------------------------------------------------------------

resource "azurerm_storage_account" "ntwk" {
  name                            = var.storage_account_ntwk_name
  resource_group_name             = azurerm_resource_group.storage.name
  location                        = azurerm_resource_group.storage.location
  account_tier                    = var.storage_account_tier
  account_replication_type        = var.storage_account_replication_type
  account_kind                    = var.storage_account_kind
  min_tls_version                 = var.storage_account_min_tls_version
  allow_nested_items_to_be_public = var.storage_account_allow_blob_public_access
  public_network_access_enabled   = var.storage_account_public_network_access_enabled
  shared_access_key_enabled       = var.storage_account_shared_access_key_enabled

  network_rules {
    default_action = var.storage_account_default_network_action
    bypass         = var.storage_account_network_bypass
  }

  blob_properties {
    delete_retention_policy {
      days = var.storage_account_blob_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_account_container_retention_days
    }
  }

  tags = var.tags
}

# Private Endpoints for Network Storage Account
resource "azurerm_private_endpoint" "storage_ntwk_blob" {
  name                = var.storage_ntwk_blob_pe_name
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids["snet-pe-idm-wus3-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-blob"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_ntwk_file" {
  name                = var.storage_ntwk_file_pe_name
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids["snet-pe-idm-wus3-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-file"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_ntwk_queue" {
  name                = var.storage_ntwk_queue_pe_name
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids["snet-pe-idm-wus3-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-queue"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_ntwk_table" {
  name                = var.storage_ntwk_table_pe_name
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_deployment_1.outputs.subnet_ids["snet-pe-idm-wus3-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-table"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"]]
  }

  tags = var.tags
}

# Diagnostic Settings for Network Storage Account
resource "azurerm_monitor_diagnostic_setting" "storage_ntwk_blob" {
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