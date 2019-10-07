# Resource Group
resource "azurerm_resource_group" "foundation_resource_group" {
  name     = "${var.foundation_resource_group}"
  location = "${var.deployment_region}"
}
