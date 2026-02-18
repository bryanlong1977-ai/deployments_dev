variable "subscription_id" {
  description = "The subscription ID where resources will be deployed"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "East US 2"
}

variable "route_table_name" {
  description = "Name of the route table"
  type        = string
  default     = "rt-mgmt-prd-eus2-01"
}

variable "route_table_resource_group_name" {
  description = "Name of the resource group for the route table"
  type        = string
  default     = "rg-rt-mgmt-prd-eus2-01"
}

variable "vnet_name" {
  description = "Name of the Management VNet"
  type        = string
  default     = "vnet-mgmt-prd-eus2-01"
}

variable "bgp_route_propagation_enabled" {
  description = "Whether to enable BGP route propagation on the route table"
  type        = bool
  default     = true
}

variable "route_to_firewall_name" {
  description = "Name of the route to firewall"
  type        = string
  default     = "route-to-firewall"
}

variable "default_route_address_prefix" {
  description = "Address prefix for the default route (0.0.0.0/0)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "next_hop_type_virtual_appliance" {
  description = "Next hop type for virtual appliance routing"
  type        = string
  default     = "VirtualAppliance"
}

variable "hub_firewall_lb_ip" {
  description = "Private IP address of the Hub Firewall Load Balancer (Trust ILB)"
  type        = string
  default     = "10.0.0.196"
}

variable "pe_subnet_name" {
  description = "Name of the Private Endpoint subnet"
  type        = string
  default     = "snet-pe-mgmt-eus2-01"
}

variable "tools_subnet_name" {
  description = "Name of the Tools subnet"
  type        = string
  default     = "snet-tools-mgmt-eus2-01"
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
