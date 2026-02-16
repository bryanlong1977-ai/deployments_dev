# Variables for Route Table Deployment 1 - DMZ Subscription

variable "subscription_id" {
  description = "The Azure subscription ID for DMZ resources"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "region" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

variable "route_table_name" {
  description = "Name of the route table"
  type        = string
  default     = "rt-dmz-prd-wus3-01"
}

variable "route_table_resource_group_name" {
  description = "Name of the resource group for route table"
  type        = string
  default     = "rg-rt-dmz-prd-wus3-01"
}

variable "vnet_name" {
  description = "Name of the DMZ virtual network"
  type        = string
  default     = "vnet-dmz-prd-wus3-01"
}

variable "bgp_route_propagation_enabled" {
  description = "Enable BGP route propagation on the route table"
  type        = bool
  default     = false
}

variable "route_to_firewall_name" {
  description = "Name of the default route to firewall"
  type        = string
  default     = "route-to-hub-firewall"
}

variable "default_route_address_prefix" {
  description = "Address prefix for the default route"
  type        = string
  default     = "0.0.0.0/0"
}

variable "next_hop_type_virtual_appliance" {
  description = "Next hop type for virtual appliance routing"
  type        = string
  default     = "VirtualAppliance"
}

variable "hub_trust_lb_frontend_ip" {
  description = "Frontend IP address of the Hub Trust Load Balancer (Firewall)"
  type        = string
  default     = "10.0.0.196"
}

variable "enable_epic_separation" {
  description = "Enable Epic/Non-Epic traffic separation"
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
    subscription  = "dmz"
    managed_by    = "terraform"
  }
}

# Subnet names for route table associations
variable "subnet_names" {
  description = "List of subnet names to associate with the route table"
  type        = list(string)
  default = [
    "snet-pe-dmz-wus3-01",
    "snet-tools-dmz-wus3-01",
    "snet-ns-mgmt-dmz-wus3-01",
    "snet-ns-client-dmz-wus3-01",
    "snet-ns-server-dmz-wus3-01",
    "snet-ifw-mgmt-dmz-wus3-01",
    "snet-ifw-untrust-dmz-wus3-01",
    "snet-ifw-trust-dmz-wus3-01"
  ]
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
