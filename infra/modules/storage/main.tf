resource "azurerm_storage_account" "main" {
  name                     = replace("${var.project_name}${var.environment}sa", "-", "")
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_storage_container" "assets" {
  name                  = "directus-assets"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}
