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
  features {
    recovery_services_vaults {
      recover_soft_deleted_backup_protected_vm = true
    }
  }
  subscription_id = var.management_subscription_id
}

provider "azurerm" {
  alias           = "identity"
  features {}
  subscription_id = var.identity_subscription_id
}

# ============================================
# Resource Groups
# ============================================

resource "azurerm_resource_group" "automation_account" {
  name     = var.mgmt_automation_account_resource_group
  location = var.region
  tags     = var.tags
}

resource "azurerm_resource_group" "recovery_services_vault" {
  name     = var.mgmt_recovery_services_vault_resource_group
  location = var.region
  tags     = var.tags
}

resource "azurerm_resource_group" "storage" {
  name     = var.mgmt_storage_account_vm_resource_group
  location = var.region
  tags     = var.tags
}

# ============================================
# Automation Account
# ============================================

resource "azurerm_automation_account" "this" {
  name                = var.mgmt_automation_account_name
  location            = var.region
  resource_group_name = azurerm_resource_group.automation_account.name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }

  public_network_access_enabled = false

  tags = var.tags
}

# Link Automation Account to Log Analytics Workspace
resource "azurerm_log_analytics_linked_service" "this" {
  resource_group_name = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_resource_group_name
  workspace_id        = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id
  read_access_id      = azurerm_automation_account.this.id
}

# Automation Account Private Endpoint
resource "azurerm_private_endpoint" "automation_account" {
  name                = "pep-${var.mgmt_automation_account_name}"
  location            = var.region
  resource_group_name = azurerm_resource_group.automation_account.name
  subnet_id           = data.terraform_remote_state.management_network_1.outputs.subnet_ids[var.snet_pe_mgmt_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.mgmt_automation_account_name}"
    private_connection_resource_id = azurerm_automation_account.this.id
    subresource_names              = ["Webhook"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.azure-automation.net"]
    ]
  }

  tags = var.tags
}

# Automation Account Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "automation_account" {
  name                       = "diag-${var.mgmt_automation_account_name}"
  target_resource_id         = azurerm_automation_account.this.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

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

  enabled_metric {
    category = "AllMetrics"
  }
}

# ============================================
# Recovery Services Vault
# ============================================

resource "azurerm_recovery_services_vault" "this" {
  name                = var.mgmt_recovery_services_vault_name
  location            = var.region
  resource_group_name = azurerm_resource_group.recovery_services_vault.name
  sku                 = "Standard"

  soft_delete_enabled = true

  public_network_access_enabled = false

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Recovery Services Vault Private Endpoint
resource "azurerm_private_endpoint" "recovery_services_vault" {
  name                = "pep-${var.mgmt_recovery_services_vault_name}"
  location            = var.region
  resource_group_name = azurerm_resource_group.recovery_services_vault.name
  subnet_id           = data.terraform_remote_state.management_network_1.outputs.subnet_ids[var.snet_pe_mgmt_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.mgmt_recovery_services_vault_name}"
    private_connection_resource_id = azurerm_recovery_services_vault.this.id
    subresource_names              = ["AzureSiteRecovery"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.siterecovery.windowsazure.com"],
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.eus2.backup.windowsazure.com"]
    ]
  }

  tags = var.tags
}

# Recovery Services Vault Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "recovery_services_vault" {
  name                       = "diag-${var.mgmt_recovery_services_vault_name}"
  target_resource_id         = azurerm_recovery_services_vault.this.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "CoreAzureBackup"
  }

  enabled_log {
    category = "AddonAzureBackupJobs"
  }

  enabled_log {
    category = "AddonAzureBackupPolicy"
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

  enabled_metric {
    category = "AllMetrics"
  }
}

# ============================================
# Storage Account - VM Diagnostics
# ============================================

resource "azurerm_storage_account" "vm" {
  name                     = var.mgmt_storage_account_vm_name
  resource_group_name      = azurerm_resource_group.storage.name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  tags = var.tags
}

# Storage Account VM - Blob Private Endpoint
resource "azurerm_private_endpoint" "storage_vm_blob" {
  name                = "pep-${var.mgmt_storage_account_vm_name}-blob"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.management_network_1.outputs.subnet_ids[var.snet_pe_mgmt_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.mgmt_storage_account_vm_name}-blob"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]
    ]
  }

  tags = var.tags
}

# Storage Account VM - File Private Endpoint
resource "azurerm_private_endpoint" "storage_vm_file" {
  name                = "pep-${var.mgmt_storage_account_vm_name}-file"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.management_network_1.outputs.subnet_ids[var.snet_pe_mgmt_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.mgmt_storage_account_vm_name}-file"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"]
    ]
  }

  tags = var.tags
}

# Storage Account VM - Queue Private Endpoint
resource "azurerm_private_endpoint" "storage_vm_queue" {
  name                = "pep-${var.mgmt_storage_account_vm_name}-queue"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.management_network_1.outputs.subnet_ids[var.snet_pe_mgmt_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.mgmt_storage_account_vm_name}-queue"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"]
    ]
  }

  tags = var.tags
}

# Storage Account VM - Table Private Endpoint
resource "azurerm_private_endpoint" "storage_vm_table" {
  name                = "pep-${var.mgmt_storage_account_vm_name}-table"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.management_network_1.outputs.subnet_ids[var.snet_pe_mgmt_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.mgmt_storage_account_vm_name}-table"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"]
    ]
  }

  tags = var.tags
}

# Storage Account VM Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "storage_vm" {
  name                       = "diag-${var.mgmt_storage_account_vm_name}"
  target_resource_id         = azurerm_storage_account.vm.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }
}

# Storage Account VM - Blob Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "storage_vm_blob" {
  name                       = "diag-${var.mgmt_storage_account_vm_name}-blob"
  target_resource_id         = "${azurerm_storage_account.vm.id}/blobServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# ============================================
# Storage Account - Network Diagnostics
# ============================================

resource "azurerm_storage_account" "ntwk" {
  name                     = var.mgmt_storage_account_ntwk_name
  resource_group_name      = azurerm_resource_group.storage.name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  tags = var.tags
}

# Storage Account Ntwk - Blob Private Endpoint
resource "azurerm_private_endpoint" "storage_ntwk_blob" {
  name                = "pep-${var.mgmt_storage_account_ntwk_name}-blob"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.management_network_1.outputs.subnet_ids[var.snet_pe_mgmt_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.mgmt_storage_account_ntwk_name}-blob"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]
    ]
  }

  tags = var.tags
}

# Storage Account Ntwk - File Private Endpoint
resource "azurerm_private_endpoint" "storage_ntwk_file" {
  name                = "pep-${var.mgmt_storage_account_ntwk_name}-file"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.management_network_1.outputs.subnet_ids[var.snet_pe_mgmt_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.mgmt_storage_account_ntwk_name}-file"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"]
    ]
  }

  tags = var.tags
}

# Storage Account Ntwk - Queue Private Endpoint
resource "azurerm_private_endpoint" "storage_ntwk_queue" {
  name                = "pep-${var.mgmt_storage_account_ntwk_name}-queue"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.management_network_1.outputs.subnet_ids[var.snet_pe_mgmt_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.mgmt_storage_account_ntwk_name}-queue"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"]
    ]
  }

  tags = var.tags
}

# Storage Account Ntwk - Table Private Endpoint
resource "azurerm_private_endpoint" "storage_ntwk_table" {
  name                = "pep-${var.mgmt_storage_account_ntwk_name}-table"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.management_network_1.outputs.subnet_ids[var.snet_pe_mgmt_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.mgmt_storage_account_ntwk_name}-table"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"]
    ]
  }

  tags = var.tags
}

# Storage Account Ntwk Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "storage_ntwk" {
  name                       = "diag-${var.mgmt_storage_account_ntwk_name}"
  target_resource_id         = azurerm_storage_account.ntwk.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }
}

# Storage Account Ntwk - Blob Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "storage_ntwk_blob" {
  name                       = "diag-${var.mgmt_storage_account_ntwk_name}-blob"
  target_resource_id         = "${azurerm_storage_account.ntwk.id}/blobServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# ============================================
# Diagnostic Settings for Tools Deployment 1 Resources
# ============================================

# Key Vault PRD Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "key_vault_prd" {
  name                       = "diag-${var.mgmt_key_vault_prd_name}"
  target_resource_id         = data.terraform_remote_state.management_tools_1.outputs.key_vault_prd_id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Key Vault NPRD Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "key_vault_nprd" {
  name                       = "diag-${var.mgmt_key_vault_nprd_name}"
  target_resource_id         = data.terraform_remote_state.management_tools_1.outputs.key_vault_nprd_id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Log Analytics Workspace Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "log_analytics" {
  name                       = "diag-${var.mgmt_log_analytics_workspace_name}"
  target_resource_id         = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "Audit"
  }

  enabled_log {
    category = "SummaryLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}