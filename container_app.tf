
resource "azurerm_log_analytics_workspace" "this" {
  name                = "${var.con-app-name}-log"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = var.env
  }

}



resource "azurerm_container_app_environment" "this" {

  name                = "${var.con-app-name}-env"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  infrastructure_subnet_id = azurerm_subnet.containerAPP_subnet.id
  tags = {
    environment = var.env
  }


}



locals {
  all_app_secrets = merge(
    { for secret in azurerm_key_vault_secret.this : secret.name => {
      id    = secret.id,
      value = secret.value
      name  = secret.name
      }
    },
    { for secret in azurerm_key_vault_secret.storage_all_secrets : secret.name => {
      id    = secret.id,
      value = secret.value
      name  = secret.name
      }
    },
    {
      "DB_URL" = {
        id    = azurerm_key_vault_secret.db_url.id
        value = azurerm_key_vault_secret.db_url.value
        name  = azurerm_key_vault_secret.db_url.name
      }
    }

  )

}


resource "azurerm_container_app" "this" {
  name                         = var.con-app-name
  resource_group_name          = var.resGroup
  revision_mode                = "Single"
  container_app_environment_id = azurerm_container_app_environment.this.id



  ingress {
    external_enabled = true
    traffic_weight {
      percentage      = 100
      latest_revision = true

    }
    target_port = 3000
  }



  template {
    container {
      name = var.con-app-name
      cpu  = 0.25

      image  = var.image
      memory = "0.5Gi"


      startup_probe {
        port      = 3000
        transport = "TCP"


      }

      dynamic "env" {
        for_each = local.all_app_secrets
        content {
          name        = upper(join("_", split("-", env.value.name))) // replacing symbol - to _ and convert to uppercase
          secret_name = env.value.name
        }
      }



    }
  }


  dynamic "secret" {
    for_each = local.all_app_secrets

    content {
      name                = secret.value.name
      value               = secret.value.value
      key_vault_secret_id = secret.value.id
      identity            = azurerm_user_assigned_identity.this.id
    }

  }




  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }



  tags = {
    environment = var.env
  }





}



