# Introduction

This project configures the necessary resources to deploy an Enterprise Scale Landing Zone using Terraform. This introduces a chicken and egg situation in that these "backend" resources need to somehow transition to being under the policy and governance provided by ESLZ. How that happens has yet to be defined. In the meantime however, these resources may have to be deployed to a separate subscription to avoid losing access as policy gets applied.

Alternatively to create your own backend resources, you could do TF init and apply locally. There is a dev container in the backend resources used by Forefront and Forefront-Test but you would not be able to use the bash scripts deployed in the image (those found at /build-agent-tools/scripts) because they rely on backend resources.

## Deploy

Create a .env file from the .env.sample and populate it with the resource group, storage account name and container name. Login with az login and deploy with terraform init and terraform apply.

The Key Vault and Service Principal created are to securely provide variables to the deployment pipeline. These variables need to be manually added and are yet to be defined.

