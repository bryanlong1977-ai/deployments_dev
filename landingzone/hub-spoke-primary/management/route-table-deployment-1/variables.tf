#--------------------------------------------------------------
# General Variables
#--------------------------------------------------------------
variable "subscription_id" {
  description = "The Azure subscription ID for the Management subscription"
  type        = string
  default     = "39f647ab-5261-47b0-ad91-1719dcd107a1"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "West US 3"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "925e43c3-6edd-4030-9310-0f384ef3ac0b"
    subscription  = "management"
    deployed_by   = "terraform"
  }
}

#--------------------------------------------------------------
# Route Table Variables
#--------------------------------------------------------------
variable "route_table_name" {
  description = "Name of the route table"
  type        = string
  default     = "rt-mgmt-prd-wus3-01"
}

variable "route_table_resource_group_name" {
  description = "Name of the resource group for the route table"
  type        = string
  default     = "rg-rt-mgmt-prd-wus3-01"
}

variable "bgp_route_propagation_enabled" {
  description = "Whether to enable BGP route propagation on the route table"
  type        = bool
  default     = true
}

#--------------------------------------------------------------
# Route Variables
#--------------------------------------------------------------
variable "route_to_firewall_name" {
  description = "Name of the default route to firewall"
  type        = string
  default     = "route-to-firewall"
}

variable "default_route_address_prefix" {
  description = "Address prefix for the default route"
  type        = string
  default     = "0.0.0.0/0"
}

variable "next_hop_type_virtual_appliance" {
  description = "Next hop type for routing through virtual appliance"
  type        = string
  default     = "VirtualAppliance"
}

variable "firewall_lb_ip_address" {
  description = "Private IP address of the Azure Load Balancer front-end for the firewall in the Hub subscription"
  type        = string
  default     = "10.0.0.196"  # This should be updated with actual Trust LB IP from Hub deployment
}

#--------------------------------------------------------------
# Subnet Variables
#--------------------------------------------------------------
variable "pe_subnet_name" {
  description = "Name of the Private Endpoint subnet"
  type        = string
  default     = "snet-pe-mgmt-wus3-01"
}

variable "tools_subnet_name" {
  description = "Name of the Tools subnet"
  type        = string
  default     = "snet-tools-mgmt-wus3-01"
}

#--------------------------------------------------------------
# VNet Configuration
#--------------------------------------------------------------
variable "vnet_name" {
  description = "Name of the Management VNet"
  type        = string
  default     = "vnet-mgmt-prd-wus3-01"
}

#--------------------------------------------------------------
# Remote State Configuration Variables
#--------------------------------------------------------------
variable "tfstate_resource_group_name" {
  description = "Resource group name for Terraform state storage"
  type        = string
  default     = "rg-storage-ncus-01"
}

variable "tfstate_storage_account_name" {
  description = "Storage account name for Terraform state"
  type        = string
  default     = "sacloudaiconsulting01"
}

variable "tfstate_container_name" {
  description = "Container name for Terraform state"
  type        = string
  default     = "tfstate"
}

variable "tfstate_subscription_id" {
  description = "Subscription ID where Terraform state storage is located"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "management_network_deployment_1_state_key" {
  description = "State file key for Management Network Deployment 1"
  type        = string
  default     = "hub-spoke-primary/management/network-deployment-1.tfstate"
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
