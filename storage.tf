


resource "random_string" "storage_name_mask" {
  length  = 4
  special = false
  upper   = false

}


resource "azurerm_storage_account" "this" {
  name                     = "cloudcarestorage${random_string.storage_name_mask.result}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type




  tags = {
    environment = var.env
  }


}


resource "azurerm_storage_container" "this" {
  name                 = var.storage_conatiner_name
  storage_account_name = azurerm_storage_account.this.name



}


resource "azurerm_storage_queue" "sms_queue" {
  name                 = var.sms_queue_name
  storage_account_name = azurerm_storage_account.this.name


}


resource "azurerm_storage_queue" "email_queue" {
  name                 = var.email_queue_name
  storage_account_name = azurerm_storage_account.this.name

}


data "azurerm_storage_account_sas" "blob_read_sas" {
  resource_types {
    object    = true
    service   = false
    container = false
  }

  services {
    blob  = true
    file  = false
    queue = false
    table = false
  }
  permissions {
    read    = true
    write   = false
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    filter  = false
    tag     = false
    process = false
  }

  connection_string = azurerm_storage_account.this.primary_connection_string

  //start now 
  start = timestamp()

  // expiry time in 1 year for dev purposes

  expiry = timeadd(timestamp(), "8760h") # 1 year (365 days * 24 hours)

}



locals {
  secrets = {
    conatiner_name_server = {
      name  = "az-blob-container-name"
      value = azurerm_storage_container.this.name
    }
    conatiner_name_public = {
      name  = "next-public-az-blob-container-name"
      value = azurerm_storage_container.this.name
    }
    storage_access_keys = {
      name  = "storage-access-key"
      value = azurerm_storage_account.this.primary_connection_string
    }
    blob_read_sas = {
      name  = "az-blob-read-key"
      value = data.azurerm_storage_account_sas.blob_read_sas.sas
    }
    sms_queue_name = {
      name  = "az-storage-email-queue-name"
      value = azurerm_storage_queue.sms_queue.name
    }
    email_queue_name = {
      name  = "az-storage-message-queue-name"
      value = azurerm_storage_queue.sms_queue.name
    }
  }

}

resource "azurerm_key_vault_secret" "storage_all_secrets" {
  for_each     = local.secrets
  key_vault_id = azurerm_key_vault.this.id
  name         = each.value.name
  value        = each.value.value

  depends_on = [azurerm_role_assignment.client_access, azurerm_storage_queue.sms_queue, azurerm_storage_queue.email_queue, data.azurerm_storage_account_sas.blob_read_sas]
}






# resource "azurerm_key_vault_secret" "conatiner_name" {
#   count        = 2
#   key_vault_id = azurerm_key_vault.this.id
#   name         = index(["az-blob-container-name", "next-public-az-blob-container-name"], count.index)
#   value        = azurerm_storage_container.this.name
# }

# resource "azurerm_key_vault_secret" "storage_access_keys" {
#   key_vault_id = azurerm_key_vault.this.id
#   name         = "storage-access-key"
#   value        = azurerm_storage_account.this.primary_connection_string


#   depends_on = [azurerm_role_assignment.client_access]
# }

# resource "azurerm_key_vault_secret" "blob_read_sas" {
#   name         = "az-blob-read-key"
#   key_vault_id = azurerm_key_vault.this.id
#   value        = data.azurerm_storage_account_sas.blob_read_sas.sas

#   depends_on = [azurerm_role_assignment.client_access, data.azurerm_storage_account_sas.blob_read_sas]
# }


# resource "azurerm_key_vault_secret" "sms_queue_name" {
#   name         = "az-storage-email-queue-name"
#   key_vault_id = azurerm_key_vault.this.id
#   value        = azurerm_storage_queue.sms_queue.name
#   depends_on   = [azurerm_role_assignment.client_access, azurerm_storage_queue.email_queue]

# }

# resource "azurerm_key_vault_secret" "email_queue_name" {
#   name         = "az-storage-message-queue-name"
#   value        = azurerm_storage_queue.sms_queue.name
#   key_vault_id = azurerm_key_vault.this.id

#   depends_on = [azurerm_role_assignment.client_access, azurerm_storage_queue.sms_queue]
# }
