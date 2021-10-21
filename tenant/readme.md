# Introduction

This repo contains Terraform and pipelines that will be run at a tenant wide level using the [Enterprise Scale TF module](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale). 

## Prereqs

Configure permissions according to [the ESLZ guidance](https://github.com/Azure/Enterprise-Scale/wiki/Deploying-Enterprise-Scale#pre-requisites) so as to be able to deploy management groups under your dev AAD.

To deploy to a fresh environment for the first time, review the readme in [bootstrapping readme](/bootstrapping/readme.md) at the repositories root. This will show how to configure the necessary TF "backend" resources for creating a ACR, State storage and identity (Service Principal). You can then create a container image to use for dev purposes and keep it in the ACR created.

Alternatively, there are details on how you can use an existing .devcontainer to deploy to your own dev environment. You can deploy with local TF state e.g. TF init and apply without backend resources.

## Deploy using Backend Resources

Create your own .env file from .env.sample and populate this file with the coordinates of your own backend storage, identity and subscription details. Note this sample also contains TEST and PROD coordinates which you should uncomment only if you need to deploy to TEST or PROD. Typically all deployments to Test and Prod should be done via GitHub Actions.

Your .env file will be ignored from the commit.

Set TF_VAR_parent_id to be your AAD tenant ID if you want to create everything directly under the "tenant root group" management group. The TF_VAR_root_name is the name of the mgmt group then created under the mgmt group in TF_VAR_parent_id. These are "Forefront" for PROD, "Forefront-Test" for TEST. The TF_VAR_root_name is then used as a prefix for all resource group names.

Either create new or use the same Service Principal as your BACKEND_* with permissions to deploy to your dev env and update ARM_CLIENT_ID, ARM_CLIENT_SECRET and ARM_TENANT_ID.

Update the subscription ids to all be the same id if you only have a single sub for development purposes.

