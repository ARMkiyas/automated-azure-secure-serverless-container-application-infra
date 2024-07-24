
# Automated and Secure Azure Infrastructure for Serverless Container Applications and Services

## Overview

This project provides Terraform configurations for automating the deployment of a secure and scalable Azure infrastructure tailored for serverless container applications and associated services. It includes setup for Azure Container Apps, Key Vault, Storage Accounts, Virtual Network, and PostgreSQL Flexible Server, among other essential components.

**Note:** This project is currently under development and not fully ready for production use.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
  - [Clone the Repository](#clone-the-repository)
  - [Configuration](#configuration)
  - [Backend Configuration](#backend-configuration)
  - [Deploying the Infrastructure](#deploying-the-infrastructure)
- [Variables](#variables)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Automated Deployment:** Fully automated infrastructure deployment using Terraform.
- **Security:** Secure setup using Azure Key Vault for secrets management and secure configurations.
- **Scalability:** Scalable infrastructure to handle varying loads for serverless container applications.
- **Networking:** Configured Virtual Network for secure communication between services.
- **Data Management:** Provisioned PostgreSQL Flexible Server for reliable data storage.
- **Storage Solutions:** Azure Storage Accounts for persistent storage needs.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- An [Azure account](https://azure.microsoft.com/en-us/free/).
- Azure CLI installed and configured. You can download it [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).

## Architecture

The project sets up the following Azure resources:

- **Azure Container Apps:** For deploying serverless containerized applications.
- **Azure Key Vault:** For managing secrets and sensitive configuration information.
- **Azure Storage Accounts:** For persistent storage needs.
- **Azure Virtual Network:** For secure and isolated networking.
- **Azure PostgreSQL Flexible Server:** For database management and operations.

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/ARMkiyas/automated-azure-secure-serverless-container-application-infra
cd azure-serverless-infra-automation
```

### Configuration

1. **Create a `terraform.tfvars` file** in the root directory and add your Azure subscription details and any other required variables. Here's an example:

    ```hcl
    subscription_id       = "your-azure-subscription-id"
    tenant_id             = "your-azure-tenant-id"
    client_id             = "your-service-principal-client-id"
    client_secret         = "your-service-principal-client-secret"
    resGroup              = "cloudcareinfra"
    location              = "eastus"
    env                   = "staging"
    vnet_name             = "vnet"
    vnet_address_space    = ["10.0.0.0/16"]
    private_dns_zone      = "example.com"
    containerAPP_subnet   = { name = "containerAPP-subnet", address_prefix = ["10.0.1.0/24"] }
    db_subnet             = { name = "db-subnet", address_prefix = ["10.0.2.0/24"] }
    other_services_subnet = { name = "other-service-subnet", address_prefix = ["10.0.3.0/24"] }
    con_app_name          = "cloudcareapp"
    image                 = "your-container-image"
    db_server_name        = "cloudcaredb-server"
    db_admin              = "your-db-admin"
    db_admin_password     = "your-db-admin-password"
    db_sku                = "B_Standard_B1ms"
    db_version            = "15"
    storage_account_name  = "cloudcarestorage"
    storage_account_tier  = "Standard"
    storage_replication_type = "LRS"
    storage_container_name = "cloudcarecontainer"
    keyvault_name         = "keyvault"
    db_name               = "cloudcaredb"
    keyvault_secrets      = [{ name = "sample-secret", value = "sample_value" }]
    ```

2. **Review and adjust** any other variable configurations in `variables.tf` as needed.


### Backend Configuration


### Local Backend
By default, this project is set up to use the local backend for storing Terraform state files. This is suitable for initial development and testing on your local machine.

### Remote Backend
For collaboration and production use, it is recommended to use a remote backend such as Azure Storage, Amazon S3, or Terraform Cloud. Below are examples for configuring remote backends.

#### Azure Storage

1. Create an Azure Storage account and container.
2. Add the following backend configuration to your `main.tf`:

    ```hcl
    terraform {
      backend "azurerm" {
        resource_group_name  = "your-resource-group"
        storage_account_name = "your-storage-account"
        container_name       = "your-container"
        key                  = "terraform.tfstate"
      }
    }
    ```

#### Amazon S3

1. Create an S3 bucket and DynamoDB table for state locking.
2. Add the following backend configuration to your `main.tf`:

    ```hcl
    terraform {
      backend "s3" {
        bucket         = "your-s3-bucket"
        key            = "terraform.tfstate"
        region         = "your-region"
        dynamodb_table = "your-dynamodb-table"
        encrypt        = true
      }
    }
    ```

#### Terraform Cloud

1. Create a workspace in Terraform Cloud.
2. Add the following backend configuration to your `main.tf`:

    ```hcl
    terraform {
      backend "remote" {
        organization = "your-organization"

        workspaces {
          name = "your-workspace"
        }
      }
    }
    ```




### Deploying the Infrastructure

1. **Initialize Terraform:**

    ```bash
    terraform init
    ```

2. **Plan the deployment:**

    ```bash
    terraform plan
    ```

3. **Apply the deployment:**

    ```bash
    terraform apply
    ```

    Confirm the apply action when prompted.

## Variables

The following variables are used in this project:

- **`resGroup`**: Name of the resource group.
- **`location`**: Location of the resource group.
- **`env`**: Environment of the resource group.
- **`vnet_name`**: Name of the Virtual Network.
- **`vnet_address_space`**: Address space of the Virtual Network.
- **`private_dns_zone`**: Name of the private DNS zone.
- **`containerAPP_subnet`**: Subnet configuration for container apps.
- **`db_subnet`**: Subnet configuration for the database.
- **`other_services_subnet`**: Subnet configuration for other services.
- **`con_app_name`**: Name of the container app.
- **`image`**: Container image.
- **`db_server_name`**: Name of the PostgreSQL server.
- **`db_admin`**: Database administrator username.
- **`db_admin_password`**: Database administrator password.
- **`db_sku`**: SKU for the database server.
- **`db_version`**: Version of the database server.
- **`storage_account_name`**: Name of the storage account.
- **`storage_account_tier`**: Tier of the storage account.
- **`storage_replication_type`**: Replication type of the storage account.
- **`storage_container_name`**: Name of the storage container.
- **`keyvault_name`**: Name of the Key Vault.
- **`db_name`**: Name of the database.
- **`keyvault_secrets`**: List of Key Vault secrets.

## Usage

Once the infrastructure is deployed, you can:

- Deploy your container applications to the Azure Container Apps environment.
- Manage secrets and configurations securely using Azure Key Vault.
- Utilize the provisioned PostgreSQL database for your application’s data needs.
- Store and manage files using the Azure Storage Accounts.

## Contributing

We welcome contributions to enhance and improve this project! Please fork the repository and submit a pull request with your proposed changes. Ensure that your code adheres to the existing style and includes necessary documentation.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
