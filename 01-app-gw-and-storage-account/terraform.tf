# Azure provider configuration
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  #client_id       = "${var.client_id}"
  #client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "moga-ca-rg"
    storage_account_name = "mogaterraform"
    container_name       = "terraformstate"
    key                  = "appgw.terraform.tfstate"
  }
}
