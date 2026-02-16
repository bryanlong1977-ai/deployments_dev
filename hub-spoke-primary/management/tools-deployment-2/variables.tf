variable "subscription_id" {
  description = "The subscription ID for the Management subscription"
  type        = string
  default     = "39f647ab-5261-47b0-ad91-1719dcd107a1"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "8b492308-bab3-41e1-a8cb-1348dfea4227"
    managed_by    = "Terraform"
  }
}

# Automation Account Variables
variable "automation_account_name" {
  description = "Name of the Automation Account"
  type        = string
  default     = "aa-mgmt-prd-wus3-01"
}

variable "automation_account_resource_group_name" {
  description = "Name of the resource group for the Automation Account"
  type        = string
  default     = "rg-aa-prd-mgmt-wus3-01"
}

variable "automation_account_sku" {
  description = "SKU for the Automation Account"
  type        = string
  default     = "Basic"
}

variable "automation_account_public_network_access_enabled" {
  description = "Whether public network access is enabled for the Automation Account"
  type        = bool
  default     = false
}

variable "automation_account_local_authentication_enabled" {
  description = "Whether local authentication is enabled for the Automation Account"
  type        = bool
  default     = false
}

variable "automation_account_private_endpoint_name" {
  description = "Name of the private endpoint for the Automation Account"
  type        = string
  default     = "pep-aa-mgmt-prd-wus3-01"
}

# Recovery Services Vault Variables
variable "recovery_services_vault_name" {
  description = "Name of the Recovery Services Vault"
  type        = string
  default     = "rsv-mgmt-prd-wus3-01"
}

variable "recovery_services_vault_resource_group_name" {
  description = "Name of the resource group for the Recovery Services Vault"
  type        = string
  default     = "rg-rsv-prd-mgmt-wus3-01"
}

variable "recovery_services_vault_sku" {
  description = "SKU for the Recovery Services Vault"
  type        = string
  default     = "Standard"
}

variable "recovery_services_vault_storage_mode" {
  description = "Storage mode type for the Recovery Services Vault"
  type        = string
  default     = "GeoRedundant"
}

variable "recovery_services_vault_cross_region_restore_enabled" {
  description = "Whether cross region restore is enabled"
  type        = bool
  default     = true
}

variable "recovery_services_vault_soft_delete_enabled" {
  description = "Whether soft delete is enabled for the Recovery Services Vault"
  type        = bool
  default     = true
}

variable "recovery_services_vault_public_network_access_enabled" {
  description = "Whether public network access is enabled for the Recovery Services Vault"
  type        = bool
  default     = false
}

variable "recovery_services_vault_private_endpoint_name" {
  description = "Name of the private endpoint for the Recovery Services Vault"
  type        = string
  default     = "pep-rsv-mgmt-prd-wus3-01"
}

# Storage Account Variables
variable "storage_resource_group_name" {
  description = "Name of the resource group for storage accounts"
  type        = string
  default     = "rg-st-prd-mgmt-wus3-01"
}

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
  description = "Performance tier of the storage accounts"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Replication type for the storage accounts"
  type        = string
  default     = "GRS"
}

variable "storage_account_kind" {
  description = "Kind of storage account"
  type        = string
  default     = "StorageV2"
}

variable "storage_account_min_tls_version" {
  description = "Minimum TLS version for the storage accounts"
  type        = string
  default     = "TLS1_2"
}

variable "storage_account_public_network_access_enabled" {
  description = "Whether public network access is enabled for storage accounts"
  type        = bool
  default     = false
}

variable "storage_account_allow_nested_items_to_be_public" {
  description = "Whether nested items can be public"
  type        = bool
  default     = false
}

variable "storage_account_shared_access_key_enabled" {
  description = "Whether shared access key is enabled"
  type        = bool
  default     = true
}

variable "storage_account_blob_retention_days" {
  description = "Number of days to retain deleted blobs"
  type        = number
  default     = 90
}

variable "storage_account_container_retention_days" {
  description = "Number of days to retain deleted containers"
  type        = number
  default     = 90
}

# Tools Deployment 1 Resource Names (for diagnostic settings)
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

# Diagnostic Settings
variable "diagnostic_retention_days" {
  description = "Number of days to retain diagnostic logs"
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
