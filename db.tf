


resource "azurerm_postgresql_flexible_server" "this" {
  name                          = var.db-server-name
  resource_group_name           = var.resGroup
  location                      = var.locaion
  version                       = var.db_version
  delegated_subnet_id           = azurerm_subnet.db_subnet.id
  sku_name                      = var.db_sku
  administrator_login           = var.db_admin
  administrator_password        = var.db_admin_password
  private_dns_zone_id           = azurerm_private_dns_zone.this.id
  storage_mb                    = 32768
  backup_retention_days         = 7
  public_network_access_enabled = false
  zone                          = "1"




  tags = {
    environment = var.env
  }


  # lifecycle {
  #   prevent_destroy = true
  # }


  depends_on = [azurerm_private_dns_zone_virtual_network_link.this]
}


resource "azurerm_postgresql_flexible_server_database" "this" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.this.id
}



resource "azurerm_key_vault_secret" "db_url" {
  key_vault_id = azurerm_key_vault.this.id
  name         = "db-url"
  value        = "postgresql://${azurerm_postgresql_flexible_server.this.administrator_login}:${azurerm_postgresql_flexible_server.this.administrator_password}@${azurerm_postgresql_flexible_server.this.name}.postgres.database.azure.com/${azurerm_postgresql_flexible_server_database.this.name}"

  depends_on = [azurerm_role_assignment.client_access]

}
