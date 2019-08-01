# Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.appgw_resource_group}"
  location = "${var.deployment_region}"
}
