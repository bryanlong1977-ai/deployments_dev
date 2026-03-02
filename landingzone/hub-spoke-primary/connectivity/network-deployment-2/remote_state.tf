# ============================================
# Remote State: Connectivity Network Deployment 1
# Provides: vnet_id, vnet_name, resource_group_name, network_watcher_name, network_watcher_resource_group_name, subnet_ids
# ============================================
data "terraform_remote_state" "connectivity_network_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-storage-ncus-01"
    storage_account_name = "sacloudaiconsulting01"
    container_name       = "tfstate"
    key                  = "hub-spoke-primary/connectivity/network-deployment-1.tfstate"
    subscription_id      = "53fea26b-011b-4520-b157-e31b034c7900"
    use_azuread_auth     = true
  }
}

# ============================================
# Remote State: Management Tools Deployment 1
# Provides: log_analytics_workspace_id, log_analytics_workspace_guid
# ============================================
data "terraform_remote_state" "management_tools_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-storage-ncus-01"
    storage_account_name = "sacloudaiconsulting01"
    container_name       = "tfstate"
    key                  = "hub-spoke-primary/management/tools-deployment-1.tfstate"
    subscription_id      = "53fea26b-011b-4520-b157-e31b034c7900"
    use_azuread_auth     = true
  }
}

# ============================================
# Remote State: Connectivity Tools Deployment 1
# Provides: storage_account_ntwk_id (for flow log storage)
# ============================================
data "terraform_remote_state" "connectivity_tools_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-storage-ncus-01"
    storage_account_name = "sacloudaiconsulting01"
    container_name       = "tfstate"
    key                  = "hub-spoke-primary/connectivity/tools-deployment-1.tfstate"
    subscription_id      = "53fea26b-011b-4520-b157-e31b034c7900"
    use_azuread_auth     = true
  }
}