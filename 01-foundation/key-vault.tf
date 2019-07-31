data "azurerm_user_assigned_identity" "appgwidentity" {
  name                = "${var.user_managed_identity}"
  resource_group_name = "${var.appgw_resource_group}"
}

#output "uai_client_id" {
#  value = "${data.azurerm_user_assigned_identity.example.client_id}"
#}

#output "uai_principal_id" {
#  value = "${data.azurerm_user_assigned_identity.example.principal_id}"
#}

resource "azurerm_key_vault" "appgwkeyvault" {
  name                        = "${var.key_vault_name}"
  location                    = "${var.deployment_region}"
  resource_group_name         = "${azurerm_resource_group.foundation_resource_group.name}"
  enabled_for_disk_encryption = true
  tenant_id                   = "${var.tenant_id}"

  sku_name = "standard"

  access_policy {
    tenant_id = "${var.tenant_id}"
    object_id = "${data.azurerm_user_assigned_identity.appgwidentity.principal_id}"

    secret_permissions = [
      "get",
    ]
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = {
    environment = "Production"
  }

  provisioner "local-exec" {
    command = <<EOF
              az resource update --id ${azurerm_key_vault.appgwkeyvault.id} --set properties.enableSoftDelete=true
              EOF
  }
}


