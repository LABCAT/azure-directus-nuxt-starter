resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.project_name}-${var.environment}-log"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "main" {
  name                       = "${var.project_name}-${var.environment}-cae"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  tags = var.tags
}

resource "azurerm_container_app" "directus" {
  name                         = "${var.project_name}-${var.environment}-app"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  identity {
    type = "SystemAssigned"
  }

  registry {
    server               = var.registry_server
    username             = var.registry_username
    password_secret_name = "registry-password"
  }

  secret {
    name  = "registry-password"
    value = var.registry_password
  }

  # Key Vault referenced secrets
  secret {
    name                = "db-password"
    key_vault_secret_id = "${var.key_vault_uri}secrets/db-password"
    identity            = "System"
  }
  secret {
    name                = "directus-secret"
    key_vault_secret_id = "${var.key_vault_uri}secrets/directus-secret"
    identity            = "System"
  }
  secret {
    name                = "directus-admin-password"
    key_vault_secret_id = "${var.key_vault_uri}secrets/directus-admin-password"
    identity            = "System"
  }
  secret {
    name                = "storage-account-key"
    key_vault_secret_id = "${var.key_vault_uri}secrets/storage-account-key"
    identity            = "System"
  }
  secret {
    name                = "redis-password"
    key_vault_secret_id = "${var.key_vault_uri}secrets/redis-password"
    identity            = "System"
  }

  template {
    container {
      name   = "directus"
      image  = "${var.registry_server}/directus-prod:latest" # Assuming image name
      cpu    = 0.5
      memory = "1.0Gi"

      env {
        name  = "DB_CLIENT"
        value = "pg"
      }
      env {
        name  = "DB_HOST"
        value = var.db_host
      }
      env {
        name  = "DB_PORT"
        value = "5432"
      }
      env {
        name  = "DB_DATABASE"
        value = var.db_name
      }
      env {
        name  = "DB_USER"
        value = var.db_user
      }
      env {
        name        = "DB_PASSWORD"
        secret_name = "db-password"
      }
      env {
        name        = "SECRET"
        secret_name = "directus-secret"
      }
      env {
        name  = "ADMIN_EMAIL"
        value = var.admin_email
      }
      env {
        name        = "ADMIN_PASSWORD"
        secret_name = "directus-admin-password"
      }
      env {
        name  = "REDIS_HOST"
        value = var.redis_host
      }
      env {
        name  = "REDIS_PORT"
        value = var.redis_port
      }
      env {
        name        = "REDIS_PASSWORD"
        secret_name = "redis-password"
      }
      env {
        name  = "STORAGE_LOCATIONS"
        value = "azure"
      }
      env {
        name  = "STORAGE_AZURE_DRIVER"
        value = "azure"
      }
      env {
        name  = "STORAGE_AZURE_ACCOUNT_NAME"
        value = var.storage_account_name
      }
      env {
        name        = "STORAGE_AZURE_KEY"
        secret_name = "storage-account-key"
      }
      env {
        name  = "STORAGE_AZURE_CONTAINER"
        value = "directus-assets"
      }
      env {
        name  = "PUBLIC_URL"
        value = "https://${var.project_name}-${var.environment}-app.azurecontainerapps.io" # Approximate, will update with ingress
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8055
    transport        = "auto"
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "container_app" {
  key_vault_id = var.key_vault_id
  tenant_id    = azurerm_container_app.directus.identity[0].tenant_id
  object_id    = azurerm_container_app.directus.identity[0].principal_id

  secret_permissions = [
    "Get",
  ]
}
