# Variables for Route Table Deployment 1 - DMZ Subscription

variable "subscription_id" {
  description = "The subscription ID where resources will be deployed"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "East US 2"
}

variable "route_table_name" {
  description = "Name of the route table"
  type        = string
  default     = "rt-dmz-prd-eus2-01"
}

variable "route_table_resource_group_name" {
  description = "Name of the resource group for the route table"
  type        = string
  default     = "rg-rt-dmz-prd-eus2-01"
}

variable "vnet_name" {
  description = "Name of the DMZ VNet"
  type        = string
  default     = "vnet-dmz-prd-eus2-01"
}

variable "bgp_route_propagation_enabled" {
  description = "Whether to enable BGP route propagation on the route table"
  type        = bool
  default     = false
}

variable "route_to_firewall_name" {
  description = "Name of the default route to the firewall"
  type        = string
  default     = "route-to-hub-firewall"
}

variable "default_route_address_prefix" {
  description = "Address prefix for the default route"
  type        = string
  default     = "0.0.0.0/0"
}

variable "next_hop_type_virtual_appliance" {
  description = "Next hop type for virtual appliance routes"
  type        = string
  default     = "VirtualAppliance"
}

variable "hub_trust_firewall_lb_ip" {
  description = "Private IP address of the Hub Trust Firewall Load Balancer frontend"
  type        = string
  default     = "10.0.0.196"
}

variable "enable_epic_separation" {
  description = "Whether Epic/Non-Epic traffic separation is enabled"
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
    deployment_id = "7e6e79d1-70cd-4feb-8f93-d22e3f2f6fca"
    subscription  = "dmz"
    managed_by    = "Terraform"
  }
}

# Subnet names for route table associations
variable "subnet_pe_name" {
  description = "Name of the private endpoints subnet"
  type        = string
  default     = "snet-pe-dmz-eus2-01"
}

variable "subnet_tools_name" {
  description = "Name of the tools subnet"
  type        = string
  default     = "snet-tools-dmz-eus2-01"
}

variable "subnet_ns_mgmt_name" {
  description = "Name of the NetScaler management subnet"
  type        = string
  default     = "snet-ns-mgmt-dmz-eus2-01"
}

variable "subnet_ns_client_name" {
  description = "Name of the NetScaler client subnet"
  type        = string
  default     = "snet-ns-client-dmz-eus2-01"
}

variable "subnet_ns_server_name" {
  description = "Name of the NetScaler server subnet"
  type        = string
  default     = "snet-ns-server-dmz-eus2-01"
}

variable "subnet_ifw_mgmt_name" {
  description = "Name of the ingress firewall management subnet"
  type        = string
  default     = "snet-ifw-mgmt-dmz-eus2-01"
}

variable "subnet_ifw_untrust_name" {
  description = "Name of the ingress firewall untrust subnet"
  type        = string
  default     = "snet-ifw-untrust-dmz-eus2-01"
}

variable "subnet_ifw_trust_name" {
  description = "Name of the ingress firewall trust subnet"
  type        = string
  default     = "snet-ifw-trust-dmz-eus2-01"
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
