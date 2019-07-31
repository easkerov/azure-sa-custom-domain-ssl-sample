terraform {
  backend "azurerm" {
    resource_group_name  = "moga-ca-rg"
    storage_account_name = "mogaterraform"
    container_name       = "terraformstate"
    key                  = "appgw.terraform.tfstate"
  }
}

data "terraform_remote_state" "shared" {
  backend = "azurerm"

  config {
    resource_group_name  = "moga-ca-rg"
    storage_account_name = "mogaterraform"
    container_name       = "terraformstate"
    key                  = "appgw.terraform.tfstateenv:${terraform.workspace}"
  }
}