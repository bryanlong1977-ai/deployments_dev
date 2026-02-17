#--------------------------------------------------------------
# Provider Variables
#--------------------------------------------------------------
variable "subscription_id" {
  description = "The Azure subscription ID for the Connectivity subscription"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "West US 3"
}

#--------------------------------------------------------------
# Resource Group Variables
#--------------------------------------------------------------
variable "nsg_resource_group_name" {
  description = "Name of the resource group for Network Security Groups"
  type        = string
  default     = "rg-nsg-hub-prd-wus3-01"
}

#--------------------------------------------------------------
# NSG Name Variables
#--------------------------------------------------------------
variable "nsg_pe_name" {
  description = "Name of the NSG for Private Endpoints subnet"
  type        = string
  default     = "nsg-hub-pe-prd-wus3-01"
}

variable "nsg_tools_name" {
  description = "Name of the NSG for Tools subnet"
  type        = string
  default     = "nsg-hub-tools-prd-wus3-01"
}

variable "nsg_fw_mgmt_name" {
  description = "Name of the NSG for Firewall Management subnet"
  type        = string
  default     = "nsg-hub-fw-mgmt-prd-wus3-01"
}

variable "nsg_fw_untrust_name" {
  description = "Name of the NSG for Firewall Untrust subnet"
  type        = string
  default     = "nsg-hub-fw-untrust-prd-wus3-01"
}

variable "nsg_fw_trust_name" {
  description = "Name of the NSG for Firewall Trust subnet"
  type        = string
  default     = "nsg-hub-fw-trust-prd-wus3-01"
}

#--------------------------------------------------------------
# Subnet Name Variables
#--------------------------------------------------------------
variable "subnet_pe_name" {
  description = "Name of the Private Endpoints subnet"
  type        = string
  default     = "snet-pe-hub-wus3-01"
}

variable "subnet_tools_name" {
  description = "Name of the Tools subnet"
  type        = string
  default     = "snet-tools-hub-wus3-01"
}

variable "subnet_fw_mgmt_name" {
  description = "Name of the Firewall Management subnet"
  type        = string
  default     = "snet-fw-mgmt-hub-wus3-01"
}

variable "subnet_fw_untrust_name" {
  description = "Name of the Firewall Untrust subnet"
  type        = string
  default     = "snet-fw-untrust-hub-wus3-01"
}

variable "subnet_fw_trust_name" {
  description = "Name of the Firewall Trust subnet"
  type        = string
  default     = "snet-fw-trust-hub-wus3-01"
}

#--------------------------------------------------------------
# VNet Variables
#--------------------------------------------------------------
variable "vnet_name" {
  description = "Name of the Hub Virtual Network"
  type        = string
  default     = "vnet-hub-prd-wus3-01"
}

#--------------------------------------------------------------
# Tag Variables
#--------------------------------------------------------------
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "925e43c3-6edd-4030-9310-0f384ef3ac0b"
    managed_by    = "Terraform"
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
