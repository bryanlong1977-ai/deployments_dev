variable "subscription_id" {
  type        = string
  description = "The subscription ID where resources will be deployed"
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "region" {
  type        = string
  description = "The Azure region where resources will be deployed"
  default     = "West US 3"
}

variable "nsg_resource_group_name" {
  type        = string
  description = "The name of the resource group for NSGs"
  default     = "rg-nsg-hub-prd-wus3-01"
}

variable "vnet_name" {
  type        = string
  description = "The name of the Hub VNet"
  default     = "vnet-hub-prd-wus3-01"
}

variable "nsg_pe_name" {
  type        = string
  description = "The name of the NSG for private endpoints subnet"
  default     = "nsg-hub-pe-prd-wus3-01"
}

variable "nsg_tools_name" {
  type        = string
  description = "The name of the NSG for tools subnet"
  default     = "nsg-hub-tools-prd-wus3-01"
}

variable "nsg_fw_mgmt_name" {
  type        = string
  description = "The name of the NSG for firewall management subnet"
  default     = "nsg-hub-fw-mgmt-prd-wus3-01"
}

variable "nsg_fw_untrust_name" {
  type        = string
  description = "The name of the NSG for firewall untrust subnet"
  default     = "nsg-hub-fw-untrust-prd-wus3-01"
}

variable "nsg_fw_trust_name" {
  type        = string
  description = "The name of the NSG for firewall trust subnet"
  default     = "nsg-hub-fw-trust-prd-wus3-01"
}

variable "subnet_pe_name" {
  type        = string
  description = "The name of the private endpoints subnet"
  default     = "snet-pe-hub-wus3-01"
}

variable "subnet_tools_name" {
  type        = string
  description = "The name of the tools subnet"
  default     = "snet-tools-hub-wus3-01"
}

variable "subnet_fw_mgmt_name" {
  type        = string
  description = "The name of the firewall management subnet"
  default     = "snet-fw-mgmt-hub-wus3-01"
}

variable "subnet_fw_untrust_name" {
  type        = string
  description = "The name of the firewall untrust subnet"
  default     = "snet-fw-untrust-hub-wus3-01"
}

variable "subnet_fw_trust_name" {
  type        = string
  description = "The name of the firewall trust subnet"
  default     = "snet-fw-trust-hub-wus3-01"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "8b492308-bab3-41e1-a8cb-1348dfea4227"
    deployed_by   = "Terraform"
  }
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
