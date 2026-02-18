# Variables for Route Table Deployment 1 - Connectivity Subscription

variable "subscription_id" {
  description = "The Azure subscription ID for the Connectivity subscription"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "East US 2"
}

variable "route_table_name" {
  description = "The name of the route table"
  type        = string
  default     = "rt-hub-prd-eus2-01"
}

variable "route_table_resource_group_name" {
  description = "The name of the resource group for the route table"
  type        = string
  default     = "rg-rt-hub-prd-eus2-01"
}

variable "vnet_name" {
  description = "The name of the virtual network this route table is associated with"
  type        = string
  default     = "vnet-hub-prd-eus2-01"
}

variable "bgp_route_propagation_enabled" {
  description = "Whether BGP route propagation is enabled on this route table. Set to false for forced tunneling scenarios."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "7e6e79d1-70cd-4feb-8f93-d22e3f2f6fca"
    subscription  = "connectivity"
    managed_by    = "terraform"
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
