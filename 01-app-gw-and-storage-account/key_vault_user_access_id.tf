data "azurerm_key_vault" "appgwkeyvault" {
  name                = "${var.key_vault_name}"
  resource_group_name = "${var.foundation_resource_group}"
}

resource "azurerm_key_vault_access_policy" "test" {
  key_vault_id = "${data.azurerm_key_vault.appgwkeyvault.id}"

  tenant_id = "${var.tenant_id}"
  object_id = "${azurerm_user_assigned_identity.appgwidentity.principal_id}"

  secret_permissions = [
    "get",
  ]
}
