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
  subscription_id = var.management_subscription_id
}

provider "azurerm" {
  alias           = "identity"
  features {}
  subscription_id = var.identity_subscription_id
}

# Current client configuration for tenant_id and object_id
data "azurerm_client_config" "this" {}

# ============================================
# Resource Groups
# ============================================
resource "azurerm_resource_group" "log" {
  name     = var.mgmt_log_analytics_workspace_resource_group
  location = var.region
  tags     = var.tags
}

resource "azurerm_resource_group" "aa" {
  name     = var.mgmt_automation_account_resource_group
  location = var.region
  tags     = var.tags
}

resource "azurerm_resource_group" "kv" {
  name     = var.mgmt_key_vault_prd_resource_group
  location = var.region
  tags     = var.tags
}

resource "azurerm_resource_group" "mi" {
  name     = var.mgmt_managed_identity_resource_group
  location = var.region
  tags     = var.tags
}

resource "azurerm_resource_group" "st" {
  name     = var.mgmt_storage_account_diag_resource_group
  location = var.region
  tags     = var.tags
}

# ============================================
# Log Analytics Workspace
# ============================================
resource "azurerm_log_analytics_workspace" "this" {
  name                          = var.mgmt_log_analytics_workspace_name
  location                      = var.region
  resource_group_name           = azurerm_resource_group.log.name
  sku                           = var.log_analytics_sku
  retention_in_days             = var.log_analytics_retention_days
  local_authentication_enabled  = false
  tags                          = var.tags
}

# ============================================
# Managed Identity
# ============================================
resource "azurerm_user_assigned_identity" "this" {
  name                = var.mgmt_managed_identity_name
  location            = var.region
  resource_group_name = azurerm_resource_group.mi.name
  tags                = var.tags
}

# ============================================
# Automation Account
# ============================================
resource "azurerm_automation_account" "this" {
  name                = var.mgmt_automation_account_name
  location            = var.region
  resource_group_name = azurerm_resource_group.aa.name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_log_analytics_linked_service" "this" {
  resource_group_name = azurerm_resource_group.log.name
  workspace_id        = azurerm_log_analytics_workspace.this.id
  read_access_id      = azurerm_automation_account.this.id
}

# Diagnostic Settings - Automation Account
resource "azurerm_monitor_diagnostic_setting" "aa" {
  name                       = "diag-${var.mgmt_automation_account_name}"
  target_resource_id         = azurerm_automation_account.this.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

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
# Key Vault - Production
# ============================================
resource "azurerm_key_vault" "prd" {
  name                          = var.mgmt_key_vault_prd_name
  location                      = var.region
  resource_group_name           = azurerm_resource_group.kv.name
  tenant_id                     = data.azurerm_client_config.this.tenant_id
  sku_name                      = "standard"
  rbac_authorization_enabled    = true
  purge_protection_enabled      = true
  soft_delete_retention_days    = 90
  enabled_for_disk_encryption   = false
  enabled_for_template_deployment = false
  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.tags
}

# Key Vault - Non-Production
resource "azurerm_key_vault" "nprd" {
  name                          = var.mgmt_key_vault_nprd_name
  location                      = var.region
  resource_group_name           = azurerm_resource_group.kv.name
  tenant_id                     = data.azurerm_client_config.this.tenant_id
  sku_name                      = "standard"
  rbac_authorization_enabled    = true
  purge_protection_enabled      = true
  soft_delete_retention_days    = 90
  enabled_for_disk_encryption   = false
  enabled_for_template_deployment = false
  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.tags
}

# Private Endpoint - Key Vault Production
resource "azurerm_private_endpoint" "kv_prd" {
  name                = "pep-${var.mgmt_key_vault_prd_name}"
  location            = var.region
  resource_group_name = azurerm_resource_group.kv.name
  subnet_id           = data.terraform_remote_state.management_network_deployment_1.outputs.subnet_ids[var.snet_pe_mgmt_cus_01_subnet_name]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.mgmt_key_vault_prd_name}"
    private_connection_resource_id = azurerm_key_vault.prd.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids[var.keyvault_dns_zone_name]
    ]
  }
}

# Private Endpoint - Key Vault Non-Production
resource "azurerm_private_endpoint" "kv_nprd" {
  name                = "pep-${var.mgmt_key_vault_nprd_name}"
  location            = var.region
  resource_group_name = azurerm_resource_group.kv.name
  subnet_id           = data.terraform_remote_state.management_network_deployment_1.outputs.subnet_ids[var.snet_pe_mgmt_cus_01_subnet_name]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.mgmt_key_vault_nprd_name}"
    private_connection_resource_id = azurerm_key_vault.nprd.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids[var.keyvault_dns_zone_name]
    ]
  }
}

# ============================================
# Storage Account - Diagnostics
# ============================================
resource "azurerm_storage_account" "this" {
  name                     = var.mgmt_storage_account_diag_name
  location                 = var.region
  resource_group_name      = azurerm_resource_group.st.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  public_network_access_enabled = false

  tags = var.tags
}

# Diagnostic Settings - Storage Account
resource "azurerm_monitor_diagnostic_setting" "st" {
  name                       = "diag-${var.mgmt_storage_account_diag_name}"
  target_resource_id         = azurerm_storage_account.this.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_metric {
    category = "AllMetrics"
  }
}

# Private Endpoint - Storage Account Blob
resource "azurerm_private_endpoint" "st_blob" {
  name                = "pep-${var.mgmt_storage_account_diag_name}-blob"
  location            = var.region
  resource_group_name = azurerm_resource_group.st.name
  subnet_id           = data.terraform_remote_state.management_network_deployment_1.outputs.subnet_ids[var.snet_pe_mgmt_cus_01_subnet_name]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.mgmt_storage_account_diag_name}-blob"
    private_connection_resource_id = azurerm_storage_account.this.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids[var.blob_dns_zone_name]
    ]
  }
}

# ============================================
# Diagnostic Settings - Log Analytics Workspace
# ============================================
resource "azurerm_monitor_diagnostic_setting" "log" {
  name                       = "diag-${var.mgmt_log_analytics_workspace_name}"
  target_resource_id         = azurerm_log_analytics_workspace.this.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

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

# ============================================
# Diagnostic Settings - Key Vault Production
# ============================================
resource "azurerm_monitor_diagnostic_setting" "kv_prd" {
  name                       = "diag-${var.mgmt_key_vault_prd_name}"
  target_resource_id         = azurerm_key_vault.prd.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

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

# ============================================
# Diagnostic Settings - Key Vault Non-Production
# ============================================
resource "azurerm_monitor_diagnostic_setting" "kv_nprd" {
  name                       = "diag-${var.mgmt_key_vault_nprd_name}"
  target_resource_id         = azurerm_key_vault.nprd.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

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