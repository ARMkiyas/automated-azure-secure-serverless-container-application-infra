

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {

}


resource "azurerm_key_vault" "this" {
  name                      = "${var.kayvaultname}-${var.env}"
  location                  = azurerm_resource_group.this.location
  resource_group_name       = azurerm_resource_group.this.name
  sku_name                  = "standard"
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization = true


  tags = {
    environment = var.env
  }


  depends_on = [data.azurerm_subscription.current]



}



resource "azurerm_role_assignment" "client_access" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id


}





resource "azurerm_user_assigned_identity" "this" {

  name                = "${var.kayvaultname}-${var.env}-identity"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location


}


resource "azurerm_role_assignment" "this" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}


// for other extra other secrets
resource "azurerm_key_vault_secret" "this" {
  count        = length(var.keyvault_secrets)
  key_vault_id = azurerm_key_vault.this.id
  name         = var.keyvault_secrets[count.index].name
  value        = var.keyvault_secrets[count.index].value


  depends_on = [azurerm_role_assignment.client_access]


}
