variable "subscription_id" {
  description = "The subscription ID where resources will be deployed"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
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
    deployment_id = "925e43c3-6edd-4030-9310-0f384ef3ac0b"
    subscription  = "dmz"
  }
}

# Resource Group Names
variable "storage_resource_group_name" {
  description = "Name of the resource group for storage accounts"
  type        = string
  default     = "rg-st-prd-dmz-wus3-01"
}

variable "rsv_resource_group_name" {
  description = "Name of the resource group for Recovery Services Vault"
  type        = string
  default     = "rg-rsv-prd-dmz-wus3-01"
}

# Storage Account Names
variable "storage_account_vm_name" {
  description = "Name of the storage account for VM diagnostics"
  type        = string
  default     = "sacloudmzvmprdwus301"
}

variable "storage_account_net_name" {
  description = "Name of the storage account for network diagnostics"
  type        = string
  default     = "sacloudmznetprdwus301"
}

# Storage Account Configuration
variable "storage_account_tier" {
  description = "The tier of the storage account"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "The replication type for the storage account"
  type        = string
  default     = "GRS"
}

variable "storage_account_kind" {
  description = "The kind of storage account"
  type        = string
  default     = "StorageV2"
}

variable "storage_min_tls_version" {
  description = "Minimum TLS version for storage account"
  type        = string
  default     = "TLS1_2"
}

variable "storage_public_network_access_enabled" {
  description = "Whether public network access is enabled for storage accounts"
  type        = bool
  default     = false
}

variable "storage_allow_nested_items_public" {
  description = "Whether nested items can be public in storage accounts"
  type        = bool
  default     = false
}

variable "storage_shared_access_key_enabled" {
  description = "Whether shared access key is enabled for storage accounts"
  type        = bool
  default     = true
}

variable "storage_https_traffic_only_enabled" {
  description = "Whether HTTPS traffic only is enabled"
  type        = bool
  default     = true
}

variable "storage_blob_delete_retention_days" {
  description = "Number of days to retain deleted blobs"
  type        = number
  default     = 90
}

variable "storage_container_delete_retention_days" {
  description = "Number of days to retain deleted containers"
  type        = number
  default     = 90
}

# Private Endpoint Names
variable "pe_storage_vm_blob_name" {
  description = "Name of the private endpoint for VM storage blob"
  type        = string
  default     = "pe-sacloudmzvmprdwus301-blob"
}

variable "pe_storage_vm_file_name" {
  description = "Name of the private endpoint for VM storage file"
  type        = string
  default     = "pe-sacloudmzvmprdwus301-file"
}

variable "pe_storage_vm_queue_name" {
  description = "Name of the private endpoint for VM storage queue"
  type        = string
  default     = "pe-sacloudmzvmprdwus301-queue"
}

variable "pe_storage_vm_table_name" {
  description = "Name of the private endpoint for VM storage table"
  type        = string
  default     = "pe-sacloudmzvmprdwus301-table"
}

variable "pe_storage_net_blob_name" {
  description = "Name of the private endpoint for Net storage blob"
  type        = string
  default     = "pe-sacloudmznetprdwus301-blob"
}

variable "pe_storage_net_file_name" {
  description = "Name of the private endpoint for Net storage file"
  type        = string
  default     = "pe-sacloudmznetprdwus301-file"
}

variable "pe_storage_net_queue_name" {
  description = "Name of the private endpoint for Net storage queue"
  type        = string
  default     = "pe-sacloudmznetprdwus301-queue"
}

variable "pe_storage_net_table_name" {
  description = "Name of the private endpoint for Net storage table"
  type        = string
  default     = "pe-sacloudmznetprdwus301-table"
}

# Remote State Configuration
variable "tfstate_resource_group_name" {
  description = "Resource group name for Terraform state storage"
  type        = string
  default     = "rg-storage-ncus-01"
}

variable "tfstate_storage_account_name" {
  description = "Storage account name for Terraform state"
  type        = string
  default     = "sacloudaiconsulting01"
}

variable "tfstate_container_name" {
  description = "Container name for Terraform state"
  type        = string
  default     = "tfstate"
}

variable "tfstate_subscription_id" {
  description = "Subscription ID for Terraform state storage"
  type        = string
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
