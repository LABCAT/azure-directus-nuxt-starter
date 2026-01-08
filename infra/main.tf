locals {
  tags = {
    environment = var.environment
    project     = var.project_name
    managed_by  = "terraform"
  }
}

# Generate passwords
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "directus_secret" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "directus_admin_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "rg" {
  source       = "./modules/resource-group"
  project_name = var.project_name
  environment  = var.environment
  location     = var.location
  tags         = local.tags
}

module "storage" {
  source              = "./modules/storage"
  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.rg.name
  tags                = local.tags
}

module "postgres" {
  source              = "./modules/postgresql"
  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.rg.name
  admin_password      = random_password.db_password.result
  tags                = local.tags
}

module "redis" {
  source              = "./modules/redis"
  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.rg.name
  tags                = local.tags
}

module "kv" {
  source              = "./modules/key-vault"
  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.rg.name
  tags                = local.tags

  secrets = {
    "db-password"             = random_password.db_password.result
    "directus-secret"         = random_password.directus_secret.result
    "directus-admin-password" = random_password.directus_admin_password.result
    "storage-account-key"     = module.storage.primary_access_key
    "redis-password"          = module.redis.primary_access_key
  }
}

module "acr" {
  source              = "./modules/container-registry"
  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.rg.name
  tags                = local.tags
}

module "container_apps" {
  source              = "./modules/container-apps"
  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.rg.name
  tags                = local.tags

  registry_server   = module.acr.login_server
  registry_username = module.acr.admin_username
  registry_password = module.acr.admin_password

  key_vault_id  = module.kv.id
  key_vault_uri = module.kv.vault_uri

  db_host = module.postgres.fqdn
  db_name = module.postgres.database_name
  db_user = module.postgres.administrator_login

  redis_host = module.redis.hostname
  redis_port = module.redis.ssl_port

  storage_account_name = module.storage.name
  admin_email          = "admin@${var.project_name}.com" # Default or variable
}

module "swa" {
  source              = "./modules/static-web-app"
  project_name        = var.project_name
  environment         = var.environment
  location            = var.swa_location
  resource_group_name = module.rg.name
  tags                = local.tags
}
