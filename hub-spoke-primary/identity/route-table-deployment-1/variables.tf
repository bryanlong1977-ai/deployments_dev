# Variables for Route Table Deployment 1 - Identity Subscription

variable "subscription_id" {
  description = "The Azure subscription ID for the Identity subscription"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

variable "route_table_name" {
  description = "Name of the route table for Identity VNet"
  type        = string
  default     = "rt-idm-prd-wus3-01"
}

variable "route_table_resource_group_name" {
  description = "Name of the resource group for the route table"
  type        = string
  default     = "rg-rt-idm-prd-wus3-01"
}

variable "vnet_name" {
  description = "Name of the Identity VNet"
  type        = string
  default     = "vnet-idm-prd-wus3-01"
}

variable "bgp_route_propagation_enabled" {
  description = "Whether to enable BGP route propagation on the route table"
  type        = bool
  default     = true
}

variable "default_route_name" {
  description = "Name of the default route to firewall"
  type        = string
  default     = "route-to-firewall"
}

variable "default_route_address_prefix" {
  description = "Address prefix for the default route"
  type        = string
  default     = "0.0.0.0/0"
}

variable "default_route_next_hop_type" {
  description = "Next hop type for the default route"
  type        = string
  default     = "VirtualAppliance"
}

variable "firewall_trust_lb_ip" {
  description = "Private IP address of the Trust Internal Load Balancer in Hub VNet for firewall routing"
  type        = string
  default     = "10.0.0.196"
}

variable "subnet_names" {
  description = "Map of subnet short names to their full names for route table association"
  type = object({
    pe      = string
    tools   = string
    inbound = string
    outbound = string
    dc      = string
    ib_mgmt = string
    ib_lan1 = string
  })
  default = {
    pe      = "snet-pe-idm-wus3-01"
    tools   = "snet-tools-idm-wus3-01"
    inbound = "snet-inbound-idm-wus3-01"
    outbound = "snet-outbound-idm-wus3-01"
    dc      = "snet-dc-idm-wus3-01"
    ib_mgmt = "snet-ib-mgmt-idm-wus3-01"
    ib_lan1 = "snet-ib-lan1-idm-wus3-01"
  }
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
    deployment_id = "8b492308-bab3-41e1-a8cb-1348dfea4227"
    deployed_by   = "Terraform"
    subscription  = "identity"
  }
}

# Remote state configuration variables
variable "remote_state_resource_group_name" {
  description = "Resource group name for the Terraform state storage account"
  type        = string
  default     = "rg-storage-ncus-01"
}

variable "remote_state_storage_account_name" {
  description = "Storage account name for Terraform state"
  type        = string
  default     = "sacloudaiconsulting01"
}

variable "remote_state_container_name" {
  description = "Container name for Terraform state"
  type        = string
  default     = "tfstate"
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
