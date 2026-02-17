data "terraform_remote_state" "management_network_deployment_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.remote_state_resource_group_name
    storage_account_name = var.remote_state_storage_account_name
    container_name       = var.remote_state_container_name
    key                  = "hub-spoke-primary/management/network-deployment-1.tfstate"
    subscription_id      = var.remote_state_subscription_id
    use_azuread_auth     = true
    use_msi              = true
  }
}