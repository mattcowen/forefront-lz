terraform {
  required_providers {
    # github = {
    #   source  = "integrations/github"
    #   version = "~> 4.0"
    # }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.66.0"
    }
  }

  backend "azurerm" {
    key = "management.terraform.tfstate"
  }
}

