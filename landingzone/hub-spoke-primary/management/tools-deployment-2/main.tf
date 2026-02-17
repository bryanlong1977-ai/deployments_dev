# Tools Deployment 2 - Management Subscription
# Resources: Automation Account, Recovery Services Vault, Storage Accounts

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
      recover_soft_deleted_backup_protected_vm = var.recover_soft_deleted_vms
    }
  }
  subscription_id = var.subscription_id
}

# Provider for Identity subscription (for Private DNS Zone links)
provider "azurerm" {
  alias           = "identity"
  subscription_id = var.identity_subscription_id
  features {}
}

#--------------------------------------------------------------
# Local Values
#--------------------------------------------------------------
locals {
  tags = {
    customer      = var.customer_name
    project       = var.project_name
    environment   = var.environment
    deployment_id = var.deployment_id
    deployed_by   = "terraform"
    deployment    = "tools-deployment-2"
  }

  # Get subnet ID for private endpoints from remote state
  pe_subnet_id = data.terraform_remote_state.management_network_deployment_1.outputs.subnet_ids[var.pe_subnet_name]
}

#--------------------------------------------------------------
# Resource Groups
#--------------------------------------------------------------
resource "azurerm_resource_group" "automation_account" {
  name     = var.automation_account_rg_name
  location = var.region
  tags     = local.tags
}

resource "azurerm_resource_group" "recovery_services_vault" {
  name     = var.recovery_services_vault_rg_name
  location = var.region
  tags     = local.tags
}

resource "azurerm_resource_group" "storage" {
  name     = var.storage_rg_name
  location = var.region
  tags     = local.tags
}

#--------------------------------------------------------------
# Automation Account
#--------------------------------------------------------------
resource "azurerm_automation_account" "this" {
  name                          = var.automation_account_name
  location                      = var.region
  resource_group_name           = azurerm_resource_group.automation_account.name
  sku_name                      = var.automation_account_sku
  public_network_access_enabled = var.automation_account_public_access
  local_authentication_enabled  = var.automation_account_local_auth

  identity {
    type = var.automation_account_identity_type
  }

  tags = local.tags
}

# Link Automation Account to Log Analytics Workspace
resource "azurerm_log_analytics_linked_service" "automation" {
  resource_group_name = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_resource_group_name
  workspace_id        = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id
  read_access_id      = azurerm_automation_account.this.id
}

# Private Endpoint for Automation Account - Webhook
resource "azurerm_private_endpoint" "automation_webhook" {
  name                = var.automation_account_pe_webhook_name
  location            = var.region
  resource_group_name = azurerm_resource_group.automation_account.name
  subnet_id           = local.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.automation_account_name}-webhook"
    private_connection_resource_id = azurerm_automation_account.this.id
    is_manual_connection           = false
    subresource_names              = ["Webhook"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.azure-automation.net"]]
  }

  tags = local.tags
}

# Private Endpoint for Automation Account - DSCAndHybridWorker
resource "azurerm_private_endpoint" "automation_dsc" {
  name                = var.automation_account_pe_dsc_name
  location            = var.region
  resource_group_name = azurerm_resource_group.automation_account.name
  subnet_id           = local.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.automation_account_name}-dsc"
    private_connection_resource_id = azurerm_automation_account.this.id
    is_manual_connection           = false
    subresource_names              = ["DSCAndHybridWorker"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.azure-automation.net"]]
  }

  tags = local.tags
}

#--------------------------------------------------------------
# Recovery Services Vault
#--------------------------------------------------------------
resource "azurerm_recovery_services_vault" "this" {
  name                          = var.recovery_services_vault_name
  location                      = var.region
  resource_group_name           = azurerm_resource_group.recovery_services_vault.name
  sku                           = var.recovery_services_vault_sku
  storage_mode_type             = var.recovery_services_vault_storage_mode
  cross_region_restore_enabled  = var.recovery_services_vault_cross_region_restore
  soft_delete_enabled           = var.recovery_services_vault_soft_delete
  public_network_access_enabled = var.recovery_services_vault_public_access

  identity {
    type = var.recovery_services_vault_identity_type
  }

  tags = local.tags
}

# Private Endpoint for Recovery Services Vault - Azure Backup
resource "azurerm_private_endpoint" "rsv_backup" {
  name                = var.recovery_services_vault_pe_backup_name
  location            = var.region
  resource_group_name = azurerm_resource_group.recovery_services_vault.name
  subnet_id           = local.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.recovery_services_vault_name}-backup"
    private_connection_resource_id = azurerm_recovery_services_vault.this.id
    is_manual_connection           = false
    subresource_names              = ["AzureBackup"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.wus3.backup.windowsazure.com"]
    ]
  }

  tags = local.tags
}

# Private Endpoint for Recovery Services Vault - Site Recovery
resource "azurerm_private_endpoint" "rsv_siterecovery" {
  name                = var.recovery_services_vault_pe_siterecovery_name
  location            = var.region
  resource_group_name = azurerm_resource_group.recovery_services_vault.name
  subnet_id           = local.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.recovery_services_vault_name}-siterecovery"
    private_connection_resource_id = azurerm_recovery_services_vault.this.id
    is_manual_connection           = false
    subresource_names              = ["AzureSiteRecovery"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.siterecovery.windowsazure.com"]
    ]
  }

  tags = local.tags
}

#--------------------------------------------------------------
# Storage Account - VM Diagnostics
#--------------------------------------------------------------
resource "azurerm_storage_account" "vm" {
  name                            = var.storage_account_vm_name
  resource_group_name             = azurerm_resource_group.storage.name
  location                        = var.region
  account_tier                    = var.storage_account_tier
  account_replication_type        = var.storage_account_replication_type
  account_kind                    = var.storage_account_kind
  min_tls_version                 = var.storage_account_tls_version
  https_traffic_only_enabled      = var.storage_account_https_only
  public_network_access_enabled   = var.storage_account_public_access
  allow_nested_items_to_be_public = var.storage_account_allow_public_blobs
  shared_access_key_enabled       = var.storage_account_shared_key_access

  blob_properties {
    delete_retention_policy {
      days = var.storage_blob_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_container_retention_days
    }
  }

  tags = local.tags
}

# Private Endpoints for VM Storage Account
resource "azurerm_private_endpoint" "storage_vm_blob" {
  name                = var.storage_account_vm_pe_blob_name
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = local.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-blob"
    private_connection_resource_id = azurerm_storage_account.vm.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
  }

  tags = local.tags
}

resource "azurerm_private_endpoint" "storage_vm_file" {
  name                = var.storage_account_vm_pe_file_name
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = local.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-file"
    private_connection_resource_id = azurerm_storage_account.vm.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"]]
  }

  tags = local.tags
}

resource "azurerm_private_endpoint" "storage_vm_queue" {
  name                = var.storage_account_vm_pe_queue_name
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = local.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-queue"
    private_connection_resource_id = azurerm_storage_account.vm.id
    is_manual_connection           = false
    subresource_names              = ["queue"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"]]
  }

  tags = local.tags
}

resource "azurerm_private_endpoint" "storage_vm_table" {
  name                = var.storage_account_vm_pe_table_name
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = local.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-table"
    private_connection_resource_id = azurerm_storage_account.vm.id
    is_manual_connection           = false
    subresource_names              = ["table"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"]]
  }

  tags = local.tags
}

#--------------------------------------------------------------
# Storage Account - Network Diagnostics
#--------------------------------------------------------------
resource "azurerm_storage_account" "ntwk" {
  name                            = var.storage_account_ntwk_name
  resource_group_name             = azurerm_resource_group.storage.name
  location                        = var.region
  account_tier                    = var.storage_account_tier
  account_replication_type        = var.storage_account_replication_type
  account_kind                    = var.storage_account_kind
  min_tls_version                 = var.storage_account_tls_version
  https_traffic_only_enabled      = var.storage_account_https_only
  public_network_access_enabled   = var.storage_account_public_access
  allow_nested_items_to_be_public = var.storage_account_allow_public_blobs
  shared_access_key_enabled       = var.storage_account_shared_key_access

  blob_properties {
    delete_retention_policy {
      days = var.storage_blob_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_container_retention_days
    }
  }

  tags = local.tags
}

# Private Endpoints for Network Storage Account
resource "azurerm_private_endpoint" "storage_ntwk_blob" {
  name                = var.storage_account_ntwk_pe_blob_name
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = local.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-blob"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
  }

  tags = local.tags
}

resource "azurerm_private_endpoint" "storage_ntwk_file" {
  name                = var.storage_account_ntwk_pe_file_name
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = local.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-file"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"]]
  }

  tags = local.tags
}

resource "azurerm_private_endpoint" "storage_ntwk_queue" {
  name                = var.storage_account_ntwk_pe_queue_name
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = local.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-queue"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    is_manual_connection           = false
    subresource_names              = ["queue"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"]]
  }

  tags = local.tags
}

resource "azurerm_private_endpoint" "storage_ntwk_table" {
  name                = var.storage_account_ntwk_pe_table_name
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = local.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-table"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    is_manual_connection           = false
    subresource_names              = ["table"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"]]
  }

  tags = local.tags
}

#--------------------------------------------------------------
# Diagnostic Settings - Resources from Tools Deployment 1
#--------------------------------------------------------------

# Diagnostic Settings for Key Vault (Production)
resource "azurerm_monitor_diagnostic_setting" "key_vault_prd" {
  name                       = "diag-${var.key_vault_prd_name}"
  target_resource_id         = data.terraform_remote_state.management_tools_deployment_1.outputs.key_vault_prd_id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Diagnostic Settings for Key Vault (Non-Production)
resource "azurerm_monitor_diagnostic_setting" "key_vault_nprd" {
  name                       = "diag-${var.key_vault_nprd_name}"
  target_resource_id         = data.terraform_remote_state.management_tools_deployment_1.outputs.key_vault_nprd_id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Diagnostic Settings for Log Analytics Workspace
resource "azurerm_monitor_diagnostic_setting" "log_analytics" {
  name                       = "diag-${var.log_analytics_workspace_name}"
  target_resource_id         = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "Audit"
  }

  enabled_log {
    category = "SummaryLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

#--------------------------------------------------------------
# Diagnostic Settings - Resources from this Deployment
#--------------------------------------------------------------

# Diagnostic Settings for Automation Account
resource "azurerm_monitor_diagnostic_setting" "automation_account" {
  name                       = "diag-${var.automation_account_name}"
  target_resource_id         = azurerm_automation_account.this.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "JobLogs"
  }

  enabled_log {
    category = "JobStreams"
  }

  enabled_log {
    category = "DscNodeStatus"
  }

  enabled_log {
    category = "AuditEvent"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Diagnostic Settings for Recovery Services Vault
resource "azurerm_monitor_diagnostic_setting" "recovery_services_vault" {
  name                       = "diag-${var.recovery_services_vault_name}"
  target_resource_id         = azurerm_recovery_services_vault.this.id
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
}

# Diagnostic Settings for VM Storage Account
resource "azurerm_monitor_diagnostic_setting" "storage_vm" {
  name                       = "diag-${var.storage_account_vm_name}"
  target_resource_id         = azurerm_storage_account.vm.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  metric {
    category = "Transaction"
    enabled  = true
  }

  metric {
    category = "Capacity"
    enabled  = true
  }
}

# Diagnostic Settings for VM Storage Account - Blob Service
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

  metric {
    category = "Capacity"
    enabled  = true
  }
}

# Diagnostic Settings for Network Storage Account
resource "azurerm_monitor_diagnostic_setting" "storage_ntwk" {
  name                       = "diag-${var.storage_account_ntwk_name}"
  target_resource_id         = azurerm_storage_account.ntwk.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  metric {
    category = "Transaction"
    enabled  = true
  }

  metric {
    category = "Capacity"
    enabled  = true
  }
}

# Diagnostic Settings for Network Storage Account - Blob Service
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

  metric {
    category = "Capacity"
    enabled  = true
  }
}