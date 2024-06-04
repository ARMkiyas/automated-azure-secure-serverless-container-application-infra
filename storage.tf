


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


resource "azurerm_storage_container" "name" {
  name                 = var.storage_conatiner_name
  storage_account_name = azurerm_storage_account.this.name

}


resource "azurerm_key_vault_secret" "storage_access_key" {
  key_vault_id = azurerm_key_vault.this.id
  name         = "storage-access-key"
  value        = azurerm_storage_account.this.primary_access_key


  depends_on = [azurerm_role_assignment.client_access]
}
