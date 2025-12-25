output "fqdn" {
  value = azurerm_postgresql_flexible_server.main.fqdn
}

output "database_name" {
  value = azurerm_postgresql_flexible_server_database.directus.name
}

output "administrator_login" {
  value = azurerm_postgresql_flexible_server.main.administrator_login
}
