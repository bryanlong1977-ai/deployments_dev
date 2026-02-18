variable "subscription_id" {
  description = "The Azure subscription ID for the connectivity subscription"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "East US 2"
}

variable "nsg_resource_group_name" {
  description = "The name of the resource group for NSGs"
  type        = string
  default     = "rg-nsg-hub-prd-eus2-01"
}

variable "nsg_pe_name" {
  description = "The name of the NSG for private endpoints subnet"
  type        = string
  default     = "nsg-hub-pe-prd-eus2-01"
}

variable "nsg_tools_name" {
  description = "The name of the NSG for tools subnet"
  type        = string
  default     = "nsg-hub-tools-prd-eus2-01"
}

variable "nsg_fw_mgmt_name" {
  description = "The name of the NSG for firewall management subnet"
  type        = string
  default     = "nsg-hub-fw-mgmt-prd-eus2-01"
}

variable "nsg_fw_untrust_name" {
  description = "The name of the NSG for firewall untrust subnet"
  type        = string
  default     = "nsg-hub-fw-untrust-prd-eus2-01"
}

variable "nsg_fw_trust_name" {
  description = "The name of the NSG for firewall trust subnet"
  type        = string
  default     = "nsg-hub-fw-trust-prd-eus2-01"
}

variable "subnet_pe_name" {
  description = "The name of the private endpoints subnet"
  type        = string
  default     = "snet-pe-hub-eus2-01"
}

variable "subnet_tools_name" {
  description = "The name of the tools subnet"
  type        = string
  default     = "snet-tools-hub-eus2-01"
}

variable "subnet_fw_mgmt_name" {
  description = "The name of the firewall management subnet"
  type        = string
  default     = "snet-fw-mgmt-hub-eus2-01"
}

variable "subnet_fw_untrust_name" {
  description = "The name of the firewall untrust subnet"
  type        = string
  default     = "snet-fw-untrust-hub-eus2-01"
}

variable "subnet_fw_trust_name" {
  description = "The name of the firewall trust subnet"
  type        = string
  default     = "snet-fw-trust-hub-eus2-01"
}

variable "vnet_name" {
  description = "The name of the hub virtual network"
  type        = string
  default     = "vnet-hub-prd-eus2-01"
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

variable "remote_state_resource_group" {
  description = "Resource group name for remote state storage"
  type        = string
  default     = "rg-storage-ncus-01"
}

variable "remote_state_storage_account" {
  description = "Storage account name for remote state"
  type        = string
  default     = "sacloudaiconsulting01"
}

variable "remote_state_container" {
  description = "Container name for remote state"
  type        = string
  default     = "tfstate"
}

variable "remote_state_subscription_id" {
  description = "Subscription ID for remote state storage"
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
