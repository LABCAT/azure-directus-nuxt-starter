resource "azurerm_redis_cache" "main" {
  name                 = "${var.project_name}-${var.environment}-redis"
  location             = var.location
  resource_group_name  = var.resource_group_name
  capacity             = 0
  family               = "C"
  sku_name             = "Basic"
  non_ssl_port_enabled = false
  minimum_tls_version  = "1.2"

  redis_configuration {
  }

  tags = var.tags
}
