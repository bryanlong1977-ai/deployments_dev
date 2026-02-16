variable "subscription_id" {
  description = "The subscription ID where resources will be deployed"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

variable "nsg_resource_group_name" {
  description = "The name of the resource group for NSGs"
  type        = string
  default     = "rg-nsg-idm-prd-wus3-01"
}

variable "vnet_name" {
  description = "The name of the Identity VNet"
  type        = string
  default     = "vnet-idm-prd-wus3-01"
}

variable "nsg_pe_name" {
  description = "The name of the NSG for Private Endpoints subnet"
  type        = string
  default     = "nsg-idm-pe-prd-wus3-01"
}

variable "nsg_tools_name" {
  description = "The name of the NSG for Tools subnet"
  type        = string
  default     = "nsg-idm-tools-prd-wus3-01"
}

variable "nsg_inbound_name" {
  description = "The name of the NSG for DNS Resolver Inbound subnet"
  type        = string
  default     = "nsg-idm-inbound-prd-wus3-01"
}

variable "nsg_outbound_name" {
  description = "The name of the NSG for DNS Resolver Outbound subnet"
  type        = string
  default     = "nsg-idm-outbound-prd-wus3-01"
}

variable "nsg_dc_name" {
  description = "The name of the NSG for Domain Controllers subnet"
  type        = string
  default     = "nsg-idm-dc-prd-wus3-01"
}

variable "nsg_ib_mgmt_name" {
  description = "The name of the NSG for Infoblox Management subnet"
  type        = string
  default     = "nsg-idm-ib-mgmt-prd-wus3-01"
}

variable "nsg_ib_lan1_name" {
  description = "The name of the NSG for Infoblox LAN1 subnet"
  type        = string
  default     = "nsg-idm-ib-lan1-prd-wus3-01"
}

variable "subnet_pe_name" {
  description = "The name of the Private Endpoints subnet"
  type        = string
  default     = "snet-pe-idm-wus3-01"
}

variable "subnet_tools_name" {
  description = "The name of the Tools subnet"
  type        = string
  default     = "snet-tools-idm-wus3-01"
}

variable "subnet_inbound_name" {
  description = "The name of the DNS Resolver Inbound subnet"
  type        = string
  default     = "snet-inbound-idm-wus3-01"
}

variable "subnet_outbound_name" {
  description = "The name of the DNS Resolver Outbound subnet"
  type        = string
  default     = "snet-outbound-idm-wus3-01"
}

variable "subnet_dc_name" {
  description = "The name of the Domain Controllers subnet"
  type        = string
  default     = "snet-dc-idm-wus3-01"
}

variable "subnet_ib_mgmt_name" {
  description = "The name of the Infoblox Management subnet"
  type        = string
  default     = "snet-ib-mgmt-idm-wus3-01"
}

variable "subnet_ib_lan1_name" {
  description = "The name of the Infoblox LAN1 subnet"
  type        = string
  default     = "snet-ib-lan1-idm-wus3-01"
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
