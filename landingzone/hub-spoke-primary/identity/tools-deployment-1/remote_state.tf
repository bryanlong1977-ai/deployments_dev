#--------------------------------------------------------------
# Remote State Data Sources
#--------------------------------------------------------------

# Reference Identity Network Deployment 1 for subnet and DNS zone information
data "terraform_remote_state" "identity_network_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.remote_state_resource_group_name
    storage_account_name = var.remote_state_storage_account_name
    container_name       = var.remote_state_container_name
    key                  = var.identity_network_state_key
    subscription_id      = var.subscription_id
    use_azuread_auth     = true
  }
}

# Reference Management Tools Deployment 1 for Log Analytics Workspace
data "terraform_remote_state" "management_tools_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.remote_state_resource_group_name
    storage_account_name = var.remote_state_storage_account_name
    container_name       = var.remote_state_container_name
    key                  = var.management_tools_state_key
    subscription_id      = var.subscription_id
    use_azuread_auth     = true
  }
}