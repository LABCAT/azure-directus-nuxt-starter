output "url" {
  value = "https://${azurerm_container_app.directus.latest_revision_fqdn}"
}

output "fqdn" {
  value = azurerm_container_app.directus.latest_revision_fqdn
}
