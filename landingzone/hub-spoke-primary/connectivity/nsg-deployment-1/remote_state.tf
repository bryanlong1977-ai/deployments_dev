data "terraform_remote_state" "connectivity_network_deployment_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.remote_state_resource_group
    storage_account_name = var.remote_state_storage_account
    container_name       = var.remote_state_container
    key                  = "hub-spoke-primary/connectivity/network-deployment-1.tfstate"
    subscription_id      = var.remote_state_subscription_id
    use_azuread_auth     = true
  }
}