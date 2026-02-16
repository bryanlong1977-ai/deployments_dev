# Variables for NSG Deployment 1 - DMZ Subscription

variable "subscription_id" {
  description = "The Azure subscription ID for the DMZ subscription"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "West US 3"
}

variable "nsg_resource_group_name" {
  description = "The name of the resource group for NSGs"
  type        = string
  default     = "rg-nsg-dmz-prd-wus3-01"
}

variable "vnet_name" {
  description = "The name of the DMZ virtual network"
  type        = string
  default     = "vnet-dmz-prd-wus3-01"
}

# NSG Names
variable "nsg_pe_name" {
  description = "The name of the NSG for private endpoints subnet"
  type        = string
  default     = "nsg-dmz-pe-prd-wus3-01"
}

variable "nsg_tools_name" {
  description = "The name of the NSG for tools subnet"
  type        = string
  default     = "nsg-dmz-tools-prd-wus3-01"
}

variable "nsg_ns_mgmt_name" {
  description = "The name of the NSG for NetScaler management subnet"
  type        = string
  default     = "nsg-dmz-ns-mgmt-prd-wus3-01"
}

variable "nsg_ns_client_name" {
  description = "The name of the NSG for NetScaler client subnet"
  type        = string
  default     = "nsg-dmz-ns-client-prd-wus3-01"
}

variable "nsg_ns_server_name" {
  description = "The name of the NSG for NetScaler server subnet"
  type        = string
  default     = "nsg-dmz-ns-server-prd-wus3-01"
}

variable "nsg_ifw_mgmt_name" {
  description = "The name of the NSG for ingress firewall management subnet"
  type        = string
  default     = "nsg-dmz-ifw-mgmt-prd-wus3-01"
}

variable "nsg_ifw_untrust_name" {
  description = "The name of the NSG for ingress firewall untrust subnet"
  type        = string
  default     = "nsg-dmz-ifw-untrust-prd-wus3-01"
}

variable "nsg_ifw_trust_name" {
  description = "The name of the NSG for ingress firewall trust subnet"
  type        = string
  default     = "nsg-dmz-ifw-trust-prd-wus3-01"
}

# Subnet Names
variable "subnet_pe_name" {
  description = "The name of the private endpoints subnet"
  type        = string
  default     = "snet-pe-dmz-wus3-01"
}

variable "subnet_tools_name" {
  description = "The name of the tools subnet"
  type        = string
  default     = "snet-tools-dmz-wus3-01"
}

variable "subnet_ns_mgmt_name" {
  description = "The name of the NetScaler management subnet"
  type        = string
  default     = "snet-ns-mgmt-dmz-wus3-01"
}

variable "subnet_ns_client_name" {
  description = "The name of the NetScaler client subnet"
  type        = string
  default     = "snet-ns-client-dmz-wus3-01"
}

variable "subnet_ns_server_name" {
  description = "The name of the NetScaler server subnet"
  type        = string
  default     = "snet-ns-server-dmz-wus3-01"
}

variable "subnet_ifw_mgmt_name" {
  description = "The name of the ingress firewall management subnet"
  type        = string
  default     = "snet-ifw-mgmt-dmz-wus3-01"
}

variable "subnet_ifw_untrust_name" {
  description = "The name of the ingress firewall untrust subnet"
  type        = string
  default     = "snet-ifw-untrust-dmz-wus3-01"
}

variable "subnet_ifw_trust_name" {
  description = "The name of the ingress firewall trust subnet"
  type        = string
  default     = "snet-ifw-trust-dmz-wus3-01"
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "8b492308-bab3-41e1-a8cb-1348dfea4227"
    subscription  = "dmz"
    managed_by    = "Terraform"
  }
}

# Remote State Configuration
variable "tfstate_resource_group_name" {
  description = "The resource group name for Terraform state storage"
  type        = string
  default     = "rg-storage-ncus-01"
}

variable "tfstate_storage_account_name" {
  description = "The storage account name for Terraform state"
  type        = string
  default     = "sacloudaiconsulting01"
}

variable "tfstate_container_name" {
  description = "The container name for Terraform state"
  type        = string
  default     = "tfstate"
}

variable "tfstate_subscription_id" {
  description = "The subscription ID where Terraform state is stored"
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
