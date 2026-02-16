# Variables for Route Table Deployment 1 - Management Subscription

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID for the Management subscription"
  default     = "39f647ab-5261-47b0-ad91-1719dcd107a1"
}

variable "region" {
  type        = string
  description = "The Azure region for resource deployment"
  default     = "West US 3"
}

variable "route_table_name" {
  type        = string
  description = "Name of the route table for the management VNet"
  default     = "rt-mgmt-prd-wus3-01"
}

variable "route_table_resource_group_name" {
  type        = string
  description = "Name of the resource group for the route table"
  default     = "rg-rt-mgmt-prd-wus3-01"
}

variable "vnet_name" {
  type        = string
  description = "Name of the management virtual network"
  default     = "vnet-mgmt-prd-wus3-01"
}

variable "bgp_route_propagation_enabled" {
  type        = bool
  description = "Whether BGP route propagation is enabled on the route table"
  default     = false
}

variable "default_route_name" {
  type        = string
  description = "Name of the default route to the firewall"
  default     = "route-to-firewall"
}

variable "default_route_address_prefix" {
  type        = string
  description = "Address prefix for the default route"
  default     = "0.0.0.0/0"
}

variable "next_hop_type_virtual_appliance" {
  type        = string
  description = "Next hop type for routes going to virtual appliances"
  default     = "VirtualAppliance"
}

variable "hub_trust_firewall_lb_ip" {
  type        = string
  description = "Private IP address of the Hub Trust Firewall Load Balancer frontend"
  default     = "10.0.0.196"
}

variable "pe_subnet_name" {
  type        = string
  description = "Name of the private endpoint subnet to associate with the route table"
  default     = "snet-pe-mgmt-wus3-01"
}

variable "tools_subnet_name" {
  type        = string
  description = "Name of the tools subnet to associate with the route table"
  default     = "snet-tools-mgmt-wus3-01"
}

variable "enable_epic_separation" {
  type        = bool
  description = "Whether Epic/Non-Epic traffic separation is enabled"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "8b492308-bab3-41e1-a8cb-1348dfea4227"
    deployed_by   = "Terraform"
    subscription  = "management"
  }
}

# Remote state configuration variables
variable "tfstate_resource_group_name" {
  type        = string
  description = "Resource group name for Terraform state storage"
  default     = "rg-storage-ncus-01"
}

variable "tfstate_storage_account_name" {
  type        = string
  description = "Storage account name for Terraform state"
  default     = "sacloudaiconsulting01"
}

variable "tfstate_container_name" {
  type        = string
  description = "Container name for Terraform state"
  default     = "tfstate"
}

variable "tfstate_subscription_id" {
  type        = string
  description = "Subscription ID for Terraform state storage account"
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
