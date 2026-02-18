variable "subscription_id" {
  type        = string
  description = "The subscription ID where resources will be deployed"
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "region" {
  type        = string
  description = "The Azure region for resource deployment"
  default     = "eastus2"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "7e6e79d1-70cd-4feb-8f93-d22e3f2f6fca"
    subscription  = "dmz"
  }
}

# Resource Group Names
variable "storage_resource_group_name" {
  type        = string
  description = "Name of the resource group for storage accounts"
  default     = "rg-st-prd-dmz-eus2-01"
}

variable "rsv_resource_group_name" {
  type        = string
  description = "Name of the resource group for recovery services vault"
  default     = "rg-rsv-prd-dmz-eus2-01"
}

# Storage Account Names
variable "storage_account_vm_name" {
  type        = string
  description = "Name of the storage account for VM diagnostics"
  default     = "sacloudmzvmprdeus201"
}

variable "storage_account_network_name" {
  type        = string
  description = "Name of the storage account for network diagnostics"
  default     = "sacloudmznetprdeus201"
}

# Storage Account Configuration
variable "storage_account_tier" {
  type        = string
  description = "The tier of the storage account"
  default     = "Standard"
}

variable "storage_account_replication_type" {
  type        = string
  description = "The replication type for the storage account"
  default     = "GRS"
}

variable "storage_account_kind" {
  type        = string
  description = "The kind of storage account"
  default     = "StorageV2"
}

variable "storage_min_tls_version" {
  type        = string
  description = "Minimum TLS version for the storage account"
  default     = "TLS1_2"
}

variable "storage_public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is enabled for storage accounts"
  default     = false
}

variable "storage_allow_nested_items_public" {
  type        = bool
  description = "Whether nested items can be public in storage accounts"
  default     = false
}

variable "storage_shared_access_key_enabled" {
  type        = bool
  description = "Whether shared access key is enabled for storage accounts"
  default     = true
}

variable "storage_blob_retention_days" {
  type        = number
  description = "Number of days to retain deleted blobs"
  default     = 90
}

variable "storage_container_retention_days" {
  type        = number
  description = "Number of days to retain deleted containers"
  default     = 90
}

# Recovery Services Vault Configuration
variable "recovery_services_vault_name" {
  type        = string
  description = "Name of the recovery services vault"
  default     = "rsv-dmz-prd-eus2-01"
}

variable "rsv_sku" {
  type        = string
  description = "SKU for the recovery services vault"
  default     = "Standard"
}

variable "rsv_storage_mode_type" {
  type        = string
  description = "Storage mode type for the recovery services vault"
  default     = "GeoRedundant"
}

variable "rsv_cross_region_restore_enabled" {
  type        = bool
  description = "Whether cross region restore is enabled"
  default     = true
}

variable "rsv_soft_delete_enabled" {
  type        = bool
  description = "Whether soft delete is enabled for the recovery services vault"
  default     = true
}

variable "rsv_public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is enabled for the recovery services vault"
  default     = false
}

# Remote State Configuration
variable "tfstate_resource_group_name" {
  type        = string
  description = "Resource group name for terraform state storage"
  default     = "rg-storage-ncus-01"
}

variable "tfstate_storage_account_name" {
  type        = string
  description = "Storage account name for terraform state"
  default     = "sacloudaiconsulting01"
}

variable "tfstate_container_name" {
  type        = string
  description = "Container name for terraform state"
  default     = "tfstate"
}

variable "tfstate_subscription_id" {
  type        = string
  description = "Subscription ID for terraform state storage"
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
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
