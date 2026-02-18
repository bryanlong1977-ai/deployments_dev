variable "subscription_id" {
  description = "The Azure subscription ID where resources will be created"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "region" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "East US 2"
}

variable "nsg_resource_group_name" {
  description = "The name of the resource group for NSGs"
  type        = string
  default     = "rg-nsg-idm-prd-eus2-01"
}

variable "nsg_pe_name" {
  description = "The name of the NSG for private endpoints subnet"
  type        = string
  default     = "nsg-idm-pe-prd-eus2-01"
}

variable "nsg_tools_name" {
  description = "The name of the NSG for tools subnet"
  type        = string
  default     = "nsg-idm-tools-prd-eus2-01"
}

variable "nsg_inbound_name" {
  description = "The name of the NSG for DNS resolver inbound subnet"
  type        = string
  default     = "nsg-idm-inbound-prd-eus2-01"
}

variable "nsg_outbound_name" {
  description = "The name of the NSG for DNS resolver outbound subnet"
  type        = string
  default     = "nsg-idm-outbound-prd-eus2-01"
}

variable "nsg_dc_name" {
  description = "The name of the NSG for domain controllers subnet"
  type        = string
  default     = "nsg-idm-dc-prd-eus2-01"
}

variable "nsg_ib_mgmt_name" {
  description = "The name of the NSG for Infoblox management subnet"
  type        = string
  default     = "nsg-idm-ib-mgmt-prd-eus2-01"
}

variable "nsg_ib_lan1_name" {
  description = "The name of the NSG for Infoblox LAN1 subnet"
  type        = string
  default     = "nsg-idm-ib-lan1-prd-eus2-01"
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "vnet-idm-prd-eus2-01"
}

variable "subnet_pe_name" {
  description = "The name of the private endpoints subnet"
  type        = string
  default     = "snet-pe-idm-eus2-01"
}

variable "subnet_tools_name" {
  description = "The name of the tools subnet"
  type        = string
  default     = "snet-tools-idm-eus2-01"
}

variable "subnet_inbound_name" {
  description = "The name of the DNS resolver inbound subnet"
  type        = string
  default     = "snet-inbound-idm-eus2-01"
}

variable "subnet_outbound_name" {
  description = "The name of the DNS resolver outbound subnet"
  type        = string
  default     = "snet-outbound-idm-eus2-01"
}

variable "subnet_dc_name" {
  description = "The name of the domain controllers subnet"
  type        = string
  default     = "snet-dc-idm-eus2-01"
}

variable "subnet_ib_mgmt_name" {
  description = "The name of the Infoblox management subnet"
  type        = string
  default     = "snet-ib-mgmt-idm-eus2-01"
}

variable "subnet_ib_lan1_name" {
  description = "The name of the Infoblox LAN1 subnet"
  type        = string
  default     = "snet-ib-lan1-idm-eus2-01"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "7e6e79d1-70cd-4feb-8f93-d22e3f2f6fca"
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
