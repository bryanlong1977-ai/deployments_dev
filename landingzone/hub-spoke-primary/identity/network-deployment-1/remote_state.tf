#------------------------------------------------------------------------------
# Remote State Data Sources
#------------------------------------------------------------------------------

# Reference Connectivity Network Deployment 1 outputs (Hub VNet)
data "terraform_remote_state" "connectivity_network_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.remote_state_resource_group
    storage_account_name = var.remote_state_storage_account
    container_name       = var.remote_state_container
    key                  = var.connectivity_network_state_key
    subscription_id      = var.subscription_id
    use_azuread_auth     = true
  }
}