# Storage Account
resource "azurerm_storage_account" "static_content_storage_account" {
  name                      = "${var.storage_account_name}"
  resource_group_name       = "${azurerm_resource_group.resource_group.name}"
  location                  = "${var.deployment_region}"
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  access_tier               = "Hot"
  enable_https_traffic_only = true

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["${var.my_client_public_ip}"]
    virtual_network_subnet_ids = ["${azurerm_subnet.appgw_subnet.id}"]
  }

  provisioner "local-exec" {
    command = <<EOF
              sleep 120
              echo "############################################################"
              az storage blob service-properties update --account-name ${var.storage_account_name} --subscription ${var.subscription_id} --static-website  --index-document index.html --404-document 404.html
              sleep 120
              echo "############################################################"
              az storage blob sync -c '$web' --account-name mogastorageaccountsec -s "../site"
              EOF
  }
}
