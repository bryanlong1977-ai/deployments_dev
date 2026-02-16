# Variables for NSG Deployment 1 - Management Subscription

variable "subscription_id" {
  description = "The Azure subscription ID for the Management subscription"
  type        = string
  default     = "39f647ab-5261-47b0-ad91-1719dcd107a1"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

variable "environment" {
  description = "The environment name (e.g., Production, Development)"
  type        = string
  default     = "Production"
}

variable "nsg_resource_group_name" {
  description = "Name of the resource group for NSGs"
  type        = string
  default     = "rg-nsg-mgmt-prd-wus3-01"
}

variable "nsg_pe_name" {
  description = "Name of the NSG for Private Endpoint subnet"
  type        = string
  default     = "nsg-mgmt-pe-prd-wus3-01"
}

variable "nsg_tools_name" {
  description = "Name of the NSG for Tools subnet"
  type        = string
  default     = "nsg-mgmt-tools-prd-wus3-01"
}

variable "vnet_name" {
  description = "Name of the Management VNet"
  type        = string
  default     = "vnet-mgmt-prd-wus3-01"
}

variable "subnet_pe_name" {
  description = "Name of the Private Endpoint subnet"
  type        = string
  default     = "snet-pe-mgmt-wus3-01"
}

variable "subnet_tools_name" {
  description = "Name of the Tools subnet"
  type        = string
  default     = "snet-tools-mgmt-wus3-01"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "8b492308-bab3-41e1-a8cb-1348dfea4227"
    subscription  = "management"
    managed_by    = "Terraform"
  }
}

# Remote State Configuration Variables
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
