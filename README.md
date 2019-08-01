# Azure Static website hosting with custom domain and SSL endpoint using Application Gateway

This is the Terraform code needed to build a fully functional static web site hosted on an Azure Storage Account with Azure Application Gateway as a frontend. 

If you need a DNS and a Keyvault you can run the code under 00-.. folder first.

Please keep the following in mind:

- You need to add a CNAME DNS Record pointing to the Public IP DNS label
- You need to have a valid SSL certificate matching your domain name
    - You can create an SSL Certificate in Azure, import it in an Azure Keyvault and then export it in a pfx format.
    - ref: https://docs.microsoft.com/en-us/azure/app-service/web-sites-purchase-ssl-web-site
- You need to put the pfx file in the "ssl_certificate" folder
- Make sure your have a storage account to store your state file
- Review the file terraform.tf and add your storage account name to host the state file

## Installation

Make sure you have Terraform >=0.12.5 and azurerm >=1.32.1

How to install Terraform: https://learn.hashicorp.com/terraform/getting-started/install.html

after the installation run the following command two times, under 00-.. and 01-..

```bash
terraform init
```

## Usage

under each of both 00-.. and 01-.. folders run the following.

```bash
terraform plan
terraform apply
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

The Application gateway does support reading the certificate from the Keyvault directly, terraform has not yet implemented it (see: https://github.com/terraform-providers/terraform-provider-azurerm/issues/3935)

## License
[MIT](https://choosealicense.com/licenses/mit/)

###ref:
https://medium.com/@emin.askerov/static-website-hosting-in-azure-storage-with-custom-domain-and-ssl-support-using-azure-application-b17f95c6764c

