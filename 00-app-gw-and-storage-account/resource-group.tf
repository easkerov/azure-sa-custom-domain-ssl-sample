# Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.appgw_resource_group_name}"
  location = "${var.deployment_region}"
}