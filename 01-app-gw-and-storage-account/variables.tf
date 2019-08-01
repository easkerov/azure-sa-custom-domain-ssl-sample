variable "subscription_id" {
  type        = "string"
  description = "Azure Subscription Id"
}

variable "client_id" {
  type        = "string"
  description = "Azure Service Principal App Id"
}

variable "client_secret" {
  type        = "string"
  description = "Azure Service Principal Password"
}

variable "tenant_id" {
  type        = "string"
  description = "Azure Tenant Id"
}

variable "foundation_resource_group" {
  type        = "string"
  description = "Azure Resource Group Name for the DNS zone and the Keyvault"
}

variable "appgw_resource_group" {
  type        = "string"
  description = "Azure Resource Group Name for the App Gateway and the Storage Account"
}

variable "deployment_region" {
  type        = "string"
  description = "Region"
}

variable "public_ip_dns_name" {
  type        = "string"
  description = "The Public DNS Name which will be assosiated with the Public IP"
}

variable "dns_zone_name" {
  type = "string"
  description = "The domain name which will be created as a DNS zone for the app gateway"
}

variable "public_dns_record" {
  type = "string"
  description = "This the a public dns record used by the final users e.g. www"
}

variable "key_vault_name" {
  type = "string"
  description = "The keyvault name"
}

variable "user_managed_identity" {
  type        = "string"
  description = "This is the managed identity used by the AppGW to access the Keyvault, you should have this already after deploying the appgw terraform code"
}

variable "virtual_network_address_space" {
  type        = "list"
  description = "VNet Address Space"
}

variable "appgw_subnet_addr_prefix" {
  type        = "string"
  description = "Application Gateway Subnet Address Prefix"
}

variable "storage_domain_name" {
  type = "string"
}

variable "storage_account_name" {
  type        = "string"
  description = "Storage Account Name"
}

variable "app_gw_name" {
  type        = "string"
  description = "Name of the application gateway resource"
}
variable "virtual_network_name" {
  type        = "string"
  description = "Name of the vnet resource"
}

variable "public_ip_resource_name" {
  type        = "string"
  description = "Public IP Resource Name"
}


variable "ssl_cert_file" {
  type        = "string"
  description = "SSL Certificate PFX file path"
}

variable "ssl_cert_password" {
  type        = "string"
  description = "SSL Certificate Password"
}

variable "my_client_public_ip" {
  type        = "string"
  description = "Your Public IP to be allowed on the Storage account"
}
