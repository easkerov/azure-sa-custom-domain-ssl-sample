terraform {
  backend "azurerm" {
    resource_group_name  = "RG_LPA_AMS_GROUNDOPSGIS_STORAGE_P"
    storage_account_name = "lpaamsmsgroundopsgisp000"
    container_name       = "terraformstate"
    key                  = "appgw.terraform.tfstate"
  }
}

#data "terraform_remote_state" "shared" {
#  backend = "azurerm"
#
#  config {
#    resource_group_name  = "RG_LPA_AMS_GROUNDOPSGIS_STORAGE_P"
#    storage_account_name = "lpaamsmsgroundopsgisp000"
#    container_name       = "terraformstate"
#    key                  = "appgw.terraform.tfstateenv:${terraform.workspace}"
#  }
#}