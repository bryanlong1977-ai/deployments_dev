variable "subscription_id" {
  type        = string
  description = "The subscription ID for the Connectivity subscription"
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "management_subscription_id" {
  type        = string
  description = "The subscription ID for the Management subscription"
  default     = "39f647ab-5261-47b0-ad91-1719dcd107a1"
}

variable "region" {
  type        = string
  description = "The Azure region for resource deployment"
  default     = "westus3"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "925e43c3-6edd-4030-9310-0f384ef3ac0b"
    managed_by    = "Terraform"
  }
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones for zone-redundant resources"
  default     = ["1", "2", "3"]
}

# NAT Gateway Variables
variable "nat_gateway_resource_group_name" {
  type        = string
  description = "Name of the resource group for NAT Gateway"
  default     = "rg-natgw-hub-prd-wus3-01"
}

variable "nat_gateway_name" {
  type        = string
  description = "Name of the NAT Gateway"
  default     = "natgw-hub-prd-wus3-01"
}

variable "nat_gateway_sku" {
  type        = string
  description = "SKU name for NAT Gateway"
  default     = "Standard"
}

variable "nat_gateway_idle_timeout" {
  type        = number
  description = "Idle timeout in minutes for NAT Gateway"
  default     = 10
}

variable "nat_gateway_diagnostic_setting_name" {
  type        = string
  description = "Name of the diagnostic setting for NAT Gateway"
  default     = "diag-natgw-hub-prd-wus3-01"
}

# Public IP Prefix Variables
variable "public_ip_prefix_name" {
  type        = string
  description = "Name of the public IP prefix for NAT Gateway"
  default     = "pipp-hub-prd-wus3-01"
}

variable "public_ip_prefix_length" {
  type        = number
  description = "Prefix length for the public IP prefix"
  default     = 29
}

variable "public_ip_prefix_sku" {
  type        = string
  description = "SKU for the public IP prefix"
  default     = "Standard"
}

variable "nat_pip_prefix_diagnostic_setting_name" {
  type        = string
  description = "Name of the diagnostic setting for NAT Gateway Public IP Prefix"
  default     = "diag-pipp-hub-prd-wus3-01"
}

# ExpressRoute Gateway Variables
variable "expressroute_gateway_name" {
  type        = string
  description = "Name of the ExpressRoute Gateway"
  default     = "ergw-hub-prd-wus3-01"
}

variable "expressroute_gateway_sku" {
  type        = string
  description = "SKU for the ExpressRoute Gateway"
  default     = "Standard"
}

variable "expressroute_gateway_pip_name" {
  type        = string
  description = "Name of the public IP for ExpressRoute Gateway"
  default     = "pip-ergw-hub-prd-wus3-01"
}

variable "expressroute_gateway_pip_allocation_method" {
  type        = string
  description = "Allocation method for ExpressRoute Gateway public IP"
  default     = "Static"
}

variable "expressroute_gateway_pip_sku" {
  type        = string
  description = "SKU for ExpressRoute Gateway public IP"
  default     = "Standard"
}

variable "expressroute_gateway_ip_config_name" {
  type        = string
  description = "Name of the IP configuration for ExpressRoute Gateway"
  default     = "ipconfig-ergw"
}

variable "expressroute_gateway_private_ip_allocation" {
  type        = string
  description = "Private IP allocation method for ExpressRoute Gateway"
  default     = "Dynamic"
}

variable "expressroute_gateway_diagnostic_setting_name" {
  type        = string
  description = "Name of the diagnostic setting for ExpressRoute Gateway"
  default     = "diag-ergw-hub-prd-wus3-01"
}

variable "expressroute_pip_diagnostic_setting_name" {
  type        = string
  description = "Name of the diagnostic setting for ExpressRoute Gateway Public IP"
  default     = "diag-pip-ergw-hub-prd-wus3-01"
}

# External Load Balancer Variables
variable "external_lb_resource_group_name" {
  type        = string
  description = "Name of the resource group for External Load Balancer"
  default     = "rg-lb-hub-prd-wus3-01"
}

variable "external_lb_name" {
  type        = string
  description = "Name of the External Load Balancer"
  default     = "lbe-hub-prd-wus3-01"
}

variable "external_lb_sku" {
  type        = string
  description = "SKU for the External Load Balancer"
  default     = "Standard"
}

variable "external_lb_sku_tier" {
  type        = string
  description = "SKU tier for the External Load Balancer"
  default     = "Regional"
}

variable "external_lb_frontend_ip_config_name" {
  type        = string
  description = "Name of the frontend IP configuration for External Load Balancer"
  default     = "feip-external"
}

variable "external_lb_backend_pool_name" {
  type        = string
  description = "Name of the backend pool for External Load Balancer"
  default     = "bepool-external"
}

variable "external_lb_pip_prefix_name" {
  type        = string
  description = "Name of the public IP prefix for External Load Balancer"
  default     = "pipp-lbe-hub-prd-wus3-01"
}

variable "external_lb_pip_prefix_length" {
  type        = number
  description = "Prefix length for the External Load Balancer public IP prefix"
  default     = 31
}

variable "external_lb_pip_prefix_sku" {
  type        = string
  description = "SKU for the External Load Balancer public IP prefix"
  default     = "Standard"
}

variable "external_lb_pip_name" {
  type        = string
  description = "Name of the public IP for External Load Balancer"
  default     = "pip-lbe-hub-prd-wus3-01"
}

variable "external_lb_pip_allocation_method" {
  type        = string
  description = "Allocation method for External Load Balancer public IP"
  default     = "Static"
}

variable "external_lb_pip_sku" {
  type        = string
  description = "SKU for External Load Balancer public IP"
  default     = "Standard"
}

variable "external_lb_diagnostic_setting_name" {
  type        = string
  description = "Name of the diagnostic setting for External Load Balancer"
  default     = "diag-lbe-hub-prd-wus3-01"
}

# VNet Diagnostic Settings Variables
variable "vnet_diagnostic_setting_name" {
  type        = string
  description = "Name of the diagnostic setting for the Hub VNet"
  default     = "diag-vnet-hub-prd-wus3-01"
}

# VNet Flow Log Variables
variable "vnet_flow_log_name" {
  type        = string
  description = "Name of the VNet flow log"
  default     = "fl-vnet-hub-prd-wus3-01"
}

variable "vnet_flow_log_enabled" {
  type        = bool
  description = "Enable VNet flow logs"
  default     = true
}

variable "vnet_flow_log_version" {
  type        = number
  description = "Version of the flow log format"
  default     = 2
}

variable "vnet_flow_log_retention_enabled" {
  type        = bool
  description = "Enable retention policy for VNet flow logs"
  default     = true
}

variable "vnet_flow_log_retention_days" {
  type        = number
  description = "Retention days for VNet flow logs"
  default     = 90
}

variable "traffic_analytics_enabled" {
  type        = bool
  description = "Enable traffic analytics for VNet flow logs"
  default     = true
}

variable "traffic_analytics_interval" {
  type        = number
  description = "Traffic analytics processing interval in minutes"
  default     = 10
}

# DNS Variables
variable "hub_dns_vnet_link_name" {
  type        = string
  description = "Name of the DNS forwarding ruleset VNet link for Hub"
  default     = "link-hub-vnet-dns-frs"
}

variable "private_dns_zones" {
  type        = list(string)
  description = "List of private DNS zones to link to the Hub VNet"
  default = [
    "privatelink.blob.core.windows.net",
    "privatelink.queue.core.windows.net",
    "privatelink.file.core.windows.net",
    "privatelink.table.core.windows.net",
    "privatelink.vaultcore.azure.net",
    "privatelink.siterecovery.windowsazure.com",
    "privatelink.wus3.backup.windowsazure.com",
    "privatelink.eus.backup.windowsazure.com",
    "privatelink.monitor.azure.com",
    "privatelink.oms.opinsights.azure.com",
    "privatelink.ods.opinsights.azure.com",
    "privatelink.azure-automation.net",
    "privatelink.agentsvc.azure-automation.net",
    "privatelink.blob.storage.azure.net",
    "privatelink.disk.azure.net"
  ]
}

variable "dns_zone_registration_enabled" {
  type        = bool
  description = "Enable auto-registration for DNS zone VNet links"
  default     = false
}

# Remote State Configuration Variables
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
  description = "Subscription ID for Terraform state storage"
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
