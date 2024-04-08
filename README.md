## General information
- This is an example configuration of an Azure Application Gateway that is configured to access one app via HTTPS.
- This config is set for one container app only. If several apps need to be accessible, the code must be adapted accordingly. 

- The config is set to use a local Terraform backend. Feel free to integrate the code into your Terraform configuration with a remote backend.

> Be aware that the Application Gateway already exists in your Landing Zone. It is already managed via Terraform by the Container Apps team. To avoid conflicts it is very important that you **keep the values in the ignore_changes block**! 

## Prerequisites
- You already have an app in your Container Apps Environment that is accessible via HTTP(S).
- You have a valid TLS certificate that you saved in the Mgmt Key Vault (kv-mgmt-...)
- You will need an official DNS record for your desired host name (This can be evaded by editing your local hosts file on your pc.)

## Steps 
1. Fill out the terraform.tfvars file with the correct values of your resources
2. Make sure you are logged in to Azure and that the correct subscription is set.
3. Run ```terraform init```
4. Run ```terraform import azurerm_application_gateway.main <app_gateway_resource_id>``` (fill in your appgw id) to import the existing application gateway
5. Run ```terraform plan``` to check the changes being made
6. Run ```terraform apply -auto-approve``` to apply the changes
7. (Add the IP address of the Application Gateway and the host_name you chose to the local-host file of your pc)
8. You will now be able to access you app via https://<host_name>