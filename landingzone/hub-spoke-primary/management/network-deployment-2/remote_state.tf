# =============================================================================
# Remote State - Management Network Deployment 1
# Provides: vnet_id, vnet_name, resource_group_name, subnet_ids
# =============================================================================
data "terraform_remote_state" "management_network_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-storage-ncus-01"
    storage_account_name = "sacloudaiconsulting01"
    container_name       = "tfstate"
    key                  = "hub-spoke-primary/management/network-deployment-1.tfstate"
    subscription_id      = "53fea26b-011b-4520-b157-e31b034c7900"
    use_azuread_auth     = true
    use_msi              = true
  }
}

# =============================================================================
# Remote State - Management Tools Deployment 1
# Provides: log_analytics_workspace_id, log_analytics_workspace_guid, storage_account_id
# =============================================================================
data "terraform_remote_state" "management_tools_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-storage-ncus-01"
    storage_account_name = "sacloudaiconsulting01"
    container_name       = "tfstate"
    key                  = "hub-spoke-primary/management/tools-deployment-1.tfstate"
    subscription_id      = "53fea26b-011b-4520-b157-e31b034c7900"
    use_azuread_auth     = true
    use_msi              = true
  }
}

# =============================================================================
# Remote State - Identity Network Deployment 1
# Provides: private_dns_zone_ids (map of zone name to zone ID)
# =============================================================================
data "terraform_remote_state" "identity_network_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-storage-ncus-01"
    storage_account_name = "sacloudaiconsulting01"
    container_name       = "tfstate"
    key                  = "hub-spoke-primary/identity/network-deployment-1.tfstate"
    subscription_id      = "53fea26b-011b-4520-b157-e31b034c7900"
    use_azuread_auth     = true
    use_msi              = true
  }
}