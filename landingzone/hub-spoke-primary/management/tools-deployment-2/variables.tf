#--------------------------------------------------------------
# General Variables
#--------------------------------------------------------------
variable "subscription_id" {
  description = "The subscription ID for the Management subscription"
  type        = string
  default     = "39f647ab-5261-47b0-ad91-1719dcd107a1"
}

variable "identity_subscription_id" {
  description = "The subscription ID for the Identity subscription"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

variable "environment" {
  description = "The environment name (Production, Development, etc.)"
  type        = string
  default     = "Production"
}

variable "customer_name" {
  description = "The customer name for tagging"
  type        = string
  default     = "Cloud AI Consulting"
}

variable "project_name" {
  description = "The project name for tagging"
  type        = string
  default     = "Secure Cloud Foundations"
}

variable "deployment_id" {
  description = "The unique deployment ID"
  type        = string
  default     = "925e43c3-6edd-4030-9310-0f384ef3ac0b"
}

#--------------------------------------------------------------
# Network Variables
#--------------------------------------------------------------
variable "pe_subnet_name" {
  description = "Name of the private endpoint subnet"
  type        = string
  default     = "snet-pe-mgmt-wus3-01"
}

#--------------------------------------------------------------
# Resource Group Variables
#--------------------------------------------------------------
variable "automation_account_rg_name" {
  description = "Name of the resource group for Automation Account"
  type        = string
  default     = "rg-aa-prd-mgmt-wus3-01"
}

variable "recovery_services_vault_rg_name" {
  description = "Name of the resource group for Recovery Services Vault"
  type        = string
  default     = "rg-rsv-prd-mgmt-wus3-01"
}

variable "storage_rg_name" {
  description = "Name of the resource group for Storage Accounts"
  type        = string
  default     = "rg-st-prd-mgmt-wus3-01"
}

#--------------------------------------------------------------
# Automation Account Variables
#--------------------------------------------------------------
variable "automation_account_name" {
  description = "Name of the Automation Account"
  type        = string
  default     = "aa-mgmt-prd-wus3-01"
}

variable "automation_account_sku" {
  description = "SKU of the Automation Account"
  type        = string
  default     = "Basic"
}

variable "automation_account_public_access" {
  description = "Whether public network access is enabled for Automation Account"
  type        = bool
  default     = false
}

variable "automation_account_local_auth" {
  description = "Whether local authentication is enabled for Automation Account"
  type        = bool
  default     = false
}

variable "automation_account_identity_type" {
  description = "Identity type for Automation Account"
  type        = string
  default     = "SystemAssigned"
}

variable "automation_account_pe_webhook_name" {
  description = "Name of the private endpoint for Automation Account Webhook"
  type        = string
  default     = "pep-aa-mgmt-webhook-prd-wus3-01"
}

variable "automation_account_pe_dsc_name" {
  description = "Name of the private endpoint for Automation Account DSC"
  type        = string
  default     = "pep-aa-mgmt-dsc-prd-wus3-01"
}

#--------------------------------------------------------------
# Recovery Services Vault Variables
#--------------------------------------------------------------
variable "recovery_services_vault_name" {
  description = "Name of the Recovery Services Vault"
  type        = string
  default     = "rsv-mgmt-prd-wus3-01"
}

variable "recovery_services_vault_sku" {
  description = "SKU of the Recovery Services Vault"
  type        = string
  default     = "Standard"
}

variable "recovery_services_vault_storage_mode" {
  description = "Storage mode type for Recovery Services Vault"
  type        = string
  default     = "GeoRedundant"
}

variable "recovery_services_vault_cross_region_restore" {
  description = "Whether cross-region restore is enabled"
  type        = bool
  default     = true
}

variable "recovery_services_vault_soft_delete" {
  description = "Whether soft delete is enabled for Recovery Services Vault"
  type        = bool
  default     = true
}

variable "recovery_services_vault_public_access" {
  description = "Whether public network access is enabled for Recovery Services Vault"
  type        = bool
  default     = false
}

variable "recovery_services_vault_identity_type" {
  description = "Identity type for Recovery Services Vault"
  type        = string
  default     = "SystemAssigned"
}

variable "recovery_services_vault_pe_backup_name" {
  description = "Name of the private endpoint for RSV Backup"
  type        = string
  default     = "pep-rsv-mgmt-backup-prd-wus3-01"
}

variable "recovery_services_vault_pe_siterecovery_name" {
  description = "Name of the private endpoint for RSV Site Recovery"
  type        = string
  default     = "pep-rsv-mgmt-asr-prd-wus3-01"
}

variable "recover_soft_deleted_vms" {
  description = "Whether to recover soft deleted backup protected VMs"
  type        = bool
  default     = true
}

#--------------------------------------------------------------
# Storage Account Variables
#--------------------------------------------------------------
variable "storage_account_vm_name" {
  description = "Name of the VM diagnostics storage account"
  type        = string
  default     = "sacloumgmtvmprdwus301"
}

variable "storage_account_ntwk_name" {
  description = "Name of the network diagnostics storage account"
  type        = string
  default     = "sacloumgmtntwkprdwus301"
}

variable "storage_account_tier" {
  description = "Performance tier of the storage account"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Replication type for the storage account"
  type        = string
  default     = "GRS"
}

variable "storage_account_kind" {
  description = "Kind of storage account"
  type        = string
  default     = "StorageV2"
}

variable "storage_account_tls_version" {
  description = "Minimum TLS version for storage account"
  type        = string
  default     = "TLS1_2"
}

variable "storage_account_https_only" {
  description = "Whether HTTPS traffic only is enabled"
  type        = bool
  default     = true
}

variable "storage_account_public_access" {
  description = "Whether public network access is enabled for storage account"
  type        = bool
  default     = false
}

variable "storage_account_allow_public_blobs" {
  description = "Whether public blob access is allowed"
  type        = bool
  default     = false
}

variable "storage_account_shared_key_access" {
  description = "Whether shared key access is enabled for storage account"
  type        = bool
  default     = true
}

variable "storage_blob_retention_days" {
  description = "Number of days to retain deleted blobs"
  type        = number
  default     = 90
}

variable "storage_container_retention_days" {
  description = "Number of days to retain deleted containers"
  type        = number
  default     = 90
}

# VM Storage Account Private Endpoint Names
variable "storage_account_vm_pe_blob_name" {
  description = "Name of the blob private endpoint for VM storage account"
  type        = string
  default     = "pep-sacloumgmtvm-blob-prd-wus3-01"
}

variable "storage_account_vm_pe_file_name" {
  description = "Name of the file private endpoint for VM storage account"
  type        = string
  default     = "pep-sacloumgmtvm-file-prd-wus3-01"
}

variable "storage_account_vm_pe_queue_name" {
  description = "Name of the queue private endpoint for VM storage account"
  type        = string
  default     = "pep-sacloumgmtvm-queue-prd-wus3-01"
}

variable "storage_account_vm_pe_table_name" {
  description = "Name of the table private endpoint for VM storage account"
  type        = string
  default     = "pep-sacloumgmtvm-table-prd-wus3-01"
}

# Network Storage Account Private Endpoint Names
variable "storage_account_ntwk_pe_blob_name" {
  description = "Name of the blob private endpoint for network storage account"
  type        = string
  default     = "pep-sacloumgmtntwk-blob-prd-wus3-01"
}

variable "storage_account_ntwk_pe_file_name" {
  description = "Name of the file private endpoint for network storage account"
  type        = string
  default     = "pep-sacloumgmtntwk-file-prd-wus3-01"
}

variable "storage_account_ntwk_pe_queue_name" {
  description = "Name of the queue private endpoint for network storage account"
  type        = string
  default     = "pep-sacloumgmtntwk-queue-prd-wus3-01"
}

variable "storage_account_ntwk_pe_table_name" {
  description = "Name of the table private endpoint for network storage account"
  type        = string
  default     = "pep-sacloumgmtntwk-table-prd-wus3-01"
}

#--------------------------------------------------------------
# Diagnostic Settings Variables - Resources from Tools Deployment 1
#--------------------------------------------------------------
variable "key_vault_prd_name" {
  description = "Name of the production Key Vault from Tools Deployment 1"
  type        = string
  default     = "kvcloumgmtprdwus301"
}

variable "key_vault_nprd_name" {
  description = "Name of the non-production Key Vault from Tools Deployment 1"
  type        = string
  default     = "kvcloumgmtnprdwus301"
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace from Tools Deployment 1"
  type        = string
  default     = "law-mgmt-prd-wus3-01"
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 90
}

# ============================================
# Standard Landing Zone Variables
# These variables are common across all deployments
# ============================================

variable "hub_vnet_cidr" {
  description = "CIDR block for the hub VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_firewall" {
  description = "Enable Azure Firewall in the hub VNet"
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway for hybrid connectivity"
  type        = bool
  default     = false
}

variable "enable_bastion" {
  description = "Enable Azure Bastion for secure VM access"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Resource tags to apply to all resources"
  type        = map(string)
  default     = {}
}
