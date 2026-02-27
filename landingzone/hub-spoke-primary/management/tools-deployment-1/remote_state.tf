# ============================================
# Remote State - Management Network Deployment 1
# ============================================
# Provides: subnet_ids, vnet_id, vnet_name, resource_group_name

data "terraform_remote_state" "management_network_deployment_1" {
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

# ============================================
# Remote State - Identity Network Deployment 1
# ============================================
# Provides: private_dns_zone_ids (map of DNS zone name => zone ID)

data "terraform_remote_state" "identity_network_deployment_1" {
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