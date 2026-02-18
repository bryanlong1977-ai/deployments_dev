variable "subscription_id" {
  description = "The Azure subscription ID for the DMZ subscription"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "East US 2"
}

variable "nsg_resource_group_name" {
  description = "Name of the resource group for NSGs"
  type        = string
  default     = "rg-nsg-dmz-prd-eus2-01"
}

variable "vnet_name" {
  description = "Name of the DMZ VNet"
  type        = string
  default     = "vnet-dmz-prd-eus2-01"
}

variable "nsg_pe_name" {
  description = "Name of the NSG for Private Endpoints subnet"
  type        = string
  default     = "nsg-dmz-pe-prd-eus2-01"
}

variable "nsg_tools_name" {
  description = "Name of the NSG for Tools subnet"
  type        = string
  default     = "nsg-dmz-tools-prd-eus2-01"
}

variable "nsg_ns_mgmt_name" {
  description = "Name of the NSG for NetScaler Management subnet"
  type        = string
  default     = "nsg-dmz-ns-mgmt-prd-eus2-01"
}

variable "nsg_ns_client_name" {
  description = "Name of the NSG for NetScaler Client subnet"
  type        = string
  default     = "nsg-dmz-ns-client-prd-eus2-01"
}

variable "nsg_ns_server_name" {
  description = "Name of the NSG for NetScaler Server subnet"
  type        = string
  default     = "nsg-dmz-ns-server-prd-eus2-01"
}

variable "nsg_ifw_mgmt_name" {
  description = "Name of the NSG for Ingress Firewall Management subnet"
  type        = string
  default     = "nsg-dmz-ifw-mgmt-prd-eus2-01"
}

variable "nsg_ifw_untrust_name" {
  description = "Name of the NSG for Ingress Firewall Untrust subnet"
  type        = string
  default     = "nsg-dmz-ifw-untrust-prd-eus2-01"
}

variable "nsg_ifw_trust_name" {
  description = "Name of the NSG for Ingress Firewall Trust subnet"
  type        = string
  default     = "nsg-dmz-ifw-trust-prd-eus2-01"
}

variable "subnet_pe_name" {
  description = "Name of the Private Endpoints subnet"
  type        = string
  default     = "snet-pe-dmz-eus2-01"
}

variable "subnet_tools_name" {
  description = "Name of the Tools subnet"
  type        = string
  default     = "snet-tools-dmz-eus2-01"
}

variable "subnet_ns_mgmt_name" {
  description = "Name of the NetScaler Management subnet"
  type        = string
  default     = "snet-ns-mgmt-dmz-eus2-01"
}

variable "subnet_ns_client_name" {
  description = "Name of the NetScaler Client subnet"
  type        = string
  default     = "snet-ns-client-dmz-eus2-01"
}

variable "subnet_ns_server_name" {
  description = "Name of the NetScaler Server subnet"
  type        = string
  default     = "snet-ns-server-dmz-eus2-01"
}

variable "subnet_ifw_mgmt_name" {
  description = "Name of the Ingress Firewall Management subnet"
  type        = string
  default     = "snet-ifw-mgmt-dmz-eus2-01"
}

variable "subnet_ifw_untrust_name" {
  description = "Name of the Ingress Firewall Untrust subnet"
  type        = string
  default     = "snet-ifw-untrust-dmz-eus2-01"
}

variable "subnet_ifw_trust_name" {
  description = "Name of the Ingress Firewall Trust subnet"
  type        = string
  default     = "snet-ifw-trust-dmz-eus2-01"
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
