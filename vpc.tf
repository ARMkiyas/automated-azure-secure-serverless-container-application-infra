resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.vnet_address_space

  tags = {
    environment = var.env
  }

}


resource "azurerm_subnet" "containerAPP_subnet" {
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  name                 = var.containerAPP_subnet.name
  address_prefixes     = var.containerAPP_subnet.address_prefix
  depends_on           = [azurerm_virtual_network.this]




}




resource "azurerm_subnet" "db_subnet" {
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  name                 = var.db_subnet.name
  address_prefixes     = var.db_subnet.address_prefix
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
  depends_on = [azurerm_virtual_network.this]

}


resource "azurerm_subnet" "other_services_subnet" {
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  name                 = var.other_services_subnet.name
  address_prefixes     = var.other_services_subnet.address_prefix
  depends_on           = [azurerm_virtual_network.this]

}




resource "azurerm_private_dns_zone" "this" {
  name                = "${var.private_dns_zone}.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.this.name


  tags = {
    environment = var.env
  }


}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = var.private_dns_zone
  resource_group_name   = azurerm_resource_group.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
  private_dns_zone_name = azurerm_private_dns_zone.this.name

  depends_on = [azurerm_subnet.containerAPP_subnet, azurerm_subnet.db_subnet, azurerm_subnet.other_services_subnet]

}
