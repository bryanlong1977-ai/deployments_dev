#------------------------------------------------------------------------------
# Remote State - Connectivity Network Deployment 1
# This retrieves outputs from the Hub VNet deployment for peering and DNS links
#------------------------------------------------------------------------------

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