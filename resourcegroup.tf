resource "azurerm_resource_group" "this" {
  name     = var.resGroup
  location = var.locaion
  tags = {
    environment = var.env
  }

}
