
terraform {

  # cloud {
  #   organization = "kiyas-cloud"

  #   workspaces {
  #     name = "cloudcare"
  #   }
  # }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.106.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }

  }

}


# Configure the Microsoft Azure Provider
provider "azurerm" {
  # skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted_secrets = false
    }
  }
}



