data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                        = "${var.project_name}-${var.environment}-kv"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover"
    ]

    storage_permissions = [
      "Get",
    ]
  }

  tags = var.tags
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each     = var.secrets
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.main.id
}
