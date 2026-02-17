# Remote State References for Route Table Deployment 1 - DMZ Subscription

# Reference DMZ Network Deployment 1 for subnet IDs
data "terraform_remote_state" "dmz_network_deployment_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-storage-ncus-01"
    storage_account_name = "sacloudaiconsulting01"
    container_name       = "tfstate"
    key                  = "hub-spoke-primary/dmz/network-deployment-1.tfstate"
    subscription_id      = "53fea26b-011b-4520-b157-e31b034c7900"
    use_azuread_auth     = true
  }
}

# Reference Connectivity Network Deployment 2 for Hub Internal Load Balancer IP
# This provides the Trust Firewall LB IP for routing
data "terraform_remote_state" "connectivity_network_deployment_2" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-storage-ncus-01"
    storage_account_name = "sacloudaiconsulting01"
    container_name       = "tfstate"
    key                  = "hub-spoke-primary/connectivity/network-deployment-2.tfstate"
    subscription_id      = "53fea26b-011b-4520-b157-e31b034c7900"
    use_azuread_auth     = true
  }
}