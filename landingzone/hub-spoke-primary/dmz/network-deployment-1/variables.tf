variable "subscription_id" {
  description = "The subscription ID for the DMZ subscription where resources will be deployed"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "connectivity_subscription_id" {
  description = "The subscription ID for the Connectivity subscription (for cross-subscription peering)"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

variable "network_resource_group_name" {
  description = "Name of the resource group for DMZ network resources"
  type        = string
  default     = "rg-network-prd-dmz-wus3-01"
}

variable "network_watcher_resource_group_name" {
  description = "Name of the dedicated resource group for Network Watcher"
  type        = string
  default     = "rg-nw-prd-dmz-wus3-01"
}

variable "vnet_name" {
  description = "Name of the DMZ virtual network"
  type        = string
  default     = "vnet-dmz-prd-wus3-01"
}

variable "vnet_address_space" {
  description = "Address space for the DMZ virtual network"
  type        = list(string)
  default     = ["10.0.6.0/24"]
}

variable "dns_servers" {
  description = "Custom DNS servers for the virtual network. Leave empty to use Azure default DNS."
  type        = list(string)
  default     = []
}

variable "subnet_pe_name" {
  description = "Name of the private endpoints subnet"
  type        = string
  default     = "snet-pe-dmz-wus3-01"
}

variable "subnet_pe_address_prefix" {
  description = "Address prefix for the private endpoints subnet"
  type        = string
  default     = "10.0.6.0/26"
}

variable "private_endpoint_network_policies" {
  description = "Network policies for private endpoints subnet"
  type        = string
  default     = "Disabled"
}

variable "subnet_tools_name" {
  description = "Name of the tools subnet"
  type        = string
  default     = "snet-tools-dmz-wus3-01"
}

variable "subnet_tools_address_prefix" {
  description = "Address prefix for the tools subnet"
  type        = string
  default     = "10.0.6.64/26"
}

variable "subnet_ifw_mgmt_name" {
  description = "Name of the ingress firewall management subnet"
  type        = string
  default     = "snet-ifw-mgmt-dmz-wus3-01"
}

variable "subnet_ifw_mgmt_address_prefix" {
  description = "Address prefix for the ingress firewall management subnet"
  type        = string
  default     = "10.0.6.128/28"
}

variable "subnet_ifw_untrust_name" {
  description = "Name of the ingress firewall untrust subnet"
  type        = string
  default     = "snet-ifw-untrust-dmz-wus3-01"
}

variable "subnet_ifw_untrust_address_prefix" {
  description = "Address prefix for the ingress firewall untrust subnet"
  type        = string
  default     = "10.0.6.160/27"
}

variable "subnet_ifw_trust_name" {
  description = "Name of the ingress firewall trust subnet"
  type        = string
  default     = "snet-ifw-trust-dmz-wus3-01"
}

variable "subnet_ifw_trust_address_prefix" {
  description = "Address prefix for the ingress firewall trust subnet"
  type        = string
  default     = "10.0.6.192/27"
}

variable "network_watcher_name" {
  description = "Name of the Network Watcher"
  type        = string
  default     = "nw-dmz-prd-wus3-01"
}

variable "peering_dmz_to_hub_name" {
  description = "Name of the VNet peering from DMZ to Hub"
  type        = string
  default     = "peer-dmz-to-hub"
}

variable "peering_hub_to_dmz_name" {
  description = "Name of the VNet peering from Hub to DMZ"
  type        = string
  default     = "peer-hub-to-dmz"
}

variable "peering_allow_virtual_network_access" {
  description = "Allow virtual network access for peering"
  type        = bool
  default     = true
}

variable "peering_allow_forwarded_traffic" {
  description = "Allow forwarded traffic for peering"
  type        = bool
  default     = true
}

variable "peering_allow_gateway_transit_hub" {
  description = "Allow gateway transit on hub side of peering"
  type        = bool
  default     = true
}

variable "peering_allow_gateway_transit_spoke" {
  description = "Allow gateway transit on spoke side of peering (should be false)"
  type        = bool
  default     = false
}

variable "peering_use_remote_gateways" {
  description = "Use remote gateways from hub VNet"
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
    deployment_id = "925e43c3-6edd-4030-9310-0f384ef3ac0b"
    subscription  = "dmz"
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
