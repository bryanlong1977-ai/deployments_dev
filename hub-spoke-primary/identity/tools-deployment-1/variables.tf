#------------------------------------------------------------------------------
# Subscription Variables
#------------------------------------------------------------------------------

variable "subscription_id" {
  description = "The subscription ID for the Identity subscription"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "management_subscription_id" {
  description = "The subscription ID for the Management subscription"
  type        = string
  default     = "39f647ab-5261-47b0-ad91-1719dcd107a1"
}

#------------------------------------------------------------------------------
# Common Variables
#------------------------------------------------------------------------------

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "8b492308-bab3-41e1-a8cb-1348dfea4227"
    managed_by    = "Terraform"
  }
}

#------------------------------------------------------------------------------
# Resource Group Variables
#------------------------------------------------------------------------------

variable "rsv_resource_group_name" {
  description = "Name of the resource group for Recovery Services Vault"
  type        = string
  default     = "rg-rsv-prd-idm-wus3-01"
}

variable "storage_resource_group_name" {
  description = "Name of the resource group for Storage Accounts"
  type        = string
  default     = "rg-st-prd-idm-wus3-01"
}

#------------------------------------------------------------------------------
# Recovery Services Vault Variables
#------------------------------------------------------------------------------

variable "rsv_name" {
  description = "Name of the Recovery Services Vault"
  type        = string
  default     = "rsv-idm-prd-wus3-01"
}

variable "rsv_sku" {
  description = "SKU of the Recovery Services Vault"
  type        = string
  default     = "Standard"
}

variable "rsv_storage_mode_type" {
  description = "Storage mode type for Recovery Services Vault"
  type        = string
  default     = "GeoRedundant"
}

variable "rsv_cross_region_restore_enabled" {
  description = "Enable cross-region restore for Recovery Services Vault"
  type        = bool
  default     = true
}

variable "rsv_soft_delete_enabled" {
  description = "Enable soft delete for Recovery Services Vault"
  type        = bool
  default     = true
}

variable "rsv_public_network_access_enabled" {
  description = "Enable public network access for Recovery Services Vault"
  type        = bool
  default     = false
}

variable "rsv_backup_pe_name" {
  description = "Name of the private endpoint for RSV Azure Backup"
  type        = string
  default     = "pep-rsv-idm-backup-prd-wus3-01"
}

variable "rsv_siterecovery_pe_name" {
  description = "Name of the private endpoint for RSV Site Recovery"
  type        = string
  default     = "pep-rsv-idm-siterecovery-prd-wus3-01"
}

#------------------------------------------------------------------------------
# Storage Account Variables
#------------------------------------------------------------------------------

variable "storage_account_vm_name" {
  description = "Name of the VM diagnostics storage account"
  type        = string
  default     = "saclouidmvmprdwus301"
}

variable "storage_account_ntwk_name" {
  description = "Name of the network diagnostics storage account"
  type        = string
  default     = "saclouidmntwkprdwus301"
}

variable "storage_account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "GRS"
}

variable "storage_account_kind" {
  description = "Storage account kind"
  type        = string
  default     = "StorageV2"
}

variable "storage_account_min_tls_version" {
  description = "Minimum TLS version for storage account"
  type        = string
  default     = "TLS1_2"
}

variable "storage_account_allow_blob_public_access" {
  description = "Allow blob public access for storage account"
  type        = bool
  default     = false
}

variable "storage_account_public_network_access_enabled" {
  description = "Enable public network access for storage account"
  type        = bool
  default     = false
}

variable "storage_account_shared_access_key_enabled" {
  description = "Enable shared access key for storage account"
  type        = bool
  default     = true
}

variable "storage_account_default_network_action" {
  description = "Default network action for storage account firewall"
  type        = string
  default     = "Deny"
}

variable "storage_account_network_bypass" {
  description = "Network bypass options for storage account"
  type        = list(string)
  default     = ["AzureServices", "Logging", "Metrics"]
}

variable "storage_account_blob_retention_days" {
  description = "Blob soft delete retention days"
  type        = number
  default     = 90
}

variable "storage_account_container_retention_days" {
  description = "Container soft delete retention days"
  type        = number
  default     = 90
}

#------------------------------------------------------------------------------
# Private Endpoint Names - VM Storage
#------------------------------------------------------------------------------

variable "storage_vm_blob_pe_name" {
  description = "Name of the private endpoint for VM storage blob"
  type        = string
  default     = "pep-saclouidmvm-blob-prd-wus3-01"
}

variable "storage_vm_file_pe_name" {
  description = "Name of the private endpoint for VM storage file"
  type        = string
  default     = "pep-saclouidmvm-file-prd-wus3-01"
}

variable "storage_vm_queue_pe_name" {
  description = "Name of the private endpoint for VM storage queue"
  type        = string
  default     = "pep-saclouidmvm-queue-prd-wus3-01"
}

variable "storage_vm_table_pe_name" {
  description = "Name of the private endpoint for VM storage table"
  type        = string
  default     = "pep-saclouidmvm-table-prd-wus3-01"
}

#------------------------------------------------------------------------------
# Private Endpoint Names - Network Storage
#------------------------------------------------------------------------------

variable "storage_ntwk_blob_pe_name" {
  description = "Name of the private endpoint for network storage blob"
  type        = string
  default     = "pep-saclouidmntwk-blob-prd-wus3-01"
}

variable "storage_ntwk_file_pe_name" {
  description = "Name of the private endpoint for network storage file"
  type        = string
  default     = "pep-saclouidmntwk-file-prd-wus3-01"
}

variable "storage_ntwk_queue_pe_name" {
  description = "Name of the private endpoint for network storage queue"
  type        = string
  default     = "pep-saclouidmntwk-queue-prd-wus3-01"
}

variable "storage_ntwk_table_pe_name" {
  description = "Name of the private endpoint for network storage table"
  type        = string
  default     = "pep-saclouidmntwk-table-prd-wus3-01"
}

#------------------------------------------------------------------------------
# Diagnostic Settings Variables
#------------------------------------------------------------------------------

variable "diagnostic_retention_days" {
  description = "Retention days for diagnostic logs"
  type        = number
  default     = 90
}

# ============================================
# Standard Landing Zone Variables
# These variables are common across all deployments
# ============================================

variable "customer_name" {
  description = "Customer name for the Landing Zone"
  type        = string
}

variable "project_name" {
  description = "Project name for the Landing Zone"
  type        = string
}

variable "environment" {
  description = "Environment (production, staging, development)"
  type        = string
  default     = "production"
}

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
