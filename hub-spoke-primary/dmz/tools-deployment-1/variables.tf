#------------------------------------------------------------------------------
# Subscription Variables
#------------------------------------------------------------------------------

variable "subscription_id" {
  description = "The subscription ID for the DMZ subscription"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "identity_subscription_id" {
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

variable "environment" {
  description = "Environment name (e.g., Production, Development)"
  type        = string
  default     = "Production"
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

#------------------------------------------------------------------------------
# Resource Group Variables
#------------------------------------------------------------------------------

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

#------------------------------------------------------------------------------
# Storage Account Variables
#------------------------------------------------------------------------------

variable "storage_account_vm_name" {
  description = "Name of the VM storage account"
  type        = string
  default     = "sacloudmzvmprdwus301"
}

variable "storage_account_network_name" {
  description = "Name of the network storage account"
  type        = string
  default     = "sacloudmznetprdwus301"
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

variable "storage_min_tls_version" {
  description = "Minimum TLS version for storage account"
  type        = string
  default     = "TLS1_2"
}

variable "storage_public_network_access_enabled" {
  description = "Enable public network access for storage account"
  type        = bool
  default     = false
}

variable "storage_allow_nested_items_public" {
  description = "Allow nested items to be public"
  type        = bool
  default     = false
}

variable "storage_shared_access_key_enabled" {
  description = "Enable shared access key for storage account"
  type        = bool
  default     = true
}

variable "blob_delete_retention_days" {
  description = "Number of days to retain deleted blobs"
  type        = number
  default     = 7
}

variable "container_delete_retention_days" {
  description = "Number of days to retain deleted containers"
  type        = number
  default     = 7
}

#------------------------------------------------------------------------------
# Private Endpoint Variables - VM Storage
#------------------------------------------------------------------------------

variable "pe_storage_vm_blob_name" {
  description = "Name of the blob private endpoint for VM storage"
  type        = string
  default     = "pe-sacloudmzvmprdwus301-blob"
}

variable "pe_storage_vm_file_name" {
  description = "Name of the file private endpoint for VM storage"
  type        = string
  default     = "pe-sacloudmzvmprdwus301-file"
}

variable "pe_storage_vm_queue_name" {
  description = "Name of the queue private endpoint for VM storage"
  type        = string
  default     = "pe-sacloudmzvmprdwus301-queue"
}

variable "pe_storage_vm_table_name" {
  description = "Name of the table private endpoint for VM storage"
  type        = string
  default     = "pe-sacloudmzvmprdwus301-table"
}

#------------------------------------------------------------------------------
# Private Endpoint Variables - Network Storage
#------------------------------------------------------------------------------

variable "pe_storage_network_blob_name" {
  description = "Name of the blob private endpoint for network storage"
  type        = string
  default     = "pe-sacloudmznetprdwus301-blob"
}

variable "pe_storage_network_file_name" {
  description = "Name of the file private endpoint for network storage"
  type        = string
  default     = "pe-sacloudmznetprdwus301-file"
}

variable "pe_storage_network_queue_name" {
  description = "Name of the queue private endpoint for network storage"
  type        = string
  default     = "pe-sacloudmznetprdwus301-queue"
}

variable "pe_storage_network_table_name" {
  description = "Name of the table private endpoint for network storage"
  type        = string
  default     = "pe-sacloudmznetprdwus301-table"
}

#------------------------------------------------------------------------------
# Diagnostic Settings Variables
#------------------------------------------------------------------------------

variable "log_retention_days" {
  description = "Number of days to retain logs"
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
