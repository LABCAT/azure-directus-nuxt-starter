resource "azurerm_postgresql_flexible_server" "main" {
  name                   = "${var.project_name}-${var.environment}-psql"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "16" # Directus supports recent PG. 16 is good.
  administrator_login    = "directus"
  administrator_password = var.admin_password
  zone                   = "1"

  storage_mb   = 32768
  storage_tier = "P4"

  sku_name = "B_Standard_B1ms"

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_database" "directus" {
  name      = "directus"
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

# Allow access from Azure services
resource "azurerm_postgresql_flexible_server_firewall_rule" "azure_services" {
  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Allow access from all IPs (for demo/dev purposes if strictly needed, but better to restrict)
# For now, allowing Azure services (0.0.0.0) is standard for App Service/Container Apps without VNET integration.
# Container Apps usually need VNet for strict private access, or we allow public access.
# The prompt doesn't specify VNet, so assume public access with "Allow access to Azure services" is sufficient for CA.
