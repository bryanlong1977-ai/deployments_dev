variable "subscription_id" {
  description = "The subscription ID where resources will be deployed"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "eastus2"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "7e6e79d1-70cd-4feb-8f93-d22e3f2f6fca"
    managed_by    = "Terraform"
  }
}

# Automation Account Variables
variable "automation_account_name" {
  description = "Name of the Automation Account"
  type        = string
  default     = "aa-mgmt-prd-eus2-01"
}

variable "automation_account_resource_group_name" {
  description = "Resource group name for the Automation Account"
  type        = string
  default     = "rg-aa-prd-mgmt-eus2-01"
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

variable "automation_account_private_endpoint_name" {
  description = "Name of the private endpoint for Automation Account"
  type        = string
  default     = "pep-aa-mgmt-prd-eus2-01"
}

# Recovery Services Vault Variables
variable "recovery_services_vault_name" {
  description = "Name of the Recovery Services Vault"
  type        = string
  default     = "rsv-mgmt-prd-eus2-01"
}

variable "recovery_services_vault_resource_group_name" {
  description = "Resource group name for the Recovery Services Vault"
  type        = string
  default     = "rg-rsv-prd-mgmt-eus2-01"
}

variable "recovery_services_vault_sku" {
  description = "SKU for the Recovery Services Vault"
  type        = string
  default     = "Standard"
}

variable "recovery_services_vault_soft_delete_enabled" {
  description = "Whether soft delete is enabled for the Recovery Services Vault"
  type        = bool
  default     = true
}

variable "recovery_services_vault_storage_mode_type" {
  description = "Storage mode type for the Recovery Services Vault"
  type        = string
  default     = "GeoRedundant"
}

variable "recovery_services_vault_cross_region_restore_enabled" {
  description = "Whether cross region restore is enabled"
  type        = bool
  default     = true
}

variable "recovery_services_vault_public_network_access_enabled" {
  description = "Whether public network access is enabled for the Recovery Services Vault"
  type        = bool
  default     = false
}

variable "recovery_services_vault_private_endpoint_name" {
  description = "Name of the private endpoint for Recovery Services Vault"
  type        = string
  default     = "pep-rsv-mgmt-prd-eus2-01"
}

# Storage Account Variables
variable "storage_account_resource_group_name" {
  description = "Resource group name for Storage Accounts"
  type        = string
  default     = "rg-st-prd-mgmt-eus2-01"
}

variable "storage_account_vm_name" {
  description = "Name of the VM diagnostics storage account"
  type        = string
  default     = "sacloumgmtvmprdeus201"
}

variable "storage_account_ntwk_name" {
  description = "Name of the network diagnostics storage account"
  type        = string
  default     = "sacloumgmtntwkprdeus201"
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

variable "storage_account_public_network_access_enabled" {
  description = "Whether public network access is enabled for storage accounts"
  type        = bool
  default     = false
}

variable "storage_account_allow_nested_items_to_be_public" {
  description = "Whether nested items can be public in storage accounts"
  type        = bool
  default     = false
}

variable "storage_account_blob_delete_retention_days" {
  description = "Number of days to retain deleted blobs"
  type        = number
  default     = 90
}

variable "storage_account_container_delete_retention_days" {
  description = "Number of days to retain deleted containers"
  type        = number
  default     = 90
}

# Remote State Configuration Variables
variable "remote_state_resource_group_name" {
  description = "Resource group name for remote state storage"
  type        = string
  default     = "rg-storage-ncus-01"
}

variable "remote_state_storage_account_name" {
  description = "Storage account name for remote state"
  type        = string
  default     = "sacloudaiconsulting01"
}

variable "remote_state_container_name" {
  description = "Container name for remote state"
  type        = string
  default     = "tfstate"
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
