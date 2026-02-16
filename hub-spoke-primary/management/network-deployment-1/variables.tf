variable "subscription_id" {
  description = "The subscription ID for the Management subscription"
  type        = string
  default     = "39f647ab-5261-47b0-ad91-1719dcd107a1"
}

variable "connectivity_subscription_id" {
  description = "The subscription ID for the Connectivity subscription"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

variable "network_resource_group_name" {
  description = "Name of the resource group for network resources"
  type        = string
  default     = "rg-network-prd-mgmt-wus3-01"
}

variable "network_watcher_resource_group_name" {
  description = "Name of the dedicated resource group for Network Watcher"
  type        = string
  default     = "rg-nw-prd-mgmt-wus3-01"
}

variable "vnet_name" {
  description = "Name of the Management virtual network"
  type        = string
  default     = "vnet-mgmt-prd-wus3-01"
}

variable "vnet_address_space" {
  description = "Address space for the Management VNet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "dns_servers" {
  description = "Custom DNS servers for the VNet (empty list uses Azure default DNS)"
  type        = list(string)
  default     = []
}

variable "subnet_pe_name" {
  description = "Name of the private endpoints subnet"
  type        = string
  default     = "snet-pe-mgmt-wus3-01"
}

variable "subnet_pe_address_prefix" {
  description = "Address prefix for the private endpoints subnet"
  type        = string
  default     = "10.0.2.0/26"
}

variable "subnet_tools_name" {
  description = "Name of the tools subnet"
  type        = string
  default     = "snet-tools-mgmt-wus3-01"
}

variable "subnet_tools_address_prefix" {
  description = "Address prefix for the tools subnet"
  type        = string
  default     = "10.0.2.64/26"
}

variable "network_watcher_name" {
  description = "Name of the Network Watcher"
  type        = string
  default     = "nw-mgmt-prd-wus3-01"
}

variable "peering_mgmt_to_hub_name" {
  description = "Name of the VNet peering from Management to Hub"
  type        = string
  default     = "peer-mgmt-to-hub"
}

variable "peering_hub_to_mgmt_name" {
  description = "Name of the VNet peering from Hub to Management"
  type        = string
  default     = "peer-hub-to-mgmt"
}

variable "use_remote_gateways" {
  description = "Whether to use remote gateways from the Hub VNet (set to false if gateway not yet deployed)"
  type        = bool
  default     = false
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
