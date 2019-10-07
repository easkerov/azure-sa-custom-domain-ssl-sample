resource "azurerm_key_vault" "appgwkeyvault" {
  name                        = "${var.key_vault_name}"
  location                    = "${var.deployment_region}"
  resource_group_name         = "${azurerm_resource_group.foundation_resource_group.name}"
  enabled_for_disk_encryption = true
  tenant_id                   = "${var.tenant_id}"

  sku_name = "standard"

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


