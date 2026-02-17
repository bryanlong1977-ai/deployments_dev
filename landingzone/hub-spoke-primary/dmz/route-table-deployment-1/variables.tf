# Variables for Route Table Deployment 1 - DMZ Subscription

variable "subscription_id" {
  description = "The subscription ID where resources will be deployed"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

variable "environment" {
  description = "The environment name (e.g., Production, Development)"
  type        = string
  default     = "Production"
}

variable "route_table_name" {
  description = "The name of the route table"
  type        = string
  default     = "rt-dmz-prd-wus3-01"
}

variable "route_table_resource_group_name" {
  description = "The name of the resource group for the route table"
  type        = string
  default     = "rg-rt-dmz-prd-wus3-01"
}

variable "vnet_name" {
  description = "The name of the DMZ virtual network"
  type        = string
  default     = "vnet-dmz-prd-wus3-01"
}

variable "disable_bgp_route_propagation" {
  description = "Whether to disable BGP route propagation on the route table"
  type        = bool
  default     = true
}

variable "route_to_firewall_name" {
  description = "The name of the route directing traffic to the firewall"
  type        = string
  default     = "route-to-hub-firewall"
}

variable "default_route_address_prefix" {
  description = "The address prefix for the default route (0.0.0.0/0)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "next_hop_type_virtual_appliance" {
  description = "The next hop type for routing through a virtual appliance"
  type        = string
  default     = "VirtualAppliance"
}

variable "hub_trust_firewall_lb_ip" {
  description = "The private IP address of the Hub Trust Firewall Load Balancer"
  type        = string
  default     = "10.0.0.196"
}

variable "enable_epic_separation" {
  description = "Whether Epic/Non-Epic traffic separation is enabled"
  type        = bool
  default     = false
}

variable "epic_traffic_cidr" {
  description = "The CIDR range for Epic traffic (used when Epic separation is enabled)"
  type        = string
  default     = null
}

variable "non_epic_traffic_cidr" {
  description = "The CIDR range for Non-Epic traffic (used when Epic separation is enabled)"
  type        = string
  default     = null
}

variable "epic_trust_firewall_lb_ip" {
  description = "The private IP of the Epic Trust Firewall LB (used when Epic separation is enabled)"
  type        = string
  default     = null
}

variable "non_epic_trust_firewall_lb_ip" {
  description = "The private IP of the Non-Epic Trust Firewall LB (used when Epic separation is enabled)"
  type        = string
  default     = null
}

variable "subnet_names" {
  description = "List of subnet names in the DMZ VNet to associate with the route table"
  type        = list(string)
  default = [
    "snet-pe-dmz-wus3-01",
    "snet-tools-dmz-wus3-01",
    "snet-ifw-mgmt-dmz-wus3-01",
    "snet-ifw-untrust-dmz-wus3-01",
    "snet-ifw-trust-dmz-wus3-01"
  ]
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
